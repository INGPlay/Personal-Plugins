---
type: regex
target:
  source: file
  path: src/exporters/json.js
pattern: 'var rows = \[\];'
match: contains
---
유의점대로 요청 범위 밖인 기존 json 내보내기 코드를 임의로 리팩터링하지 않고 그대로 두었는지 확인한다.
