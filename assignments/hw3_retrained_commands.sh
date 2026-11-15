#!/usr/bin/env bash
# 참고용 명령 모음. 필요한 명령만 학교 로봇 터미널에서 개별 실행. 일괄 실행 금지.
exit 0
lerobot-train \
  --dataset.repo_id=go234/cube-box_20261013_041703 \
  --policy.type=act \
  --policy.chunk_size=10 \
  --policy.n_action_steps=10 \
  --policy.device=cuda \
  --policy.use_amp=true \
  --batch_size=1 \
  --steps=100000 \
  --seed=1000 \
  --output_dir=outputs/train/act_chunk10_b1_amp \
  --job_name=act_chunk10_b1_amp \
  --policy.repo_id=go234/act_chunk10_b1_amp

lerobot-train \
  --dataset.repo_id=go234/cube-box_20261013_041703 \
  --policy.type=act \
  --policy.chunk_size=50 \
  --policy.n_action_steps=50 \
  --policy.device=cuda \
  --policy.use_amp=true \
  --batch_size=1 \
  --steps=100000 \
  --seed=1000 \
  --output_dir=outputs/train/act_chunk50_b1_amp \
  --job_name=act_chunk50_b1_amp \
  --policy.repo_id=go234/act_chunk50_b1_amp

lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_chunk10_b1_amp \
  --policy.n_action_steps=10 \
  --device=cuda \
  --fps=25 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk10_eval \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=10 \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true

lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_chunk50_b1_amp \
  --policy.n_action_steps=50 \
  --device=cuda \
  --fps=25 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk50_eval \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=10 \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true

lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_pick_cube \
  --policy.n_action_steps=100 \
  --device=cuda \
  --fps=25 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk100_eval \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=10 \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true

lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_chunk10_b1_amp \
  --policy.n_action_steps=10 \
  --device=cuda \
  --fps=25 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk10_reactivity \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=3 \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true

lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_chunk50_b1_amp \
  --policy.n_action_steps=50 \
  --device=cuda \
  --fps=25 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk50_reactivity \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=3 \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true

lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_pick_cube \
  --policy.n_action_steps=100 \
  --device=cuda \
  --fps=25 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk100_reactivity \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=3 \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true

lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_pick_cube \
  --policy.n_action_steps=1 \
  --policy.temporal_ensemble_coeff=0.01 \
  --device=cuda \
  --fps=25 \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM0 \
  --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk100_te \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=10 \
  --dataset.episode_time_s=20 \
  --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true
