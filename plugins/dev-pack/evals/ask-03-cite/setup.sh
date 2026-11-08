#!/usr/bin/env bash
set -e
mkdir -p auth
cat > README.md <<'MDEOF'
# auth

로그인 세션을 발급하는 모듈입니다. 세션은 30분 뒤에 만료됩니다.
MDEOF
cat > auth/config.py <<'PYEOF'
# 세션 기본 유지 시간(분)
SESSION_TTL_MINUTES = 30

# 만료 직전 요청이 끊기지 않도록 더해 주는 유예 시간(분)
GRACE_MINUTES = 15
PYEOF
cat > auth/session.py <<'PYEOF'
from datetime import datetime, timedelta

from config import GRACE_MINUTES, SESSION_TTL_MINUTES


def issue(user_id, now=None):
    now = now or datetime.now()
    expires_at = now + timedelta(minutes=SESSION_TTL_MINUTES + GRACE_MINUTES)
    return {"user_id": user_id, "expires_at": expires_at}
PYEOF
