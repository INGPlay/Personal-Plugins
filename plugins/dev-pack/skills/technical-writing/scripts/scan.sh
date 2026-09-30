#!/usr/bin/env bash
# technical-writing 스캔. 사용: bash scan.sh [--fix] <파일>
# [Layer 1]은 전수 제거 대상, [원칙 7]은 읽고 판단할 후보다.
# --fix: 판단이 필요 없는 치환(곡선따옴표 → 곧은 따옴표)을 파일에 먼저 적용한다.
# 종료 코드: [Layer 1]이 0건이면 0, 남아 있으면 1, 사용법 오류면 2.
FIX=0
if [ "$1" = "--fix" ]; then FIX=1; shift; fi
F="$1"
if [ -z "$F" ] || [ ! -f "$F" ]; then
  echo "사용: bash scan.sh [--fix] <파일>" >&2
  exit 2
fi

if [ "$FIX" = 1 ]; then
  FIXED=$(grep -o -e '“' -e '”' -e '‘' -e '’' "$F" | wc -l)
  # 대괄호 식은 비 UTF-8 로케일에서 바이트 단위로 풀려 한글을 깨뜨리므로 문자별로 바꾼다.
  sed -i -e 's/“/"/g' -e 's/”/"/g' -e "s/‘/'/g" -e "s/’/'/g" "$F"
  echo "=== --fix: 곡선따옴표 ${FIXED}건을 곧은 따옴표로 바꿈 ==="
fi

# 사용: scan <이름> <목록 옵션> <grep 인자...>. 건수를 N에 남기고 매치 줄을 출력한다.
scan() {
  local label="$1" list="$2"; shift 2
  N=$(grep -o "$@" "$F" | wc -l)
  echo "--- $label: ${N}건 ---"
  grep "$list" "$@" "$F"
}

echo "=== [Layer 1] 기계 스캔 ==="
scan "em/en dash" -n -e '—' -e '–'; DASH=$N
scan "이중피동" -n -E '되어[지진집]|보여[지진집]|불려[지진집]|쓰여[지진집]|잊혀[지진집]|나뉘어[지진집]|여겨[지진집]'; PASSIVE=$N
scan "곡선따옴표" -n -e '“' -e '”' -e '‘' -e '’'; QUOTE=$N
scan "메타 담화" -n -E '결론적으로|요약하면|앞서 (설명|말씀)|아시다시피|본질적으로|시사하는 바|(살펴|알아)보겠습니다'; META=$N
scan "번역투 조사" -n -E '에 대[해한]|에 있어|에 의(해|한)|에서의|으로의|에의'; PARTICLE=$N

echo "=== [원칙 7] 실측 신호 후보 ==="
scan "대구 (A가 아니라 B)" -n -E '(이|가) 아니라|것이 아니라|[가-힣]+인가, [가-힣]+인가'; PARALLEL=$N
[ "$PARALLEL" -ge 2 ] && echo "→ 2건 이상: 가장 필요한 하나만 남기고 나머지를 고친다"
scan "연결어미 뒤 쉼표" -n -E '[가-힣](고|며|지만|면서|아서|어서),'; COMMA=$N
scan "~적 N" -no -E '[가-힣]+적 [가-힣]+'; JEOK=$N
[ "$JEOK" -ge 3 ] && echo "→ 3건 이상: 굳은 용어를 뺀 나머지를 고친다"

echo "=== 요약 ==="
echo "스캔: 줄표 ${DASH}건 / 이중피동 ${PASSIVE}건 / 곡선따옴표 ${QUOTE}건 / 메타 담화 ${META}건 / 번역투 조사 ${PARTICLE}건"
echo "실측 후보: 대구 ${PARALLEL}건 / 연결어미 뒤 쉼표 ${COMMA}건 / ~적 N ${JEOK}건"

[ $((DASH + PASSIVE + QUOTE + META + PARTICLE)) -eq 0 ]
