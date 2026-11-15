과제 3 재학습 반영판 (2026-11-15)

assignment_3.ipynb: 저장소 제출 경로의 최신 개정본.
assignment_3_retrained_20261115.ipynb: 새 이름의 동일 개정본.
archive_hw3/assignment_3_initial_results.ipynb: 초기 보고서·코드·출력을 원본 그대로 보존.
archive_hw3/assignment_3_uploaded_template.ipynb: 이번 첨부 양식 원본.
images/, evidence_hw3/: 초기 GIF·손실 자료와 새 공개 설정·실행 검증 기록.
hw3_retrained_commands.sh: 참고 명령 모음. 필요한 명령만 개별 실행 (일괄 실행 방지됨).

확인 사실: 공개 Hub 설정상 세 모델 모두 dataset=go234/cube-box_20261013_041703,
steps=100000, batch_size=1, seed=1000, AMP=true. Chunk100은 go234/act_pick_cube 재사용.
관찰: 사용자가 학교 안전 테스트에서 “저번보다 훨씬 낫다”고 보고. 정량 평가로 환산하지 않음.
미평가: 새 기본 30회, 반응성 9회, TE 10회. 초기 결과는 각각 0/10, 0/3, TE 0/10으로 분리 보존.
실행: 새 보고서 Python 셀 9개를 순서대로 실행, 오류 0개, 실제 출력 저장. 로봇 학습/평가는 실행하지 않음.
남은 평가: 명령 실행 후 실제 타임스탬프 포함 Hub repo_id, 회차별 성공/부드러움/반응성,
TE 관찰 및 추론 지연, 새 손실 로그를 입력하고 노트북을 재실행.
