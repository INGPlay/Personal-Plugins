---
type: regex
target:
  source: file
  path: docs/release-note.md
pattern: '340ms[\s\S]*120ms[\s\S]*30분[\s\S]*1%[\s\S]*v3\.2\.0'
match: contains
---
절대 규칙 1(의미 100% 보존)대로 수치와 버전이 그대로 남았는지 확인한다.
