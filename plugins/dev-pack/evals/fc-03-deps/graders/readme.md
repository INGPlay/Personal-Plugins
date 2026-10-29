---
type: regex
target:
  source: file
  path: README.md
pattern: '5만 원|50,000원|50000원'
match: not_contains
---
4단계대로 README에 남은 옛 기준 설명을 고쳤는지 확인한다.
