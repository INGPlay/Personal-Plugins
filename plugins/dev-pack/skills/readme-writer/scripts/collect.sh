#!/usr/bin/env bash
# readme-writer 사실 수집. 사용: bash collect.sh [저장소 루트, 기본 git 루트]
# 부작용 없는 확인만 한다. 여기 없는 항목은 README에 근거가 없다는 뜻이다.
cd "${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}" || exit 2

# 사용: list <제목> <find 인자...>. 저장소 루트 기준 깊이 2까지, .git·node_modules 제외.
list() {
  local label="$1"; shift
  echo "=== $label ==="
  local out
  out=$(find . -maxdepth 2 \( -name .git -o -name node_modules \) -prune -o -type f \( "$@" \) -print | sed 's|^\./||' | sort)
  if [ -n "$out" ]; then echo "$out"; else echo "(없음)"; fi
}

echo "=== 기존 README ==="
README=$(ls README.md README.rst docs/README.md 2>/dev/null)
if [ -n "$README" ]; then echo "$README"; else echo "(없음)"; fi

echo "=== 클론 URL ==="
git remote get-url origin 2>/dev/null || echo "(리모트 없음: 자리표시자 유지)"

echo "=== 최상위 항목 ==="
ls -Ap | grep -v '^\.git/$'

list "의존성 매니페스트" -name package.json -o -name requirements.txt -o -name pyproject.toml -o -name setup.py \
  -o -name pom.xml -o -name build.gradle -o -name build.gradle.kts -o -name go.mod -o -name Cargo.toml -o -name Gemfile \
  -o -name composer.json -o -name '*.csproj'
list "실행 관련 파일" -name Makefile -o -name Dockerfile -o -name 'docker-compose*.yml' -o -name 'compose*.yml' \
  -o -name '*.sh' -o -name '*.bat' -o -name '*.ps1'
list "환경 변수 견본" -name '.env.example' -o -name '.env.sample' -o -name '.env.template'
for f in .env.example .env.sample .env.template; do
  [ -f "$f" ] && echo "--- $f 키 ---" && grep -oE '^[A-Za-z_][A-Za-z0-9_]*=' "$f" | tr -d '='
done

echo "=== 라이선스 ==="
LIC=$(ls -d LICENSE* LICENCE* COPYING* 2>/dev/null)
if [ -n "$LIC" ]; then
  for f in $LIC; do
    if [ -f "$f" ]; then echo "$f: $(grep -m1 -v '^[[:space:]]*$' "$f")"; else echo "$f/"; fi
  done
else
  echo "(없음: 라이선스 섹션을 넣지 않는다)"
fi

echo "=== CI 설정 ==="
CI=$(ls .github/workflows/* .gitlab-ci.yml Jenkinsfile .circleci/config.yml azure-pipelines.yml 2>/dev/null)
if [ -n "$CI" ]; then echo "$CI"; else echo "(없음: CI 배지·테스트 언급을 넣지 않는다)"; fi
exit 0
