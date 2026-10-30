---
type: regex
target:
  source: file
  path: test/coupon.test.js
pattern: 'rate: 10 }\), 10800\)'
---
4단계의 통과 기준대로 버그와 무관한 기존 동작(정률 쿠폰)의 테스트가 그대로 남아 있는지 확인한다.
