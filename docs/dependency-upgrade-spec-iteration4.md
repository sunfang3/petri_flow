# Dependency Upgrade Spec (Iteration 4)

Last updated: 2026-04-16

## 1. Scope

This spec covers **Phase 4 / Rails 8.x upgrade**.

Included:
- Upgrade Rails dependency track from 7.2.x to latest 8.x stable.
- Remove known blocker `annotate` (active record `< 8.0` constraint).
- Re-resolve lockfile and run baseline test commands on Ruby 3.2.9.
- Remove deprecated `rails/tasks/statistics.rake` loading from root `Rakefile`.
- Make `app:wf` resilient when external Lola download/build is unavailable.

Excluded:
- Deep refactor of application logic.
- UI redesign or CSS framework migration.

## 2. Files in Scope

- `Gemfile`
- `wf.gemspec`
- `Gemfile.lock`
- `Rakefile`
- `lib/tasks/wf_tasks.rake`
- `test/dummy/db/schema.rb`
- `docs/dependency-upgrade-spec-iteration4.md`

## 3. Requirements

### R1: Rails 8 Constraint

- Runtime dependency must target Rails `>= 8.0, < 9.0`.
- Lockfile must resolve to Rails 8.x.

### R2: Blocker Removal

- Remove `annotate` from dev dependencies to avoid `activerecord < 8.0` conflict.

### R3: Verification

- Use Ruby `3.2.9` and run:
  - `bundle lock --update rails`
  - `bundle install`
  - `bundle exec rails app:db:drop app:db:create app:db:migrate RAILS_ENV=test` (for stale local DBs)
  - `bundle exec rake app:wf`
  - `bundle exec rails test`
  - `bundle exec rake test`

## 4. Known Risks

- Additional deprecations/behavior shifts may appear when loading a Rails 6-era dummy app under Rails 8.
- Old auxiliary gems (e.g. asset-related plugins) may still emit warnings.
- `app:wf` relies on an external Lola source URL/cert chain; task now warns and skips instead of failing hard.
