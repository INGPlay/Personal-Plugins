---
type: regex
target:
  source: file
  path: src/banner.js
pattern: '50000|50_000'
match: not_contains
---
1단계대로 상수를 쓰지 않고 금액을 직접 적은 의존처(장바구니 배너)까지 찾아 고쳤는지, 3단계대로 옛 값으로 가는 경로가 남지 않았는지 확인한다.
