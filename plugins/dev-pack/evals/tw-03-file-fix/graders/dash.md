---
type: regex
target:
  source: file
  path: docs/release-note.md
pattern: '[—–]'
match: not_contains
---
Layer 1 규칙대로 줄표(em/en dash)를 하나도 남기지 않았는지 확인한다.
