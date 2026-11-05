#!/usr/bin/env bash
# Claude Code PreToolUse 훅 (Windows + Git Bash 전용, 다른 OS에서는 아무것도 하지 않는다)
# MSYS 런타임의 인자 glob 처리가 bash -c 문자열을 8,186자에서 오류 없이 자른다. 잘린 명령은 대개
# 문법 오류로 끝나지만 앞부분만 실행되고 성공으로 끝나기도 하므로, 잘릴 길이의 명령을 미리 차단한다.
#
# 입력 JSON 전체의 문자 수에 작은따옴표 증가분(도구가 '를 '"'"'로 바꿔 하나당 4자)을 더해 추정한다.
# JSON 전체는 명령보다 약 650자 길고, 도구는 명령 앞에 약 1,100자를 붙인다.
# 기준값 7,100은 8,186에서 1,100을 빼고 메타데이터 650을 더한 뒤 약 600자의 여유를 둔 값이다.

case "$OSTYPE" in
  msys* | cygwin*) ;;
  *) exit 0 ;;
esac

limit=7100

IFS= read -r -d '' input
quotes=${input//[^\']/}
estimate=$((${#input} + ${#quotes} * 4))

if [ "$estimate" -le "$limit" ]; then
  exit 0
fi

reason="Bash 명령이 너무 깁니다(추정 ${estimate}, 기준 ${limit}). Windows에서는 bash -c 문자열이 8,186자에서 잘립니다. 같은 명령을 다시 보내지 말고, Write로 스크립트 파일을 만든 뒤 실행하거나 Edit으로 수정하세요."
printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","permissionDecisionReason":"%s"}}\n' "$reason"
exit 0
