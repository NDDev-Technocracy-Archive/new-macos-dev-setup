# Development Guide

## Goal

Provide a single local quality gate that mirrors CI checks before opening a pull request.

## Local prerequisites

- `bash`
- `shellcheck`
- `actionlint`
- `node` + `npx` (for markdown lint)

## Commands

Run from repository root:

```bash
make help
```

Full quality gate:

```bash
just verify
```

Individual checks:

```bash
just syntax-shell
just lint-shell
just lint-workflows
just lint-docs
just test
```

## CI parity

`just verify` maps directly to the CI workflow quality gates:

- shell lint
- shell syntax
- workflow lint
- docs lint
- bootstrap smoke
