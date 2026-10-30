---
type: regex
target:
  source: file
  path: src/coupon.js
pattern: 'Math\.(min|max)\(|subtotal\s*[<>]|[<>]=?\s*subtotal|<=?\s*0\b'
---
3단계대로 원인(정액 할인이 주문 금액을 넘는 경우)을 쿠폰 계산에서 고쳤는지 확인한다.
