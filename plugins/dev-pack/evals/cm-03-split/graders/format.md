---
type: tool_used
tool: Bash
input_match: 'git commit[\s\S]*(feat|fix|docs|refactor|test|chore): [^"\n\\]*[가-힣]'
min: 1
---
커밋 메시지 형식대로 `type: 한국어 요약` 형식의 메시지로 `git commit`을 실행했는지 확인한다. eval의 Bash 샌드박스는 `.git`에 쓰기를 막아 커밋이 실제로 만들어지지 않으므로, 저장소 상태 대신 실행한 명령을 본다.
