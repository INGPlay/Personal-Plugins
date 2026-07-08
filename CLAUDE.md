# CLAUDE.md

> **This project is for Claude Code only.**
> 이 프로젝트는 **Claude Code 전용**입니다.
>
> This repository is a Claude Code **plugin marketplace**. Every artifact here
> (skills, subagents, hooks, MCP servers) targets the Claude Code runtime and its
> plugin format. It is not a general-purpose library — do not adapt it for other
> tools or runtimes.
>
> 이 저장소는 Claude Code **플러그인 마켓플레이스**입니다. 여기의 모든 산출물
> (스킬, 서브에이전트, 훅, MCP 서버)은 Claude Code 런타임과 플러그인 포맷을
> 대상으로 합니다. 범용 라이브러리가 아니므로 다른 도구/런타임용으로 변형하지
> 마세요.

## Layout / 구조

- `.claude-plugin/marketplace.json` — marketplace manifest listing every plugin.
- `plugins/<name>/` — one plugin per directory. `skills/` and `agents/` are
  auto-discovered at the plugin root; `hooks/` and `.mcp.json` are declared in
  each plugin's `plugin.json`.

## Working here / 작업 규칙

- When adding a plugin, follow `CONTRIBUTING.md`: copy an existing plugin under
  `plugins/` (e.g. `plugins/dev-pack`), edit its manifests, then register
  it in `.claude-plugin/marketplace.json`.
- Keep `marketplace.json` in sync with the actual `plugins/` directories — every
  plugin directory must have a matching entry, and vice versa.
- Documentation is bilingual (English / 한국어). Match that style in READMEs and
  skill docs.
