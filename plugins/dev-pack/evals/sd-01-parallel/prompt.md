---
tags: [subagent-delegation, positive]
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill, Bash]
---

회원 API에 세 가지를 추가해야 해. 서로 다른 모듈이라 독립적이야: ① 이메일 인증 모듈, ② 프로필 이미지 업로드 모듈, ③ 알림 설정 모듈. 서브에이전트로 나눠서 병렬로 구현해줘.
