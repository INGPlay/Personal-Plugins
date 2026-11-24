#!/usr/bin/env bash
set -e
mkdir -p shop && cd shop
cat > payment.py <<'PYEOF'
# 결제 대행사 API 호출이 응답을 기다리는 최대 시간(초)
GATEWAY_TIMEOUT = 10


def charge(client, order):
    return client.post("/charge", json=order, timeout=GATEWAY_TIMEOUT)
PYEOF
cat > session.py <<'PYEOF'
# 로그인 세션이 아무 요청 없이 유지되는 시간(초)
IDLE_TIMEOUT = 1800


def is_expired(last_seen, now):
    return now - last_seen > IDLE_TIMEOUT
PYEOF
cat > batch.py <<'PYEOF'
# 야간 정산 배치 한 건이 실행될 수 있는 최대 시간(초)
JOB_TIMEOUT = 600


def run(job):
    return job.execute(timeout=JOB_TIMEOUT)
PYEOF
