# Dependency Upgrade Spec (Iteration 3)

Last updated: 2026-04-16

## 1. Scope

This spec covers **Phase 3 / Frontend compatibility decoupling**.

Included:
- Remove `bootstrap4-kaminari-views` dependency and usage.
- Remove Bootstrap4-specific pagination theme binding.
- Remove Select2 Bootstrap4 theme binding from styles and JS initialization.

Excluded:
- Full Bootstrap 5 migration.
- Rework of all Bootstrap class names in templates.
- Rails 8.x upgrade.

## 2. Files in Scope

- `Gemfile`
- `wf.gemspec`
- `lib/wf/engine.rb`
- `app/views/wf/cases/index.html.erb`
- `app/views/wf/forms/index.html.erb`
- `app/views/wf/workflows/index.html.erb`
- `app/views/wf/workitems/index.html.erb`
- `app/views/wf/workitems/pre_finish.html.erb`
- `app/assets/stylesheets/wf/application.scss`
- `Gemfile.lock`

## 3. Requirements

### R1: Remove Bootstrap4 Kaminari Theme Gem

- `bootstrap4-kaminari-views` must be removed from runtime and development dependencies.
- `require "bootstrap4-kaminari-views"` must be removed from engine boot path.

### R2: Remove Bootstrap4 Pagination Theme Coupling

- `paginate` calls must not hardcode `theme: 'twitter-bootstrap-4'`.

### R3: Remove Bootstrap4 Select2 Theme Coupling

- Stylesheet must not require `select2-bootstrap4`.
- Select2 JS initialization must not set `theme: "bootstrap4"`.

### R4: Verification

- Run with Ruby `3.2.9`:
  - `bundle lock` / `bundle install`
  - `bundle exec rails test`

## 4. Known Risks

- Pagination may appear less styled until a new shared theme approach is introduced.
- Select2 visuals may differ slightly without Bootstrap4-specific skin.
