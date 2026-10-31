---
tags: [refactoring, procedure]
max_turns: 30
allowed_tools: [Read, Glob, Grep, Skill, Edit, Write, Bash]
---

src/order.js에 장바구니 합계와 청구서 합계를 계산하는 코드가 거의 똑같이 두 번 들어가 있어. 동작은 그대로 두고 중복을 정리해줘.
