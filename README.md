# Code-Skill

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
Code-Skill/
├── .claude-plugin/
│   └── marketplace.json          # Marketplace manifest — lists every plugin
├── plugins/
│   └── example-pack/             # A plugin (copy this to make your own)
│       ├── .claude-plugin/
│       │   └── plugin.json        # Plugin manifest
│       ├── skills/
│       │   └── hello-skill/
│       │       └── SKILL.md        # A skill (auto-discovered)
│       ├── agents/
│       │   └── example-reviewer.md # A subagent (auto-discovered)
│       ├── hooks/
│       │   └── hooks.json          # Event hooks (declared in plugin.json)
│       └── .mcp.json               # MCP servers (declared in plugin.json)
├── CONTRIBUTING.md               # How to add a skill / agent / plugin
├── README.md
└── .gitignore
```

`skills/` and `agents/` are **auto-discovered** at the plugin root. `hooks/` and
`.mcp.json` are declared explicitly in each plugin's `plugin.json`.

`skills/`와 `agents/`는 플러그인 루트에서 **자동 검색**됩니다. `hooks/`와
`.mcp.json`은 각 플러그인의 `plugin.json`에 명시적으로 선언합니다.

---

## Install / 설치

Point Claude Code at this marketplace, then install a plugin from it.

Claude Code가 이 마켓플레이스를 바라보게 한 뒤, 여기서 플러그인을 설치합니다.

```bash
# 1. Add this marketplace (local path, GitHub repo, or git URL)
/plugin marketplace add ./Code-Skill
# or from GitHub once pushed:  /plugin marketplace add <owner>/Code-Skill

# 2. Install a plugin from it
/plugin install example-pack@code-skill

# Manage
/plugin marketplace list
/plugin marketplace update code-skill
```

`code-skill` is the marketplace `name` (from `marketplace.json`); `example-pack`
is a plugin `name`. Install uses `<plugin>@<marketplace>`.

`code-skill`은 마켓플레이스 `name`(`marketplace.json` 기준)이고, `example-pack`은
플러그인 `name`입니다. 설치는 `<plugin>@<marketplace>` 형식을 사용합니다.

---

## Adding your own / 직접 추가하기

See [CONTRIBUTING.md](CONTRIBUTING.md). In short: copy `plugins/example-pack`,
rename it, edit the manifests, then register the new plugin in
`.claude-plugin/marketplace.json`.

자세한 내용은 [CONTRIBUTING.md](CONTRIBUTING.md)를 참고하세요. 요약: `plugins/example-pack`을
복사해 이름을 바꾸고, 매니페스트를 수정한 뒤, `.claude-plugin/marketplace.json`에
새 플러그인을 등록합니다.
