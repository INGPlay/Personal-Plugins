---
type: regex
target:
  source: file
  path: test/coupon.test.js
pattern: '2026-03-31T'
---
4단계대로 만료일 당일을 고정하는 회귀 테스트를 남겼는지 확인한다. 기존 테스트에는 만료일 당일의 시각이 없다.
