---
type: regex
target: last_message
pattern: '\bpnpm\b'
match: contains
---
2단계대로 명령을 추측하지 않고 저장소의 실제 정의(lockfile로 본 패키지 매니저, CI가 실행하는 명령)에서 확인해 `pnpm` 명령으로 보고했는지 확인한다.
