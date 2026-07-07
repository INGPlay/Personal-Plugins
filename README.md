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
│   └── common-package/            # A plugin
│       ├── .claude-plugin/
│       │   └── plugin.json         # Plugin manifest
│       └── skills/                # Skills (auto-discovered)
│           ├── commit/
│           │   └── SKILL.md
│           └── readme-writer/
│               ├── SKILL.md
│               └── assets/
│                   └── README_template.md
├── CONTRIBUTING.md                # How to add a skill / agent / plugin
├── README.md
└── .gitignore
```

A plugin may also carry `agents/` (auto-discovered subagents), `hooks/`
(event hooks), and `.mcp.json` (MCP servers). The current plugin ships skills
only.

플러그인은 `agents/`(자동 검색되는 서브에이전트), `hooks/`(이벤트 훅),
`.mcp.json`(MCP 서버)도 담을 수 있습니다. 현재 플러그인은 스킬만 포함합니다.

`skills/` and `agents/` are **auto-discovered** at the plugin root. `hooks/` and
`.mcp.json` are declared explicitly in each plugin's `plugin.json`.

`skills/`와 `agents/`는 플러그인 루트에서 **자동 검색**됩니다. `hooks/`와
`.mcp.json`은 각 플러그인의 `plugin.json`에 명시적으로 선언합니다.

---

## Available plugins / 제공 플러그인

### `common-package`

자주 쓰는 공통 스킬 모음. A bundle of commonly used skills.

| Skill | 설명 (한국어) | Description (English) |
| --- | --- | --- |
| `readme-writer` | 저장소를 직접 읽어 사실 기반으로 `README.md`를 작성·갱신한다. | Reads the repo and drafts/updates a fact-based `README.md`. |
| `commit` | 변경사항을 conventional commit 형식(`type: 한국어 설명`)으로 커밋한다. | Commits changes as `type: <Korean summary>` conventional commits. |

각 스킬은 설치 후 자연어(예: "README 만들어줘", "커밋해줘") 또는 슬래시 명령
(`/common-package:readme-writer`, `/common-package:commit`)으로 실행합니다.

Once installed, invoke a skill in natural language (e.g. "write a README",
"commit this") or via its slash command
(`/common-package:readme-writer`, `/common-package:commit`).

이 플러그인은 `claude-md-management` 플러그인도 의존성으로 함께 설치합니다.
This plugin also installs the `claude-md-management` plugin as a dependency.

### `developer-package`

개발 워크플로 메타 플러그인. 자체 스킬은 없고, 아래 외부 플러그인들을 의존성으로
묶어 한 번에 설치합니다. A meta-plugin with no skills of its own; it bundles the
following external plugins as dependencies and installs them together.

| Plugin | 마켓플레이스 / Marketplace |
| --- | --- |
| `feature-dev` | `claude-plugins-official` |
| `context7` | `claude-plugins-official` |
| `security-guidance` | `claude-plugins-official` |
| `serena` | `claude-plugins-official` |
| `playwright` | `claude-plugins-official` |

의존성은 `claude-plugins-official` 마켓플레이스가 미리 추가돼 있어야 자동으로
해결됩니다. Dependencies resolve automatically once the `claude-plugins-official`
marketplace has been added.

---

## Install / 설치

Point Claude Code at this marketplace, then install a plugin from it.

Claude Code가 이 마켓플레이스를 바라보게 한 뒤, 여기서 플러그인을 설치합니다.

```bash
# 1. Add this marketplace (GitHub repo, git URL, or local path)
/plugin marketplace add INGPlay/Personal-Plugins
# or from a local clone:  /plugin marketplace add ./Personal-Plugins

# 2. Install a plugin from it
/plugin install common-package@Personal-Plugins

# Manage
/plugin marketplace list
/plugin marketplace update Personal-Plugins
```

`Personal-Plugins` is the marketplace `name` (from `marketplace.json`);
`common-package` is a plugin `name`. Install uses `<plugin>@<marketplace>`.

`Personal-Plugins`는 마켓플레이스 `name`(`marketplace.json` 기준)이고,
`common-package`는 플러그인 `name`입니다. 설치는 `<plugin>@<marketplace>` 형식을 사용합니다.

---

## Adding your own / 직접 추가하기

See [CONTRIBUTING.md](CONTRIBUTING.md). In short: copy `plugins/common-package`,
rename it, edit the manifests, then register the new plugin in
`.claude-plugin/marketplace.json`.

자세한 내용은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요. 요약: `plugins/common-package`을
복사해 이름을 바꾸고, 매니페스트를 수정한 뒤, `.claude-plugin/marketplace.json`에
새 플러그인을 등록합니다.
