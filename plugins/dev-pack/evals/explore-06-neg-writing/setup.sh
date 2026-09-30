#!/usr/bin/env bash
set -e
mkdir -p shop && cd shop
cat > api.py <<'PYEOF'
from pricing import order_total


def checkout(request):
    total = order_total(request["items"], request.get("grade", "basic"))
    return {"total": total}
PYEOF
cat > discounts.py <<'PYEOF'
RATES = {"basic": 0.0, "silver": 0.05, "gold": 0.1, "vip": -0.15}


def calc_discount(subtotal, grade):
    return int(subtotal * RATES.get(grade, 0.0))
PYEOF
cat > pricing.py <<'PYEOF'
from discounts import calc_discount
from shipping import shipping_fee


def order_total(items, member_grade):
    subtotal = sum(i["price"] * i["qty"] for i in items)
    discount = calc_discount(subtotal, member_grade)
    return subtotal - discount + shipping_fee(subtotal - discount)
PYEOF
cat > shipping.py <<'PYEOF'
FREE_THRESHOLD = 50000
BASE_FEE = 2500


def shipping_fee(amount):
    return 0 if amount >= FREE_THRESHOLD else BASE_FEE
PYEOF
cat > test_pricing.py <<'PYEOF'
from pricing import order_total


def test_basic():
    assert order_total([{"price": 10000, "qty": 1}], "basic") == 12500
PYEOF
