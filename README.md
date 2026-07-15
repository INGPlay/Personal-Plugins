# Personal-Plugins

My personal toolbox for Claude Code. Whenever I build a tool I want to reuse — a
skill, a subagent, a hook, an MCP server — I drop it here so it's ready the next
time I need it. Everything is bundled as installable plugins and served through a
**Claude Code plugin marketplace**, so any machine can pull the same tools on demand.

Claude Code용 개인 도구 상자입니다. 다시 쓰고 싶은 도구(스킬, 서브에이전트, 훅,
MCP 서버)를 만들 때마다 여기에 모아 두어 필요할 때 바로 꺼내 씁니다. 모든 도구는
설치 가능한 플러그인으로 묶여 **Claude Code 플러그인 마켓플레이스**로 배포되므로,
어느 기기에서든 같은 도구를 필요할 때 내려받을 수 있습니다.

---

## Repository layout / 저장소 구조

```
Personal-Plugins/
├── .claude-plugin/
│   └── marketplace.json           # Marketplace manifest — lists every plugin
├── plugins/
│   ├── dev-pack/                  # A plugin (skills only, no dependencies)
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json         # Plugin manifest
│   │   └── skills/                # Skills (auto-discovered)
│   │       ├── feature-development/
│   │       ├── bug-fix/
│   │       ├── refactoring/
│   │       ├── codebase-exploration/
│   │       ├── commit/
│   │       ├── ask/
│   │       └── readme-writer/
│   │           ├── SKILL.md
│   │           └── assets/
│   │               └── README_template.md
│   ├── dev-pack-bundle/           # A meta-plugin (dev-pack + companion plugins; no skills)
│   │   └── .claude-plugin/
│   │       └── plugin.json         # Plugin manifest (dependencies only)
│   └── dlc/                       # A meta-plugin (bundles the codex plugin)
│       └── .claude-plugin/
│           └── plugin.json         # Plugin manifest (dependencies only)
├── CLAUDE.md                      # Project instructions for Claude Code
├── CONTRIBUTING.md                # How to add a skill / agent / plugin
├── README.md
├── .gitattributes
└── .gitignore
```

A plugin may also carry `agents/` (auto-discovered subagents), `hooks/`
(event hooks), and `.mcp.json` (MCP servers). `dev-pack` ships skills only; the
skill-less meta-plugins `dev-pack-bundle` and `dlc` declare `dependencies` on
other plugins.

> **Why the split.** A plugin that ships skills must **not** also declare
> `dependencies`: Claude Desktop (CCD/SDK) then silently drops that plugin's own
> skills (the CLI is unaffected). So skills and dependency-bundling live in
> separate plugins — `dev-pack` (skills, no deps) never loses its skills, and the
> skill-less meta-plugin `dev-pack-bundle` carries the `dependencies` that pull
> in `dev-pack` plus its companion plugins. `dlc` follows the same pattern for
> `codex`.

플러그인은 `agents/`(자동 검색되는 서브에이전트), `hooks/`(이벤트 훅),
`.mcp.json`(MCP 서버)도 담을 수 있습니다. `dev-pack`은 스킬만 포함하고, 스킬이
없는 메타 플러그인 `dev-pack-bundle`과 `dlc`가 `dependencies`로 다른 플러그인을
함께 설치합니다.

> **분리한 이유.** 스킬을 포함하는 플러그인은 `dependencies`를 **함께 선언하면 안
> 됩니다**. 그러면 Claude Desktop(CCD/SDK)이 그 플러그인의 자기 스킬을 조용히
> 드롭합니다(CLI는 무관). 그래서 스킬과 의존성 번들링을 별도 플러그인으로
> 나눕니다 — `dev-pack`(스킬만, deps 없음)은 스킬을 잃지 않고, 스킬이 없는 메타
> 플러그인 `dev-pack-bundle`이 `dev-pack`과 동반 플러그인을 끌어오는
> `dependencies`를 담당합니다. `dlc`도 `codex`에 대해 같은 패턴을 씁니다.

`skills/` and `agents/` are **auto-discovered** at the plugin root. `hooks/` and
`.mcp.json` are declared explicitly in each plugin's `plugin.json`.

`skills/`와 `agents/`는 플러그인 루트에서 **자동 검색**됩니다. `hooks/`와
`.mcp.json`은 각 플러그인의 `plugin.json`에 명시적으로 선언합니다.

---

## Available plugins / 제공 플러그인

### `dev-pack`

