#!/usr/bin/env bash
set -e
mkdir -p shop && cd shop
cat > discounts.py <<'PYEOF'
RATES = {"basic": 0.0, "silver": 0.05, "gold": 0.1, "vip": 0.15}


def calc_discount(subtotal, grade):
    return int(subtotal * RATES.get(grade, 0.0))
PYEOF
cat > pricing.py <<'PYEOF'
from discounts import calc_discount


def order_total(items, member_grade):
    subtotal = sum(i["price"] * i["qty"] for i in items)
    return subtotal - calc_discount(subtotal, member_grade)
PYEOF
