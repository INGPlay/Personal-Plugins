#!/usr/bin/env bash
set -e
mkdir -p src test .github/workflows
cat > package.json <<'JSONEOF'
{
  "name": "price-kit",
  "version": "1.2.0",
  "private": true,
  "scripts": {
    "typecheck": "tsc --noEmit",
    "lint": "eslint src test",
    "test": "vitest run",
    "check": "pnpm typecheck && pnpm lint && pnpm test"
  },
  "devDependencies": {
    "eslint": "^9.0.0",
    "typescript": "^5.4.0",
    "vitest": "^1.6.0"
  }
}
JSONEOF
cat > pnpm-lock.yaml <<'YAMLEOF'
lockfileVersion: '9.0'

importers:
  .:
    devDependencies:
      eslint:
        specifier: ^9.0.0
        version: 9.0.0
      typescript:
        specifier: ^5.4.0
        version: 5.4.5
      vitest:
        specifier: ^1.6.0
        version: 1.6.0
YAMLEOF
cat > .github/workflows/ci.yml <<'YAMLEOF'
name: ci
on: [push, pull_request]
jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - run: pnpm install --frozen-lockfile
      - run: pnpm run check
YAMLEOF
cat > src/price.ts <<'TSEOF'
// 원 단위 가격을 10원 단위로 반올림한다(5원 이상은 올림).
export const roundPrice = (won: number): number => Math.round(won / 10) * 10;

export const withVat = (won: number): number => roundPrice(won * 1.1);
TSEOF
cat > test/price.test.ts <<'TSEOF'
import { describe, expect, it } from 'vitest';
import { roundPrice, withVat } from '../src/price';

describe('roundPrice', () => {
  it('5원 이상은 올린다', () => {
    expect(roundPrice(1235)).toBe(1240);
  });
  it('5원 미만은 버린다', () => {
    expect(roundPrice(1234)).toBe(1230);
  });
});

describe('withVat', () => {
  it('부가세 10%를 더하고 반올림한다', () => {
    expect(withVat(1000)).toBe(1100);
  });
});
TSEOF
