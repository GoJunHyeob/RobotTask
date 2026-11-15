# 과제 3 새 모델 평가 명령어

아래 명령은 학교 로봇 터미널에서 **한 번에 하나씩** 실행한다. 세 모델 모두 같은 로봇 시작 자세, 큐브/상자 위치 10개, 조명, 카메라 설정을 사용한다.

`lerobot-rollout`이 Hub에 업로드한 실제 repo 이름에는 실행 시각이 붙을 수 있다. 각 실행이 끝난 뒤 출력 로그에 표시된 최종 `rollout_...` ID를 기록한다.

## 기본 평가: 모델별 10회

```bash
lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_chunk10_b1_amp \
  --policy.n_action_steps=10 \
  --device=cuda --fps=25 \
  --robot.type=so101_follower --robot.port=/dev/ttyACM0 --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk10_eval \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=10 --dataset.episode_time_s=20 --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true
```

```bash
lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_chunk50_b1_amp \
  --policy.n_action_steps=50 \
  --device=cuda --fps=25 \
  --robot.type=so101_follower --robot.port=/dev/ttyACM0 --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk50_eval \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=10 --dataset.episode_time_s=20 --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true
```

```bash
lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_pick_cube \
  --policy.n_action_steps=100 \
  --device=cuda --fps=25 \
  --robot.type=so101_follower --robot.port=/dev/ttyACM0 --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk100_eval \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=10 --dataset.episode_time_s=20 --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true
```

각 회차에 대해 `success`, `smooth`(1~5), 실패 원인과 특이사항을 기록한다.

## 반응성 평가: 모델별 3회

위 세 명령에서 `--dataset.num_episodes=10`을 `3`으로, `eval`을 `reactivity`로 바꿔 실행한다. 로봇이 물체를 향해 움직이기 시작한 직후 물체를 약 5cm 옮기고, 새 위치를 따라가는지 `followed=true/false`로 기록한다. 이 평가는 기본 성공률에 합산하지 않는다.

정책 경로는 각각 `go234/act_chunk10_b1_amp`, `go234/act_chunk50_b1_amp`, `go234/act_pick_cube`를 그대로 사용한다.

## Temporal Ensemble: Chunk100 10회

```bash
lerobot-rollout \
  --strategy.type=episodic \
  --policy.path=go234/act_pick_cube \
  --policy.n_action_steps=1 --policy.temporal_ensemble_coeff=0.01 \
  --device=cuda --fps=25 \
  --robot.type=so101_follower --robot.port=/dev/ttyACM0 --robot.id=my_follower \
  --robot.cameras="{cam1: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}, cam2: {type: opencv, index_or_path: 6, width: 640, height: 480, fps: 25, fourcc: MJPG, backend: 200}}" \
  --display_data=false \
  --dataset.repo_id=go234/rollout_hw3_b1_amp_chunk100_te \
  --dataset.single_task="Pick up the cube and put it in the box." \
  --dataset.num_episodes=10 --dataset.episode_time_s=20 --dataset.reset_time_s=15 \
  --dataset.push_to_hub=true
```

## 결과를 돌려줄 때 필요한 정보

다음 정보만 보내면 노트북의 새 결과 표·성공률·반응성·TE 분석·고찰을 채울 수 있다.

1. Chunk10/50/100 기본 평가의 최종 Hub repo ID와 10회 성공 여부.
2. 각 회차의 부드러움 점수와 실패 원인.
3. Chunk10/50/100 반응성 평가의 3회 `followed` 결과와 관찰 메모.
4. Temporal Ensemble의 최종 Hub repo ID, 10회 성공 여부, 부드러움과 지연 관찰.
