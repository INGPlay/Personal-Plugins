---
type: regex
target:
  source: file
  path: src/shipping.js
pattern: 'BASE_FEE = 3000;'
match: contains
---
5단계의 통과 기준대로 바뀌면 안 되는 주변 동작(기본 배송비 3000원)이 그대로인지 확인한다.
