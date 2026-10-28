---
type: regex
target:
  source: file
  path: README.md
pattern: 'npm run serve'
match: not_contains
---
0단계의 (3)대로 package.json에서 사라진 `serve` 스크립트를 실제 스크립트로 고쳤는지 확인한다.
