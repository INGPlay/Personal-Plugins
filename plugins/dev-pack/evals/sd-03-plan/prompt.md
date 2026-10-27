---
tags: [subagent-delegation, procedure]
max_turns: 20
allowed_tools: [Read, Glob, Grep, Skill, Write, AskUserQuestion]
---

members 패키지에 세 기능을 추가해야 해. 서로 다른 파일이라 독립적이야: ① members/email_verify.py에 이메일 인증 토큰 발급·확인, ② members/avatar.py에 프로필 이미지 URL 검증·저장, ③ members/notify_prefs.py에 알림 설정 조회·변경. 각각 tests/에 테스트도 붙여서, 서브에이전트로 나눠서 구현해줘.
