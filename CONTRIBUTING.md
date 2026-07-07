# Contributing / 기여 가이드

How to add components to this marketplace.
이 마켓플레이스에 구성요소를 추가하는 방법입니다.

---

## Add a new plugin / 새 플러그인 추가

1. Copy the template:

   ```bash
   cp -r plugins/example-pack plugins/my-plugin
   ```

2. Edit `plugins/my-plugin/.claude-plugin/plugin.json`:
   - Change `name` (kebab-case, unique), `displayName`, `description`, `version`.
   - Keep `hooks` / `mcpServers` only if the plugin ships them; otherwise remove
     those keys and delete the corresponding files.

3. Register it in `.claude-plugin/marketplace.json` — add an entry to the
   `plugins` array. `source` is the folder name (relative to `metadata.pluginRoot`,
   which is `./plugins`):

   ```json
   {
     "name": "my-plugin",
     "source": "my-plugin",
     "description": "What it does.",
     "version": "0.1.0"
   }
   ```

4. Test locally: `/plugin marketplace update Personal-Plugins` then
   `/plugin install my-plugin@Personal-Plugins`.

---

## Add a skill / 스킬 추가

Create `plugins/<plugin>/skills/<skill-name>/SKILL.md`. It is auto-discovered.

`plugins/<plugin>/skills/<skill-name>/SKILL.md`를 만듭니다. 자동으로 검색됩니다.

```markdown
---
name: my-skill
description: Be specific about WHEN Claude should invoke this. This is the trigger.
---

Instructions Claude follows once the skill is invoked.
```

- `description` is the trigger — write it as "Use when …".
- Optional frontmatter: `model`, `allowedTools`, `disallowedTools`.

---

## Add a subagent / 서브에이전트 추가

Create `plugins/<plugin>/agents/<agent-name>.md`. Auto-discovered.

```markdown
---
name: my-agent
description: When Claude should delegate to this agent.
tools:
  - Read
  - Grep
---

The agent's system prompt.
```

- `name` and `description` are required. `tools` restricts what it can call.

---

## Add hooks / 훅 추가

Edit `plugins/<plugin>/hooks/hooks.json` and ensure `plugin.json` has
`"hooks": "./hooks/hooks.json"`.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          { "type": "command", "command": "\"${CLAUDE_PLUGIN_ROOT}\"/scripts/format.sh" }
        ]
      }
    ]
  }
}
```

- Use `${CLAUDE_PLUGIN_ROOT}` for paths inside the plugin.
- Common events: `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `Stop`.

---

## Add an MCP server / MCP 서버 추가

Edit `plugins/<plugin>/.mcp.json` and ensure `plugin.json` has
`"mcpServers": "./.mcp.json"`.

```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@scope/my-mcp-server"],
      "env": { "API_KEY": "${user_config.api_key}" }
    }
  }
}
```

- Variables: `${CLAUDE_PLUGIN_ROOT}`, `${CLAUDE_PROJECT_DIR}`, `${user_config.KEY}`,
  and any environment variable.

---

## Conventions / 규칙

- Plugin and skill `name` values are **kebab-case** and unique.
- Bump a plugin's `version` on every meaningful change.
- Keep each plugin focused; prefer several small plugins over one giant one.
- 플러그인·스킬 `name`은 **kebab-case**로 고유하게. 변경 시 `version`을 올리고,
  하나의 거대한 플러그인보다 작고 집중된 여러 플러그인을 선호하세요.
