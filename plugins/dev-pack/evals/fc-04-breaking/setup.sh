#!/usr/bin/env bash
set -e
mkdir -p src data docs test
cat > package.json <<'JSONEOF'
{
  "name": "mini-shop",
  "version": "0.7.0",
  "scripts": { "test": "node --test" },
  "engines": { "node": ">=20" }
}
JSONEOF
cat > src/order.js <<'JSEOF'
const STATUSES = ['pending', 'paid', 'done'];

exports.changeStatus = (order, status) => {
  if (!STATUSES.includes(status)) throw new Error(`알 수 없는 상태: ${status}`);
  return { ...order, status };
};

exports.isFinished = (order) => order.status === 'done';
JSEOF
cat > src/store.js <<'JSEOF'
const fs = require('node:fs');
const path = require('node:path');

const FILE = path.join(__dirname, '../data/orders.json');

exports.loadOrders = () => JSON.parse(fs.readFileSync(FILE, 'utf8'));
JSEOF
cat > src/webhook.js <<'JSEOF'
// 정산 파트너에게 보내는 주문 상태 알림
exports.buildPayload = (order) => ({ orderId: order.id, status: order.status });
JSEOF
cat > data/orders.json <<'JSONEOF'
[
  { "id": 1001, "total": 12000, "status": "done" },
  { "id": 1002, "total": 45000, "status": "paid" },
  { "id": 1003, "total": 8000, "status": "done" }
]
JSONEOF
cat > docs/partner-webhook.md <<'MDEOF'
# 정산 파트너 웹훅

주문 상태가 바뀌면 파트너 시스템에 다음 형식으로 전송합니다.

| 필드 | 값 |
|---|---|
| `orderId` | 주문 번호 |
| `status` | `pending`, `paid`, `done` |

파트너 시스템은 `status`가 `done`이면 정산을 시작합니다.
MDEOF
cat > test/order.test.js <<'JSEOF'
const test = require('node:test');
const assert = require('node:assert');
const { changeStatus, isFinished } = require('../src/order');
const { buildPayload } = require('../src/webhook');

test('done 상태면 완료된 주문이다', () => {
  assert.strictEqual(isFinished(changeStatus({ id: 1 }, 'done')), true);
  assert.strictEqual(isFinished({ id: 2, status: 'paid' }), false);
});

test('웹훅에 주문 상태를 담는다', () => {
  assert.deepStrictEqual(buildPayload({ id: 1, status: 'done' }), { orderId: 1, status: 'done' });
});
JSEOF
git init -q
git config user.name eval
git config user.email eval@example.com
printf 'setup.sh\n' >> .git/info/exclude
git add -A
git commit -qm "chore: 초기 구성"
