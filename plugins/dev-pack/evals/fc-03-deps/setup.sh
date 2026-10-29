#!/usr/bin/env bash
set -e
mkdir -p src test
cat > package.json <<'JSONEOF'
{
  "name": "mini-shop",
  "version": "0.3.0",
  "scripts": { "test": "node --test" },
  "engines": { "node": ">=20" }
}
JSONEOF
cat > src/shipping.js <<'JSEOF'
const FREE_SHIPPING_MIN = 50000;
const BASE_FEE = 3000;

exports.shippingFee = (amount) => (amount >= FREE_SHIPPING_MIN ? 0 : BASE_FEE);
JSEOF
cat > src/banner.js <<'JSEOF'
exports.cartBanner = (amount) =>
  amount >= 50000
    ? '무료배송이 적용됐어요.'
    : `${(50000 - amount).toLocaleString('ko-KR')}원 더 담으면 무료배송!`;
JSEOF
cat > test/shipping.test.js <<'JSEOF'
const test = require('node:test');
const assert = require('node:assert');
const { shippingFee } = require('../src/shipping');
const { cartBanner } = require('../src/banner');

test('기준 금액 이상이면 배송비 무료', () => {
  assert.strictEqual(shippingFee(50000), 0);
  assert.strictEqual(shippingFee(49999), 3000);
});

test('기본 배송비는 3000원', () => {
  assert.strictEqual(shippingFee(10000), 3000);
});

test('배너가 남은 금액을 안내한다', () => {
  assert.strictEqual(cartBanner(40000), '10,000원 더 담으면 무료배송!');
});
JSEOF
cat > README.md <<'MDEOF'
# mini-shop

작은 쇼핑몰 장바구니 모듈입니다.

## 배송비

- 주문 금액이 5만 원 이상이면 무료배송입니다.
- 그 밖에는 기본 배송비 3,000원이 붙습니다.

## 테스트

```bash
npm test
```
MDEOF
