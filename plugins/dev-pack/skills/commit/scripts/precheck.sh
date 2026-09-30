#!/usr/bin/env bash
# commit 사전 점검. 사용: bash precheck.sh
# 변경 파일을 staged/unstaged/untracked로 나눠 보이고, 그중 민감 파일을 골라낸다.
G() { git -c core.quotepath=off "$@"; }

# diff는 루트 기준 경로, ls-files는 현재 폴더 아래만 보므로 저장소 루트에서 돈다.
ROOT=$(git rev-parse --show-toplevel) || exit 2
cd "$ROOT" || exit 2

STAGED=$(G diff --cached --name-only)
UNSTAGED=$(G diff --name-only)
UNTRACKED=$(G ls-files --others --exclude-standard)

if [ -z "$STAGED$UNSTAGED$UNTRACKED" ]; then
  echo "변경 없음"
  exit 0
fi

show() { echo "=== $1 ==="; if [ -n "$2" ]; then echo "$2"; else echo "(없음)"; fi; }
show "staged" "$STAGED"
show "unstaged" "$UNSTAGED"
show "untracked" "$UNTRACKED"

# 민감 파일: .env(.example 등 견본 제외), application-*.yml/properties, credential·secret, 키·인증서
SENSITIVE=$(printf '%s\n' "$STAGED" "$UNSTAGED" "$UNTRACKED" | sort -u | grep -iE \
  '(^|/)\.env(\.[^/]*)?$|(^|/)application-[^/]*\.(ya?ml|properties)$|credential|secret|\.(pem|key|p12|pfx|jks|keystore|crt|cer)$|(^|/)id_(rsa|dsa|ecdsa|ed25519)$' \
  | grep -viE '\.env\.(example|sample|template)$')
show "민감 파일" "$SENSITIVE"
exit 0
