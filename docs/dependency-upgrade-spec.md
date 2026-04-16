# Dependency Upgrade Spec (Iteration 1)

Last updated: 2026-04-16

## 1. Scope

This spec only covers **Phase 1 / Baseline and Toolchain**.

Included:
- Ruby version baseline declaration.
- CI workflow modernization.
- Gem publish workflow Ruby baseline update.
- RuboCop target Ruby alignment.
- Gemspec required Ruby version declaration.

Excluded:
- Rails major/minor dependency upgrade.
- Frontend stack migration (Bootstrap 4 -> 5).
- Application/domain behavior changes.

## 2. Files to Change

- `.ruby-version` (new)
- `.github/workflows/ci.yml`
- `.github/workflows/gempush.yml`
- `.rubocop.yml`
- `wf.gemspec`

## 3. Requirements

### R1: Ruby Baseline

- Repo must explicitly declare Ruby baseline in `.ruby-version`.
- Gemspec must declare `required_ruby_version`.

### R2: CI Modernization

- Replace deprecated action usage with maintained equivalents.
- CI must run with modern Ruby versions compatible with future Rails 8 path.
- Keep DB service and graphviz/mysql/postgres native deps installation.

### R3: Static Analysis Alignment

- `AllCops.TargetRubyVersion` must match the new baseline intent.

### R4: No Behavior Change

- No functional code paths under `app/` and `lib/` should be changed in Iteration 1.

## 4. Validation

Minimum validation for this iteration:

1. `git diff --name-only` only includes listed files.
2. YAML files are parseable (`ruby -e "require 'yaml'; YAML.load_file(...)"`).
3. `bundle exec rubocop -V` or `bundle check` (best-effort; report if local env missing gems).

## 5. Risks

- Local machine Ruby version may differ from targeted baseline.
- CI dependency package names may vary on Ubuntu image refreshes.
- Without full bundle install, only static config validation is guaranteed in this iteration.

## 6. Done Definition

Iteration 1 is done when:

- All files in scope are updated.
- Validation commands are executed and results reported.
- Next iteration entry criteria are written in summary.
