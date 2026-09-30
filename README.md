# Personal-Plugins

Claude Code용 개인 도구 상자입니다. 다시 쓰고 싶은 도구(스킬, 서브에이전트, 훅,
MCP 서버)를 만들 때마다 여기에 모아 두고 필요할 때 꺼내 씁니다. 도구는 모두
설치 가능한 플러그인으로 묶어 **Claude Code 플러그인 마켓플레이스**로 배포하므로,
어느 기기에서든 같은 도구를 내려받을 수 있습니다.

---

## 설치

Claude Code에 이 마켓플레이스를 추가한 뒤 플러그인을 설치합니다.

```bash
# 1. 마켓플레이스 추가 (GitHub 저장소, git URL, 로컬 경로 모두 가능)
/plugin marketplace add INGPlay/Personal-Plugins
# 로컬 클론에서 추가할 때:  /plugin marketplace add ./Personal-Plugins

# 2. 플러그인 설치
/plugin install dev-pack@Personal-Plugins          # 스킬만
/plugin install dev-pack-bundle@Personal-Plugins   # 스킬 + 동반 플러그인

# 관리
/plugin marketplace list
/plugin marketplace update Personal-Plugins
```

`Personal-Plugins`는 `marketplace.json`에 적힌 마켓플레이스 `name`이고
`dev-pack`은 플러그인 `name`입니다. 설치할 때는 `<plugin>@<marketplace>` 형식을
씁니다.

---

## 제공 플러그인

### `dev-pack`

