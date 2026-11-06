---
type: regex
target:
  source: file
  path: src/exporters/index.js
pattern: '\bcsv[''"]?\s*:'
match: contains
---
1단계와 3단계대로 코드베이스의 확장 지점(내보내기 형식 등록부)에 새 형식을 등록해 기존 패턴에 붙였는지 확인한다. cli.js에 분기를 따로 만들면 등록부를 거치지 않으므로 통과하지 못한다.
