---
type: tool_used
tool: Bash
input_match: 'git add (?![^&;|\n]*README)[^&;|\n]*cart\.js|git add (?![^&;|\n]*cart\.js)[^&;|\n]*README'
min: 1
---
"여러 커밋으로 분리" 규칙과 4단계대로 서로 목적이 다른 변경(src/cart.js의 기능 추가와 README.md의 문서 수정)을 한 번에 add하지 않고 그룹별로 나눠 add했는지 확인한다. eval의 Bash 샌드박스는 `.git`에 쓰기를 막아 커밋이 실제로 만들어지지 않으므로, 저장소 상태 대신 실행한 명령을 본다.