개발 워크플로 패키지. 아래 스킬을 직접 제공합니다 (`dependencies` 없음). 그 절차가
활용하는 외부 플러그인까지 한 번에 받으려면 [`dev-pack-bundle`](#dev-pack-bundle)
메타 플러그인을 설치하세요. Ships the skills below (and no `dependencies`). To also
pull in the external plugins these workflows lean on, install the
[`dev-pack-bundle`](#dev-pack-bundle) meta-plugin.

절차 스킬 / Workflow skills:

| 스킬 / Skill | 설명 / Description |
| --- | --- |
| `feature-development` | 기능 개발 절차: 탐색 → 작성 → 검증 → 리뷰 → 반복 → 커밋. Feature workflow: explore → write → verify → review → loop → commit. |
| `bug-fix` | 버그 수정 절차: 탐색 → 재현·원인 → 수정 → 검증 → 리뷰 → 반복 → 커밋. Bug workflow: explore → reproduce → fix → verify → review → loop → commit. |
| `refactoring` | 리팩터링 절차: 탐색 → 안전망 → 변경 → 동작 동일 확인 → 리뷰 → 커밋. Refactor workflow: explore → safety net → change → prove-unchanged → review → commit. |
| `codebase-exploration` | 코드 수정 없이 구조·흐름·영향 범위를 파악한다. 위 절차들의 공통 1단계. Understand structure/flow/impact without editing; the shared first step. |

보조 스킬 / Supporting skills:

| 스킬 / Skill | 설명 / Description |
| --- | --- |
| `commit` | 변경사항을 conventional commit(`type: 한국어 설명`)으로 커밋한다. 위 절차들의 마지막 단계에서 사용. Commits changes as `type: <Korean summary>`; used as the final step of the workflows above. |
| `ask` | 현재 코드베이스에 대한 질문에 코드를 근거(`file:line`)로 답변한다. 모호한 질문은 선택지로 좁힌 뒤 답하며, 코드는 수정하지 않는다. Answers questions about the current codebase with `file:line` evidence; narrows ambiguous questions via choices, read-only. |
| `readme-writer` | 저장소를 직접 읽어 사실 기반으로 `README.md`를 작성·갱신한다. Reads the repo and drafts/updates a fact-based `README.md`. |

각 스킬은 설치 후 자연어(예: "기능 추가해줘", "버그 고쳐줘", "커밋해줘") 또는
슬래시 명령(`/dev-pack:feature-development` 등)으로 실행합니다.

Once installed, invoke a skill in natural language (e.g. "add a feature", "fix
this bug", "commit this") or via its slash command
(`/dev-pack:feature-development`, etc.).

### `dev-pack-bundle`

`dev-pack`과 그 절차가 활용하는 외부 플러그인을 한 번에 설치하는 메타 플러그인.
자체 스킬은 없으므로 스킬 등록 버그의 영향을 받지 않습니다. 스킬만 원하면
`dev-pack`을, 도구까지 전부 원하면 이 번들을 설치하세요. A meta-plugin that
installs `dev-pack` plus the external plugins its workflows use. It ships no skills
of its own, so it is unaffected by the skill-registration bug. Install `dev-pack`
alone for just the skills, or this bundle to get the tools too.

묶어 함께 설치되는 플러그인 / Bundled plugins:

| Plugin | 마켓플레이스 / Marketplace |
| --- | --- |
| `dev-pack` | `Personal-Plugins` |
| `feature-dev` | `claude-plugins-official` |
| `context7` | `claude-plugins-official` |
| `security-guidance` | `claude-plugins-official` |
| `playwright` | `claude-plugins-official` |
| `claude-md-management` | `claude-plugins-official` |

외부 의존성은 `claude-plugins-official` 마켓플레이스가 미리 추가돼 있어야 자동으로
해결됩니다. The external dependencies resolve automatically once the
`claude-plugins-official` marketplace has been added.

```bash
/plugin install dev-pack-bundle@Personal-Plugins
```

### `dlc`

OpenAI의 `codex` 플러그인을 묶는 메타 플러그인. 자체 스킬은 없고, 설치하면
`codex@openai-codex`를 의존성으로 함께 끌어옵니다. A meta-plugin that bundles
OpenAI's `codex` plugin — it ships no skills of its own, and installing it pulls
in `codex@openai-codex` as a dependency.

묶어 함께 설치되는 외부 플러그인 / Bundled external plugins:

| Plugin | 마켓플레이스 / Marketplace |
| --- | --- |
| `codex` | `openai-codex` |

설치 전에 codex 마켓플레이스를 먼저 추가해야 의존성이 해결됩니다
(`/plugin marketplace add openai/codex-plugin-cc`). Add the codex marketplace
first so the dependency resolves.

---

## Install / 설치

Point Claude Code at this marketplace, then install a plugin from it.

Claude Code가 이 마켓플레이스를 바라보게 한 뒤, 여기서 플러그인을 설치합니다.

```bash
# 1. Add this marketplace (GitHub repo, git URL, or local path)
/plugin marketplace add INGPlay/Personal-Plugins
# or from a local clone:  /plugin marketplace add ./Personal-Plugins

# 2. Install a plugin from it
/plugin install dev-pack@Personal-Plugins          # skills only
/plugin install dev-pack-bundle@Personal-Plugins   # skills + companion plugins

# Manage
/plugin marketplace list
/plugin marketplace update Personal-Plugins
```

`Personal-Plugins` is the marketplace `name` (from `marketplace.json`);
`dev-pack` is a plugin `name`. Install uses `<plugin>@<marketplace>`.

`Personal-Plugins`는 마켓플레이스 `name`(`marketplace.json` 기준)이고,
`dev-pack`는 플러그인 `name`입니다. 설치는 `<plugin>@<marketplace>` 형식을 사용합니다.

---

## Adding your own / 직접 추가하기

See [CONTRIBUTING.md](CONTRIBUTING.md). In short: copy an existing plugin under
`plugins/`, rename it, edit the manifests, then register the new plugin in
`.claude-plugin/marketplace.json`.

자세한 내용은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요. 요약: `plugins/` 아래
기존 플러그인을 복사해 이름을 바꾸고, 매니페스트를 수정한 뒤,
`.claude-plugin/marketplace.json`에 새 플러그인을 등록합니다.
