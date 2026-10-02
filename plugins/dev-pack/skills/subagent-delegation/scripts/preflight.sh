#!/usr/bin/env bash
# subagent-delegation 사전 점검. 사용: bash preflight.sh
# 워크트리 위임에 필요한 조건을 보여 준다. 아무것도 바꾸지 않는다.
ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "git 저장소 아님: 위임 불가"; exit 2; }
cd "$ROOT" || exit 2

echo "=== 기준점 ==="
BR="$(git branch --show-current 2>/dev/null)"
echo "브랜치: ${BR:-(detached)}"
echo "HEAD: $(git rev-parse --short HEAD)"

echo "=== 작업 트리 ==="
DIRTY="$(git status --porcelain)"
if [ -z "$DIRTY" ]; then
  echo "깨끗함"
else
  echo "커밋 안 된 변경 있음 (워크트리로 넘어가지 않는다):"
  echo "$DIRTY"
fi

echo "=== worktree.baseRef ==="
# 우선순위: 프로젝트 로컬 > 프로젝트 공유 > 사용자
VAL=""; SRC=""
for f in .claude/settings.local.json .claude/settings.json "$HOME/.claude/settings.json"; do
  [ -f "$f" ] || continue
  if command -v jq >/dev/null; then
    v="$(jq -r '.worktree.baseRef // empty' "$f" 2>/dev/null)"
  else
    v="$(grep -oE '"baseRef"[[:space:]]*:[[:space:]]*"[a-z]+"' "$f" | grep -oE '"[a-z]+"$' | tr -d '"')"
  fi
  if [ -n "$v" ]; then VAL="$v"; SRC="$f"; break; fi
done
if [ "$VAL" = "head" ]; then
  echo "head ($SRC): 현재 HEAD에서 분기"
else
  echo "${VAL:-fresh(기본값)}${SRC:+ ($SRC)}: 원격 기본 브랜치에서 분기 -> 위임 불가, \"head\"로 설정 필요"
fi

echo "=== .claude/worktrees/ gitignore ==="
if git check-ignore -q .claude/worktrees/x 2>/dev/null; then
  echo "무시됨"
else
  echo "무시 안 됨: 메인 체크아웃에 미추적 파일로 보인다"
fi

echo "=== 워크트리로 안 넘어가는 설정 파일 ==="
# 저장소 루트의 gitignore된 .env 계열만 본다
IGN="$(for f in .env .env.*; do [ -f "$f" ] && git check-ignore -q "$f" && echo "$f"; done)"
if [ -z "$IGN" ]; then
  echo "(없음)"
else
  echo "$IGN"
  if [ -f .worktreeinclude ]; then echo ".worktreeinclude 있음"; else echo ".worktreeinclude 없음: 워크트리에는 위 파일이 없다"; fi
fi
