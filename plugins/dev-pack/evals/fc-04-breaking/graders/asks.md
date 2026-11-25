---
type: regex
target: last_message
pattern: '까요\s*[?？]|(어느|어떤)[^\n]{0,60}[?？]|(정해|알려|골라|선택해|결정해|확인해) ?주'
match: contains
---
2단계대로 처리 방침을 사용자에게 물었는지 확인한다. AskUserQuestion을 막았으므로 텍스트로 묻는다.
