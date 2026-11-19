#!/usr/bin/env bash
set -e
mkdir -p src test
cat > package.json <<'JSONEOF'
{
  "name": "mini-shop",
  "version": "0.4.1",
  "scripts": { "test": "node --test" },
  "engines": { "node": ">=20" }
}
JSONEOF
cat > src/coupon.js <<'JSEOF'
// coupon: { type: 'fixed', amount } 또는 { type: 'percent', rate }
const discountFor = (subtotal, coupon) =>
  coupon.type === 'percent' ? Math.floor((subtotal * coupon.rate) / 100) : coupon.amount;

exports.payAmount = (subtotal, coupon) =>
  coupon ? Math.max(0, subtotal - discountFor(subtotal, coupon)) : subtotal;
JSEOF
cat > test/coupon.test.js <<'JSEOF'
const test = require('node:test');
const assert = require('node:assert');
const { payAmount } = require('../src/coupon');

test('쿠폰이 없으면 주문 금액 그대로', () => {
  assert.strictEqual(payAmount(12000), 12000);
});

test('정액 쿠폰은 금액만큼 뺀다', () => {
  assert.strictEqual(payAmount(12000, { type: 'fixed', amount: 5000 }), 7000);
});

test('할인이 주문 금액보다 크면 0원', () => {
  assert.strictEqual(payAmount(3000, { type: 'fixed', amount: 5000 }), 0);
});
JSEOF
