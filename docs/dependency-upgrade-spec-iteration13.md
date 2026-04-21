# Dependency Upgrade Spec (Iteration 13)

Last updated: 2026-04-22

## 1. Scope

This spec covers **Ruby 4.0 baseline alignment** and execution of the previously researched high-risk dependency tracks.

Included:

- move project/runtime baseline to Ruby `>= 4.0`.
- align CI and gem-publish workflows to Ruby 4.0.
- align static analysis target to Ruby 4.0.
- execute dependency upgrades:
  - `bootstrap` `4.4.1 -> 5.3.8`
  - `mini_racer` `0.6.3 -> 0.20.0` (with `libv8-node` Node 24 line)
  - `rgl` `0.5.9 -> 0.6.6`
- remove unnecessary development dependency `mysql2` from `Gemfile`.
- add explicit Sass engine dependency (`sassc-rails`) required by Bootstrap 5 gem loading in this sprockets setup.

Excluded:

- broad UI redesign beyond dependency/runtime migration.
- replacing jQuery/select2 stack.

## 2. Files in Scope

- `.ruby-version`
- `.tool-versions` (new)
- `Gemfile`
- `Gemfile.lock`
- `wf.gemspec`
- `.rubocop.yml`
- `.github/workflows/ci.yml`
- `.github/workflows/gempush.yml`
- `README.md`
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-high-risk-research.md`
- `docs/dependency-upgrade-spec-iteration13.md`

## 3. Requirements

### R1: Ruby Baseline

- repo metadata and gemspec must enforce Ruby 4.0+.

### R2: Pipeline Alignment

- test CI workflow and gem publish workflow use Ruby 4.0.
- release workflow avoids deprecated checkout runtime lines.

### R3: High-Risk Dependency Execution

- bootstrap, mini_racer/libv8-node, and rgl upgrades land together with lockfile updates.
- app boot and test execution remain green after upgrade.

### R4: Validation

- full test suite passes on Ruby 4.0.
- rubocop command resolves with Ruby 4.0 target metadata.

## 4. Known Risks

- Bootstrap 5 migration can still surface UI-level regressions not covered by backend tests.
- `sassc-rails` is retained as compatibility glue for the current asset pipeline; future cleanup can migrate to a dartsass-based path.

## 5. Execution Results (2026-04-22)

Key outcomes:

- Ruby baseline aligned:
  - `.ruby-version`: `4.0.1`
  - `wf.gemspec`: `required_ruby_version >= 4.0`
  - `Gemfile`: `ruby ">= 4.0.0"`
- CI/publish alignment:
  - `ci.yml` matrix set to `ruby-version: ["4.0"]`
  - `gempush.yml`: `actions/checkout@v6`, Ruby `4.0`
- Lint target aligned:
  - `.rubocop.yml` `TargetRubyVersion: 4.0`
- Dependency upgrades executed and locked:
  - `bootstrap 5.3.8`
  - `mini_racer 0.20.0`
  - `libv8-node 24.12.0.1`
  - `rgl 0.6.6`
  - `mysql2` removed from `Gemfile`
  - `sassc-rails` added explicitly for bootstrap 5 loadability in this setup

Validation commands and results:

- `BUNDLE_PATH=vendor/bundle-ruby40 mise exec ruby@4.0.1 -- bundle exec rails test`
  - passed: `54 runs, 173 assertions, 0 failures, 0 errors, 0 skips`
- `BUNDLE_PATH=vendor/bundle-ruby40 mise exec ruby@4.0.1 -- bundle exec rubocop -V`
  - confirmed runtime/target: analyzing as Ruby 4.0 on Ruby 4.0.1
