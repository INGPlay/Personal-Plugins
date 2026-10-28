#!/usr/bin/env bash
set -e
mkdir -p src test
cat > package.json <<'JSONEOF'
{
  "name": "todo-cli",
  "version": "1.2.0",
  "description": "터미널에서 할 일을 관리하는 CLI",
  "bin": { "todo": "src/index.js" },
  "scripts": {
    "dev": "node src/index.js",
    "test": "node --test"
  },
  "engines": { "node": ">=20" }
}
JSONEOF
cat > src/index.js <<'JSEOF'
#!/usr/bin/env node
const store = require('./store');

const [cmd, ...args] = process.argv.slice(2);
switch (cmd) {
  case 'add': store.add(args.join(' ')); break;
  case 'list': store.list().forEach((t, i) => console.log(`${i + 1}. [${t.done ? 'x' : ' '}] ${t.title}`)); break;
  case 'done': store.done(Number(args[0]) - 1); break;
  default: console.log('사용법: todo <add|list|done> [인자]');
}
JSEOF
cat > src/store.js <<'JSEOF'
const fs = require('fs');
const path = require('path');
const os = require('os');

const FILE = process.env.TODO_FILE || path.join(os.homedir(), '.todo.json');
const load = () => (fs.existsSync(FILE) ? JSON.parse(fs.readFileSync(FILE, 'utf8')) : []);
const save = (todos) => fs.writeFileSync(FILE, JSON.stringify(todos, null, 2));

exports.add = (title) => save([...load(), { title, done: false }]);
exports.list = () => load();
exports.done = (i) => { const t = load(); t[i].done = true; save(t); };
JSEOF
cat > test/store.test.js <<'JSEOF'
const test = require('node:test');
const assert = require('node:assert');
const os = require('os');
const path = require('path');
process.env.TODO_FILE = path.join(os.tmpdir(), `todo-${process.pid}.json`);
const store = require('../src/store');

test('add 후 list에 나온다', () => {
  store.add('우유 사기');
  assert.strictEqual(store.list().at(-1).title, '우유 사기');
});
JSEOF
cat > README.md <<'MDEOF'
# todo-cli

터미널에서 할 일을 관리하는 작은 CLI입니다.

데모 영상: https://todo-cli-demo.netlify.app

## 실행

```bash
npm install
npm run serve
```

## 명령

- `todo add <내용>`: 할 일 추가
- `todo list`: 목록 보기
MDEOF
