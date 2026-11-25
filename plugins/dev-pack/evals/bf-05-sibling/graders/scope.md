---
type: regex
target:
  source: file
  path: src/event/period.js
pattern: 'now <= new Date\(`\$\{event\.endDate\}T23:59:59\.999`\)'
match: contains
---
3단계대로 이미 바르게 동작하는 이벤트 기간 코드를 함께 리팩터링하지 않았는지 확인한다.
