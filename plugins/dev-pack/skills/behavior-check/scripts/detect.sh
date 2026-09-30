#!/usr/bin/env bash
# behavior-check 명령 탐지. 사용: bash detect.sh [저장소 루트, 기본 git 루트]
# 저장소에 정의된 build·lint·test 명령 후보를 보여 준다. 아무것도 실행하지 않는다.
ROOT="${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}"
cd "$ROOT" || exit 2

echo "=== package.json scripts ==="
if [ -f package.json ]; then
  LOCK=""
  for l in pnpm-lock.yaml yarn.lock package-lock.json bun.lockb bun.lock; do
    [ -f "$l" ] && LOCK="${LOCK:+$LOCK }$l"
  done
  echo "(lockfile: ${LOCK:-없음})"
  if command -v node >/dev/null; then
    node -e 'const s=require("./package.json").scripts||{};for(const[k,v]of Object.entries(s))console.log(k+": "+v)'
  else
    echo "(node 없음: package.json의 scripts를 직접 읽는다)"
  fi
else
  echo "(없음)"
fi

echo "=== Makefile 타깃 ==="
if [ -f Makefile ]; then
  grep -oE '^[A-Za-z0-9_.-]+::?([^:=]|$)' Makefile | sed 's/:.*//' | grep -v '^\.' | sort -u
else
  echo "(없음)"
fi

echo "=== 빌드 도구 ==="
FOUND=0
for f in gradlew mvnw pom.xml build.gradle build.gradle.kts Cargo.toml go.mod pyproject.toml setup.cfg tox.ini noxfile.py pytest.ini justfile Taskfile.yml; do
  [ -f "$f" ] && echo "$f" && FOUND=1
done
[ "$FOUND" = 0 ] && echo "(없음)"
if [ -f pyproject.toml ]; then
  echo "--- pyproject.toml [tool.*] ---"
  grep -oE '^\[tool\.[A-Za-z0-9_-]+' pyproject.toml | sed 's/^\[//' | sort -u
fi

echo "=== CI에서 실행하는 명령 ==="
CI=$(ls .github/workflows/*.yml .github/workflows/*.yaml .gitlab-ci.yml 2>/dev/null)
if [ -n "$CI" ]; then
  grep -nE '^\s*(- )?run:|^\s*script:' $CI
else
  echo "(없음)"
fi
exit 0
