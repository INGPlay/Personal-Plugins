#!/usr/bin/env bash
set -e
mkdir -p src/coupon src/points src/giftcard src/event docs test
cat > package.json <<'JSONEOF'
{
  "name": "mini-shop",
  "version": "0.6.0",
  "scripts": { "test": "node --test" },
  "engines": { "node": ">=20" }
}
JSONEOF
cat > src/coupon/usable.js <<'JSEOF'
// coupon: { code, expiresOn: 'YYYY-MM-DD' }
exports.isUsable = (coupon, now) => now < new Date(`${coupon.expiresOn}T00:00:00`);
JSEOF
cat > src/coupon/apply.js <<'JSEOF'
const { isUsable } = require('./usable');

exports.applyCoupon = (coupon, now) => {
  if (!isUsable(coupon, now)) throw new Error('만료된 쿠폰입니다.');
  return { code: coupon.code, appliedAt: now.toISOString() };
};
JSEOF
cat > src/points/balance.js <<'JSEOF'
// lots: [{ amount, validUntil: 'YYYY-MM-DD' }]
exports.availablePoints = (lots, now) =>
  lots
    .filter((lot) => new Date(`${lot.validUntil}T00:00:00`) > now)
    .reduce((sum, lot) => sum + lot.amount, 0);
JSEOF
cat > src/giftcard/redeem.js <<'JSEOF'
// card: { id, balance, endDate: 'YYYY-MM-DD' }
exports.redeem = (card, amount, now) => {
  const end = new Date(`${card.endDate}T00:00:00`);
  if (now >= end) throw new Error('사용 기간이 지난 기프트카드입니다.');
  if (amount > card.balance) throw new Error('잔액이 부족합니다.');
  return { ...card, balance: card.balance - amount };
};
JSEOF
cat > src/event/period.js <<'JSEOF'
// event: { startDate, endDate } 모두 'YYYY-MM-DD'
exports.isOpen = (event, now) =>
  now >= new Date(`${event.startDate}T00:00:00`) && now <= new Date(`${event.endDate}T23:59:59.999`);
JSEOF
cat > docs/policy.md <<'MDEOF'
# 이용 정책

- 쿠폰, 포인트, 기프트카드는 만료일 당일 23시 59분까지 사용할 수 있습니다.
- 이벤트는 종료일 당일 23시 59분까지 참여할 수 있습니다.
MDEOF
cat > test/coupon.test.js <<'JSEOF'
const test = require('node:test');
const assert = require('node:assert');
const { isUsable } = require('../src/coupon/usable');

const coupon = { code: 'SPRING', expiresOn: '2026-03-31' };

test('만료일 전에는 쓸 수 있다', () => {
  assert.strictEqual(isUsable(coupon, new Date('2026-03-30T00:00:00')), true);
});

test('만료일이 지나면 쓸 수 없다', () => {
  assert.strictEqual(isUsable(coupon, new Date('2026-04-01T00:00:00')), false);
});
JSEOF
cat > test/points.test.js <<'JSEOF'
const test = require('node:test');
const assert = require('node:assert');
const { availablePoints } = require('../src/points/balance');

test('기간이 남은 포인트만 더한다', () => {
  const lots = [
    { amount: 1000, validUntil: '2026-01-31' },
    { amount: 500, validUntil: '2026-12-31' },
  ];
  assert.strictEqual(availablePoints(lots, new Date('2026-06-01T00:00:00')), 500);
});
JSEOF
git init -q
git config user.name eval
git config user.email eval@example.com
printf 'setup.sh\n' >> .git/info/exclude
git add -A
git commit -qm "chore: 초기 구성"
