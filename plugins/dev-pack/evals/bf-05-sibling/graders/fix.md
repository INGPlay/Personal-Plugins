---
type: regex
target:
  source: file
  path: src/coupon/usable.js
pattern: 'now\s*<\s*new Date\(`\$\{coupon\.expiresOn\}T00:00:00`\)'
match: not_contains
---
3단계대로 원인(만료일 0시를 기준으로 비교하는 조건)을 쿠폰 판정에서 고쳤는지 확인한다.
