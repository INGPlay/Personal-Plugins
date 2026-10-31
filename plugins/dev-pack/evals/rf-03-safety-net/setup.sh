#!/usr/bin/env bash
set -e
mkdir -p src
cat > package.json <<'JSONEOF'
{
  "name": "mini-shop",
  "version": "0.5.0",
  "scripts": { "test": "node --test" },
  "engines": { "node": ">=20" }
}
JSONEOF
cat > src/order.js <<'JSEOF'
// items: [{ price, qty }]
exports.cartTotal = (items) => {
  let subtotal = 0;
  for (const item of items) {
    subtotal += item.price * item.qty;
  }
  const shipping = subtotal >= 30000 ? 0 : 3000;
  return subtotal + shipping;
};

exports.invoiceTotal = (items, taxRate) => {
  let subtotal = 0;
  for (const item of items) {
    subtotal += item.price * item.qty;
  }
  const shipping = subtotal >= 30000 ? 0 : 3000;
  const tax = Math.floor(((subtotal + shipping) * taxRate) / 100);
  return subtotal + shipping + tax;
};
JSEOF
cat > src/checkout.js <<'JSEOF'
const { cartTotal, invoiceTotal } = require('./order');

exports.summary = (items) => ({
  cart: cartTotal(items),
  invoice: invoiceTotal(items, 10),
});
JSEOF
