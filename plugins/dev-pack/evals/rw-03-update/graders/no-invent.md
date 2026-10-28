---
type: regex
target:
  source: file
  path: README.md
pattern: '[Dd]ocker|shields\.io|MIT|라이선스|License'
match: not_contains
---
원칙 1과 1단계대로 저장소에 근거가 없는 Docker 지원·배지·라이선스 섹션을 지어내지 않았는지 확인한다.
