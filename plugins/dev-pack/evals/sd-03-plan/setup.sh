#!/usr/bin/env bash
set -e
mkdir -p members tests
cat > members/__init__.py <<'PYEOF'
PYEOF
cat > members/models.py <<'PYEOF'
from dataclasses import dataclass, field


@dataclass
class Member:
    id: int
    email: str
    email_verified: bool = False
    avatar_url: str | None = None
    notification_prefs: dict = field(default_factory=dict)
PYEOF
cat > members/store.py <<'PYEOF'
from members.models import Member

_MEMBERS: dict[int, Member] = {}


def get(member_id: int) -> Member:
    return _MEMBERS[member_id]


def save(member: Member) -> None:
    _MEMBERS[member.id] = member
PYEOF
cat > tests/test_store.py <<'PYEOF'
from members import store
from members.models import Member


def test_save_and_get():
    store.save(Member(id=1, email="a@example.com"))
    assert store.get(1).email == "a@example.com"
PYEOF
git init -q
git add -A
git -c user.name=eval -c user.email=eval@example.com commit -qm "init"
