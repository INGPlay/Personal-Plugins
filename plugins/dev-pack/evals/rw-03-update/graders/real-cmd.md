---
type: regex
target:
  source: file
  path: README.md
pattern: 'npm run dev|npm test|todo done'
match: contains
---
1단계대로 package.json scripts와 src/index.js에 실제로 있는 명령을 README에 옮겼는지 확인한다.
