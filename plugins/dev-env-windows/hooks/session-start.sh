#!/usr/bin/env bash
# Claude Code SessionStart 훅 (Windows + Git Bash 전용, 다른 OS에서는 아무것도 하지 않는다)
# 1. git-bash-shell.md의 셸 규칙을 출력해 세션 컨텍스트에 넣는다.
# 2. PYTHONUTF8=1을 CLAUDE_ENV_FILE에 한 번만 기록한다. Windows에서 Python 표준 입출력이
#    cp949로 잡혀 한글이 깨지는 문제를 막는다.

case "$OSTYPE" in
  msys* | cygwin*) ;;
  *) exit 0 ;;
esac

cat "$(dirname "$0")/git-bash-shell.md"

line='export PYTHONUTF8=1'
if [ -n "$CLAUDE_ENV_FILE" ] && ! grep -qxF "$line" "$CLAUDE_ENV_FILE" 2>/dev/null; then
  echo "$line" >> "$CLAUDE_ENV_FILE"
fi

exit 0
