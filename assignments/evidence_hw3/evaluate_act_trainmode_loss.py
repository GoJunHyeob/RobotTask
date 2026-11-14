"""LeRobot ACT: 20k/40k/60k/80k/100k checkpoint training-mode loss re-evaluation.

Run from ~/robotArm using the same LeRobot 0.6.0 environment and training dataset.
This does not train or update weights. It evaluates 32 fixed, deterministic dataset
indices, but uses policy.train() so ACT's VAE/KL loss is actually computed.
Sampling/dropout may make the estimates slightly stochastic; they are not original
training log values.
"""

from pathlib import Path
import csv
import gc
import random

import matplotlib.pyplot as plt
import numpy as np
import torch
from torch.utils.data import DataLoader, Subset
from lerobot.datasets import LeRobotDataset, LeRobotDatasetMetadata
from lerobot.policies import make_pre_post_processors
from lerobot.policies.act import ACTPolicy

DATASET_ID = "go234/cube-box_20261013_041703"
CHUNKS = (10, 50, 100)
STEPS = (20000, 40000, 60000, 80000, 100000)
NUM_SAMPLES = 32
OUT_DIR = Path("images")
OUT_DIR.mkdir(parents=True, exist_ok=True)
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"

if DEVICE != "cuda":
    print("[주의] CUDA를 사용할 수 없습니다. CPU에서는 느릴 수 있습니다.")

meta = LeRobotDatasetMetadata(DATASET_ID)
records = []

for chunk in CHUNKS:
    print(f"\n==== Chunk {chunk} ====")
    ckpt_root = Path(f"outputs/train/act_chunk{chunk}/checkpoints")
    final_path = ckpt_root / "100000/pretrained_model"
    config_policy = ACTPolicy.from_pretrained(str(final_path))
    if not config_policy.config.use_vae:
        raise RuntimeError(f"Chunk {chunk}: use_vae=False. KL loss is not applicable.")

    delta_timestamps = {"action": [i / meta.fps for i in range(chunk)]}
    for camera_key in config_policy.config.image_features:
        delta_timestamps[camera_key] = [0.0]
    del config_policy
    gc.collect()

    dataset = LeRobotDataset(DATASET_ID, delta_timestamps=delta_timestamps)
    indices = np.linspace(0, len(dataset) - 1, min(NUM_SAMPLES, len(dataset)), dtype=int).tolist()
    loader = DataLoader(Subset(dataset, indices), batch_size=1, shuffle=False, num_workers=0)
    print(f"Evaluation data: {len(indices)} fixed samples, FPS={meta.fps}")

    for step in STEPS:
        path = ckpt_root / f"{step:06d}/pretrained_model"
        if not path.is_dir():
            raise FileNotFoundError(f"Checkpoint missing: {path}")

        # Reproducible pseudo-random VAE latent samples and dropout per checkpoint.
        random.seed(42)
        np.random.seed(42)
        torch.manual_seed(42)
        if torch.cuda.is_available():
            torch.cuda.manual_seed_all(42)

        policy = ACTPolicy.from_pretrained(str(path))
        policy.to(DEVICE)
        # CRITICAL: ACT's VAE encoder is active in training mode.
        # policy.eval() leaves kld_loss absent, so it must NOT be used here.
        policy.train()
        preprocessor, _ = make_pre_post_processors(
            policy_cfg=policy.config,
            pretrained_path=str(path),
        )

        sum_losses = {"loss": 0.0, "l1_loss": 0.0, "kld_loss": 0.0}
        num_batches = 0
        with torch.no_grad():
            for batch in loader:
                batch = preprocessor(batch)
                loss, metrics = policy.forward(batch)
                if "l1_loss" not in metrics or "kld_loss" not in metrics:
                    raise RuntimeError(
                        f"Missing actual ACT VAE metrics at Chunk {chunk}, step {step}: "
                        f"{list(metrics)}. Do NOT substitute 0 for missing kld_loss."
                    )
                sum_losses["loss"] += float(loss.item())
                sum_losses["l1_loss"] += float(metrics["l1_loss"])
                sum_losses["kld_loss"] += float(metrics["kld_loss"])
                num_batches += 1

        if num_batches == 0:
            raise RuntimeError("No evaluation samples available")

        row = {
            "chunk_size": chunk,
            "step": step,
            "loss": sum_losses["loss"] / num_batches,
            "l1_loss": sum_losses["l1_loss"] / num_batches,
            "kld_loss": sum_losses["kld_loss"] / num_batches,
            "mode": "trainmode_checkpoint_reevaluation",
            "samples": len(indices),
        }
        print(f"Step {step}: {row}", flush=True)
        records.append(row)
        del policy, preprocessor
        gc.collect()
        if torch.cuda.is_available():
            torch.cuda.empty_cache()

csv_path = OUT_DIR / "act_checkpoint_loss_trainmode.csv"
with csv_path.open("w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=list(records[0]))
    writer.writeheader()
    writer.writerows(records)

fig, ax = plt.subplots(figsize=(9, 5))
for chunk in CHUNKS:
    subset = [r for r in records if r["chunk_size"] == chunk]
    ax.plot([r["step"] for r in subset], [r["loss"] for r in subset], marker="o", label=f"Chunk {chunk}")
ax.set(
    xlabel="Checkpoint step",
    ylabel="Training-mode offline loss",
    title="ACT Training-mode Checkpoint Re-evaluation",
)
ax.legend()
ax.grid(alpha=0.3)
fig.tight_layout()
fig.savefig(OUT_DIR / "loss_curve_hw3.png", dpi=180)
plt.close(fig)

print("\nFinal (100k) checkpoint losses:")
for row in records:
    if row["step"] == 100000:
        print(f"Chunk {row['chunk_size']}: l1_loss={row['l1_loss']:.6f}, kld_loss={row['kld_loss']:.6f}")
print("Wrote", csv_path)
print("Wrote", OUT_DIR / "loss_curve_hw3.png")
print("Note: These are checkpoint re-evaluation losses, NOT the original training logs.")
