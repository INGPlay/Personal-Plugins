---
type: regex
target:
  source: file
  path: test/coupon.test.js
pattern: 'strictEqual\([^\n]*,\s*0\s*\)'
---
4단계대로 할인이 주문 금액보다 큰 경우를 고정하는 회귀 테스트(결제 금액 0)를 남겼는지 확인한다.
