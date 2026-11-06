#!/usr/bin/env bash
set -e
mkdir -p src/exporters test
cat > package.json <<'JSONEOF'
{
  "name": "mini-shop",
  "version": "0.6.0",
  "scripts": { "test": "node --test" },
  "engines": { "node": ">=20" }
}
JSONEOF
cat > src/orders.js <<'JSEOF'
// 데모용 주문 데이터
exports.listOrders = () => [
  { id: 'A-100', customer: '김하나', total: 32000, orderedAt: '2026-10-01' },
  { id: 'A-101', customer: '이두리', total: 15000, orderedAt: '2026-10-03' },
];
JSEOF
cat > src/exporters/json.js <<'JSEOF'
// orders: [{ id, customer, total, orderedAt }]
exports.render = function (orders) {
  var rows = [];
  for (var i = 0; i < orders.length; i++) {
    rows.push(orders[i]);
  }
  return JSON.stringify(rows, null, 2);
};
JSEOF
cat > src/exporters/index.js <<'JSEOF'
// 내보내기 형식 등록부: 새 형식은 여기에 render 모듈을 등록한다.
const exporters = {
  json: require('./json'),
};

exports.formats = () => Object.keys(exporters);

exports.exportOrders = (format, orders) => {
  const exporter = exporters[format];
  if (!exporter) {
    throw new Error(`지원하지 않는 형식: ${format} (가능: ${exports.formats().join(', ')})`);
  }
  return exporter.render(orders);
};
JSEOF
cat > src/cli.js <<'JSEOF'
const { listOrders } = require('./orders');
const { exportOrders } = require('./exporters');

const [command, flag, format] = process.argv.slice(2);
if (command !== 'export' || flag !== '--format' || !format) {
  console.error('사용법: node src/cli.js export --format <형식>');
  process.exit(1);
}
process.stdout.write(exportOrders(format, listOrders()) + '\n');
JSEOF
cat > test/exporters.test.js <<'JSEOF'
const test = require('node:test');
const assert = require('node:assert');
const { exportOrders } = require('../src/exporters');

const orders = [{ id: 'A-1', customer: '홍길동', total: 1000, orderedAt: '2026-10-01' }];

test('json 형식으로 내보낸다', () => {
  assert.deepStrictEqual(JSON.parse(exportOrders('json', orders)), orders);
});

test('모르는 형식은 거부한다', () => {
  assert.throws(() => exportOrders('xml', orders), /지원하지 않는 형식/);
});
JSEOF
