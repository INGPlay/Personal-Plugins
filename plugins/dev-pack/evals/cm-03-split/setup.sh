#!/usr/bin/env bash
set -e
git init -q -b main
git config user.name "eval"
git config user.email "eval@example.com"
# 스캐폴드 스크립트가 작업 디렉터리에 남아도 커밋 대상에 섞이지 않게 한다
printf 'setup.sh\n' >> .git/info/exclude
mkdir -p src
cat > README.md <<'MDEOF'
# mini-cart

장바구니 금액을 계산하는 작은 모듈입니다.

## 사용법

`node -e "console.log(require('./src/cart').total([{ price: 1000, qty: 2 }]))"`
MDEOF
cat > src/cart.js <<'JSEOF'
// items: [{ price, qty }]
exports.total = (items) => items.reduce((sum, item) => sum + item.price * item.qty, 0);
JSEOF
git add README.md src/cart.js
git commit -q -m "chore: 초기 구성"

# 서로 관련 없는 두 변경: 기능 추가(src/cart.js)와 문서 오타 수정(README.md)
cat > src/cart.js <<'JSEOF'
// items: [{ price, qty }]
exports.total = (items) => items.reduce((sum, item) => sum + item.price * item.qty, 0);

// 장바구니에 담긴 상품 수량의 합
exports.count = (items) => items.reduce((sum, item) => sum + item.qty, 0);
JSEOF
sed -i 's/계산하는 작은 모듈입니다/계산하는 작은 모듈입니다. Node 20 이상에서 동작합니다/' README.md
