# Dependency Upgrade Spec (Iteration 5)

Last updated: 2026-04-17

## 1. Scope

This spec covers **Phase 5 / post-Rails8 low-risk dependency refresh**.

Included:
- Upgrade selected low-risk direct dependencies to latest compatible versions:
  - `jquery-rails`
  - `mysql2`
  - `sprockets`
  - `sprockets-rails`
  - `pry-rails`
- Re-resolve lockfile and validate on Ruby `3.2.9` and `3.3.9`.
- Record matrix/environment findings from CI-equivalent commands.

Excluded:
- Major frontend framework migration (`bootstrap 4 -> 5`).
- Runtime graph/workflow library major migration (`rgl`).
- Lint rule-set migration for latest RuboCop major versions.

## 2. Files in Scope

- `Gemfile.lock`
- `docs/dependency-upgrade-plan.md`
- `docs/dependency-upgrade-spec-iteration5.md`

## 3. Requirements

### R1: Lockfile Update

- `Gemfile.lock` must include upgraded versions of selected gems above.

### R2: Verification

- Use Ruby `3.2.9` and run:
  - `bundle lock --update jquery-rails mysql2 sprockets sprockets-rails pry-rails`
  - `bundle install`
  - `RAILS_ENV=test bundle exec rails app:db:drop app:db:create app:db:migrate test`
  - `RAILS_ENV=test bundle exec rake app:wf`
- Use Ruby `3.3.9` and run:
  - `bundle install`
  - `RAILS_ENV=test bundle exec rails app:db:drop app:db:create app:db:migrate test`
  - `RAILS_ENV=test bundle exec rake app:wf`

### R3: Reporting

- Document local-vs-CI environment gaps that can affect reproducibility.

## 4. Known Risks

- `mysql2` native extension may require explicit local linker flags on macOS/Homebrew.
- `app:wf` still depends on external Lola URL and certificate chain availability.
- CI-style `DATABASE_URL=postgres://postgres@127.0.0.1:5432/postgres` may fail locally if role `postgres` does not exist.

## 5. Execution Results (2026-04-17)

- Upgraded in lockfile:
  - `jquery-rails 4.5.1 -> 4.6.1`
  - `mysql2 0.5.4 -> 0.5.7`
  - `sprockets 4.2.0 -> 4.2.2`
  - `sprockets-rails 3.4.2 -> 3.5.2`
  - `pry-rails 0.3.9 -> 0.3.11` (and `pry 0.16.0`)
- Validation passed:
  - Ruby `3.2.9`: `app:db:drop app:db:create app:db:migrate test`, `rake app:wf`
  - Ruby `3.3.9`: `app:db:drop app:db:create app:db:migrate test`, `rake app:wf`
- LoLA source/mirror verification and runtime check:
  - Verified URL: `https://theo.informatik.uni-rostock.de/storages/uni-rostock/Alle_IEF/Inf_THEO/images/tools_daten/lola-2.0.tar.gz`
  - HTTP `200`, archive download and `tar -tzf` listing passed.
  - End-to-end compile succeeded on macOS with `CXXFLAGS='-std=gnu++98'`.
  - Post-build usage checks passed on sample net with JSON output (`AGEF`, dead transition, deadlock-before-end formulas).
