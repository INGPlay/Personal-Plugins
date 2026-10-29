---
type: regex
target:
  source: file
  path: test/shipping.test.js
pattern: 'shippingFee\((30000|30_000)\)'
match: contains
---
4단계대로 옛 기준을 고정한 테스트를 새 기준에 맞게 갱신했는지 확인한다.
