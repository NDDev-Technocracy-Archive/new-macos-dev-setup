set shell := ["bash", "-euo", "pipefail", "-c"]

# List the source-maintenance commands.
default:
    @just --list

# Prepare the committed Markdown checker without package lifecycle scripts.
setup:
    bun install --frozen-lockfile --ignore-scripts

# Run the complete build-free, offline source gate.
check: syntax-shell lint-shell lint-workflows lint-docs spelling links-offline
    just --fmt --check

# Check Bash syntax without executing installer code.
[group("source")]
syntax-shell:
    bash scripts/ci/check-source.sh syntax

# Retain the existing ShellCheck policy and source selection.
[group("source")]
lint-shell:
    bash scripts/ci/check-source.sh shell

# Lint the workflows with the prepared checker.
[group("source")]
lint-workflows:
    actionlint

# Run the locked Markdown checker with the existing policy.
[group("source")]
lint-docs:
    bun run check:markdown

# Check authored spelling with the prepared tool.
[group("source")]
spelling:
    typos

# Validate tracked local Markdown links without network access.
[group("source")]
links-offline:
    bash scripts/ci/check-source.sh links-offline

# Check the same authored links from an admitted execution host.
[group("ci")]
links:
    bash scripts/ci/check-source.sh links

# Retain entrypoint help and the Linux selector smoke, without installing tools.
test:
    ./install-macos.sh --help
    ./scripts/bootstrap/bootstrap.sh --help
    ./scripts/bootstrap/setup-macos-dev-stack.sh --help
    ./scripts/bootstrap/bootstrap.sh --os linux --skip-health-check

# Run source checks, external links and the retained native smoke.
verify: check links test

# Run the source/document role independently of the macOS smoke role.
[group("ci")]
verify-source: check links
