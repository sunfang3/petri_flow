# Dependency Upgrade Spec (Iteration 8)

Last updated: 2026-04-17

## 1. Scope

This spec covers **Phase 8 / mid-risk dependency refresh**.

Included:
- Upgrade lint/tooling dependency set:
  - `rubocop`
  - `rubocop-performance`
  - `rubocop-rails`
- Keep runtime gem behavior unchanged.
- Validate updated lint stack can execute in current repo.

Excluded:
- Runtime dependency upgrades unrelated to lint/tooling.
- Feature behavior changes in workflow engine.

## 2. Files in Scope

- `Gemfile.lock`
- `.rubocop.yml` (only if compatibility adjustments are required)
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-spec-iteration8.md`

## 3. Requirements

### R1: Dependency Refresh

- `Gemfile.lock` must reflect upgraded RuboCop family versions compatible with the current Ruby/Rails baseline.

### R2: Lint Stack Validation

- Validate lint tooling executes after upgrade:
  - `bundle exec rubocop -V`
  - one command that loads project configuration successfully

### R3: Safety Validation

- Run full test suite:
  - `RAILS_ENV=test bundle exec rails test`

## 4. Known Risks

- New RuboCop versions may deprecate or rename cops configured in `.rubocop.yml`.
- Plugin-level version constraints may limit how far direct upgrades can go in one step.

## 5. Execution Results (2026-04-17)

- Upgraded RuboCop dependency set in `Gemfile.lock`:
  - `rubocop 1.41.1 -> 1.86.1`
  - `rubocop-performance 1.15.1 -> 1.26.1`
  - `rubocop-rails 2.17.3 -> 2.34.3`
  - transitive updates include `rubocop-ast 1.49.1`, `parser 3.3.11.1`, `parallel 1.28.0`
- Compatibility adjustments in `.rubocop.yml`:
  - migrated extension loading from `require:` to `plugins:`
  - replaced obsolete `Layout/Tab` with `Layout/IndentationStyle`
  - removed obsolete `Style/BracesAroundHashParameters`
  - set `AllCops: NewCops: disable` to keep baseline stable and reduce upgrade noise
- Validation passed:
  - `bundle exec rubocop -V` (loads updated stack successfully)
  - `bundle exec rubocop --list-target-files` (config loads and target discovery works)
  - `RAILS_ENV=test bundle exec rails test` (13 runs, 48 assertions, 0 failures)