개발 워크플로 패키지입니다. 아래 스킬을 직접 제공하며 `dependencies`는 없습니다.
절차에서 쓰는 외부 플러그인까지 한 번에 받으려면 [`dev-pack-bundle`](#dev-pack-bundle)
메타 플러그인을 설치하세요.

절차 스킬:

| 스킬 | 설명 |
| --- | --- |
| `feature-develop` | 기능 개발 절차: 탐색 → 작성 → 검증(반복) → 커밋 → 사용자 `/code-review` |
| `feature-change` | 기능 변경 절차: 탐색·의존처 파악 → 호환성 결정 → 변경 → 테스트·문서 갱신 → 검증(반복) → 커밋 → 사용자 `/code-review` |
| `bug-fix` | 버그 수정 절차: 탐색 → 재현·원인 → 수정 → 검증(반복) → 커밋 → 사용자 `/code-review` |
| `refactoring` | 리팩터링 절차: 탐색 → 안전망 → 변경 → 동작 동일 확인(반복) → 커밋 → 사용자 `/code-review` |
| `codebase-exploration` | 코드를 고치지 않고 구조·흐름·영향 범위를 파악한다. 위 절차들의 공통 1단계 |
| `behavior-check` | build/lint/test와 `/run`으로 바뀐 코드가 실제로 도는지 확인하고 실패하면 수정 단계로 되돌린다. 위 절차들의 공통 검증 단계(통과 기준은 절차마다 다르다) |

보조 스킬:

| 스킬 | 설명 |
| --- | --- |
| `commit` | 변경사항을 conventional commit(`type: 한국어 설명`)으로 커밋한다. 위 절차들의 커밋 단계에서 쓰며 그 뒤 사용자가 `/code-review`를 실행한다 |
| `ask` | 현재 코드베이스에 대한 질문에 코드 근거(`file:line`)를 들어 답한다. 모호한 질문은 선택지로 좁혀 묻고 코드는 고치지 않는다 |
| `readme-writer` | 저장소를 직접 읽어 사실에 근거한 `README.md`를 작성·갱신한다. `humanize-korean`이 설치돼 있으면 한국어 본문을 `humanize-scan`으로 점검한다 |
| `technical-writing` | 한글 기술 문서·보고서·양식 문구에서 번역투와 AI 티를 걷어내고 문체를 하나로 맞춘다. 결함리포트 응답처럼 엑셀/표 셀에 들어가는 개조식 규칙도 담았다. [joshyeom/technical-writing-ko](https://github.com/joshyeom/technical-writing-ko)(MIT) 기반 |

설치 후에는 자연어("기능 추가해줘", "버그 고쳐줘", "커밋해줘" 등)나 슬래시
명령(`/dev-pack:feature-develop` 등)으로 스킬을 실행합니다.

> **Co-Authored-By 트레일러 끄기.** `commit` 스킬은 트레일러를 다루지 않습니다.
> Claude Code가 커밋·PR에 붙이는 `Co-Authored-By: Claude …` 줄은 설정에서
> 끕니다. `~/.claude/settings.json`에 아래 내용을 넣으면 모든 저장소에 적용됩니다.
>
> ```json
> "attribution": { "commit": "", "pr": "", "sessionUrl": false }
> ```

### `dev-pack-bundle`

`dev-pack`과 그 절차에서 쓰는 외부 플러그인을 한 번에 설치하는 메타 플러그인입니다.
자체 스킬이 없어서 스킬 등록 버그의 영향을 받지 않습니다. 스킬만 필요하면
`dev-pack`을, 도구까지 모두 필요하면 이 번들을 설치하세요.

함께 설치되는 플러그인:

| 플러그인 | 마켓플레이스 |
| --- | --- |
| `dev-pack` | `Personal-Plugins` |
| `context7` | `claude-plugins-official` |
| `security-guidance` | `claude-plugins-official` |
| `playwright` | `claude-plugins-official` |
| `claude-md-management` | `claude-plugins-official` |
| `frontend-design` | `claude-plugins-official` |
| `humanize-korean` | `im-not-ai` |

외부 의존성은 `claude-plugins-official`과 `im-not-ai` 마켓플레이스를 미리 추가해
둬야 자동으로 해결됩니다(`/plugin marketplace add epoko77-ai/im-not-ai`).

```bash
/plugin install dev-pack-bundle@Personal-Plugins
```

### `dlc`

OpenAI의 `codex` 플러그인을 묶는 메타 플러그인입니다. 자체 스킬은 없고 설치하면
`codex@openai-codex`를 의존성으로 함께 받아 옵니다.

함께 설치되는 외부 플러그인:

| 플러그인 | 마켓플레이스 |
| --- | --- |
| `codex` | `openai-codex` |

설치 전에 codex 마켓플레이스를 먼저 추가해야 의존성이 해결됩니다
(`/plugin marketplace add openai/codex-plugin-cc`).

---

## 저장소 구조

```
Personal-Plugins/
├── .claude-plugin/
│   └── marketplace.json           # 마켓플레이스 매니페스트(전체 플러그인 목록)
├── plugins/
│   ├── dev-pack/                  # 플러그인(스킬만, 의존성 없음)
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json        # 플러그인 매니페스트
│   │   └── skills/                # 스킬(자동 검색)
│   │       ├── feature-develop/
│   │       ├── feature-change/
│   │       ├── bug-fix/
│   │       ├── refactoring/
│   │       ├── codebase-exploration/
│   │       ├── behavior-check/
│   │       ├── commit/
│   │       ├── ask/
│   │       ├── readme-writer/
│   │       │   ├── SKILL.md
│   │       │   └── assets/
│   │       │       └── README_template.md
│   │       └── technical-writing/
│   │           ├── SKILL.md
│   │           ├── LICENSE-technical-writing-ko
│   │           └── scripts/
│   │               └── scan.sh
│   ├── dev-pack-bundle/           # 메타 플러그인(dev-pack + 동반 플러그인, 스킬 없음)
│   │   └── .claude-plugin/
│   │       └── plugin.json        # 플러그인 매니페스트(의존성만)
│   └── dlc/                       # 메타 플러그인(codex 플러그인 묶음)
│       └── .claude-plugin/
│           └── plugin.json        # 플러그인 매니페스트(의존성만)
├── CLAUDE.md                      # Claude Code용 프로젝트 지침
├── CONTRIBUTING.md                # 스킬·에이전트·플러그인 추가 방법
├── README.md
├── .gitattributes
└── .gitignore
```

플러그인에는 `agents/`(자동 검색되는 서브에이전트), `hooks/`(이벤트 훅),
`.mcp.json`(MCP 서버)도 넣을 수 있습니다. `skills/`와 `agents/`는 플러그인
루트에서 **자동 검색**되고 `hooks/`와 `.mcp.json`은 각 플러그인의 `plugin.json`에
직접 선언합니다.

지금은 `dev-pack`에 스킬만 들어 있고 스킬이 없는 메타 플러그인 `dev-pack-bundle`과
`dlc`가 `dependencies`로 다른 플러그인을 함께 설치합니다.

> **스킬과 의존성을 나눈 이유.** 스킬을 담은 플러그인에 `dependencies`까지
> 선언하면 Claude Desktop(CCD/SDK)이 그 플러그인의 스킬을 조용히 빼 버립니다(CLI는
> 해당 없음). 그래서 스킬은 `dev-pack`에만 두고 의존성은 두지 않았습니다.
> `dev-pack`과 동반 플러그인을 끌어오는 `dependencies`는 스킬 없는 메타 플러그인
> `dev-pack-bundle`이 맡습니다. `dlc`도 `codex`를 같은 방식으로 묶습니다.

---

## 함께 쓰는 도구

이 플러그인들과 같이 쓰는 도구입니다. Claude Code 플러그인이 **아니라서**
`/plugin install`로는 설치되지 않고 도구마다 설치 절차가 따로 있습니다. 모두 선택
사항이며 이 저장소의 스킬 중 이 도구들이 있어야 도는 것은 없습니다.

### MCP 서버·스킬

| 도구 | 설명 |
| --- | --- |
| [`@ivotoby/openapi-mcp-server`](https://github.com/ivo-toby/mcp-openapi-server) | OpenAPI 명세를 MCP 도구로 노출해 REST API를 호출하게 해 주는 MCP 서버 |
| [`mcp-toolbox`](https://github.com/googleapis/mcp-toolbox) | 데이터베이스를 MCP 도구로 노출하는 Google의 오픈소스 MCP 서버 |
| [`andrej-karpathy-skills`](https://github.com/multica-ai/andrej-karpathy-skills.git) | LLM이 코딩할 때 자주 저지르는 실수를 줄이는 행동 지침 모음 |

### 명령줄 도구

Claude Code가 Bash에서 직접 호출하는 도구입니다. Windows에는 기본으로 들어 있지
않으니 따로 설치해야 합니다.

| 도구 | 설명 |
| --- | --- |
| [`jq`](https://jqlang.github.io/jq/) | 명령줄에서 JSON을 파싱·가공하는 도구. API 응답이나 설정 파일에서 필요한 값만 뽑을 때 씁니다 |
| [`python3`](https://www.python.org/downloads/) | 일회성 계산·데이터 가공·임시 스크립트용 런타임. 셸 한 줄로 끝나지 않는 작업을 맡깁니다 |

### 영상·음성 도구

이 도구들도 따로 설치해야 합니다. 영상·음성 작업에만 쓰는 명령줄 도구이며 위
도구처럼 Bash에서 직접 호출합니다.

| 도구 | 설명 |
| --- | --- |
| [`ffmpeg`](https://ffmpeg.org/) (winget: `Gyan.FFmpeg`) | 영상·음성 변환, 자르기, 오디오 추출 등을 하는 미디어 처리 도구. 내려받은 영상을 다루거나 포맷을 바꿀 때 씁니다 |
| [`yt-dlp`](https://github.com/yt-dlp/yt-dlp) (winget: `yt-dlp.yt-dlp`) | YouTube 등 웹 사이트에서 영상·음성·자막을 내려받는 도구. `ffmpeg`와 함께 쓰면 포맷 병합과 변환까지 한 번에 합니다 |

### 컨텍스트 압축 도구를 쓰지 않는 이유

- **이득을 원리상 확인할 수 없습니다.** 이런 도구가 보여 주는 절감량은 자기가
  지운 글자 수일 뿐이고 실제 청구액과는 관계가 없습니다. 도구 스스로 효과를
  증명할 방법이 없습니다.
- **그래서 검증 비용이 기대 이득보다 큽니다.** 제대로 재려면 저장소를 리셋해 가며
  교차 A/B를 여러 번 돌려야 합니다. 그만한 시간을 들일 만큼 절감된다는 근거가
  지금은 없습니다.

---

## 직접 추가하기

자세한 내용은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요. 요약하면
`plugins/` 아래 기존 플러그인을 복사해 이름을 바꾸고 매니페스트를 고친 뒤
`.claude-plugin/marketplace.json`에 새 플러그인을 등록합니다.
