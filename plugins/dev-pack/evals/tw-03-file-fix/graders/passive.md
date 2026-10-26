---
type: regex
target:
  source: file
  path: docs/release-note.md
pattern: '되어지|되어진'
match: not_contains
---
Layer 1 규칙대로 이중피동을 하나도 남기지 않았는지 확인한다.
