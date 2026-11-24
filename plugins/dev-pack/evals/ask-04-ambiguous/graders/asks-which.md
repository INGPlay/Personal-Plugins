---
type: regex
target: last_message
pattern: '(어느|어떤|어떤 것|무엇)[^\n]{0,80}[?？]'
match: contains
---
1단계대로 해석이 여러 갈래로 갈리는 질문(결제·세션·배치 타임아웃 중 무엇인지)을 추측으로 정하지 않고, AskUserQuestion을 쓸 수 없으므로 선택지를 텍스트로 제시해 어느 쪽인지 되물었는지 확인한다.
