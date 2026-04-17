# High-Risk Upgrade Research

Last updated: 2026-04-18

## 1. Current Baseline

- `bootstrap`: `4.4.1`
- `mini_racer`: `0.6.3` (with `libv8-node ~> 16.10.0.0`)
- `rgl`: `0.5.9`

Observed local usage highlights:

- Bootstrap/jQuery coupling is broad in views/assets (`btn-*`, `badge-*`, `custom-select`, Sprockets `require bootstrap`, `select2-full`).
- `mini_racer` is directly used in guard expression evaluation (`Wf::Guard#check_exp`).
- `rgl` is used in workflow validation (`Workflow#do_validate!` via `graph.path?`).

## 2. Upstream Snapshot (verified 2026-04-18)

- `bootstrap` latest: `5.3.8` (RubyGems)
- `mini_racer` latest: `0.20.0` (RubyGems), runtime dependency `libv8-node ~> 24.12.0.1`
- `libv8-node` latest: `24.12.0.1` (RubyGems)
- `rgl` latest: `0.6.6` (RubyGems)

## 3. Risk Matrix

| Track | Current -> Target | Risk | Why |
|---|---|---|---|
| Bootstrap | `4.4.1 -> 5.3.x` | High | Wide template/css/js blast radius; Bootstrap v5 migration includes major dependency and utility changes. |
| mini_racer/libv8-node | `0.6.3 + 16.10 -> 0.20.0 + 24.12` | High | JS engine/runtime jump across multiple major generations; guard expression behavior is runtime-critical. |
| rgl | `0.5.9 -> 0.6.6` | Medium | Core API likely stable for current usage, but graph traversal/path behavior is workflow-validity critical. |

## 4. Track Details

### 4.1 Bootstrap 5 Track

Primary external deltas:

- Bootstrap v5 migration declares:
  - dropped jQuery
  - Popper v2 adoption
  - broader utility/class and Sass pipeline changes

Local impact (inference from codebase scan):

- `app/assets/javascripts/wf/application.js` currently requires `bootstrap` and `select2-full` through jQuery-driven pipeline.
- templates use Bootstrap 4 style classes (`custom-select`, `badge badge-*`, etc.), requiring compatibility pass.
- pagination/select2 styling needs revalidation after earlier decoupling work.

Migration proposal:

1. Introduce dedicated compatibility branch for UI migration.
2. Upgrade bootstrap gem and normalize markup/classes in engine templates.
3. Reconcile Select2 styling path without Bootstrap 4 assumptions.
4. Validate all CRUD/workitem pages via integration smoke tests.

Rollback:

- revert `Gemfile.lock`/style-template commit set to Bootstrap 4 pin;
- keep a pre-upgrade tag to enable one-command rollback.

### 4.2 mini_racer/libv8-node Track

Primary external deltas:

- `mini_racer` latest pins to Node 24 line (`libv8-node ~> 24.12.0.1`).
- changelog indicates significant runtime and serialization/exception handling updates across recent versions.

Local impact:

- `Wf::Guard#check_exp` relies on `MiniRacer::Context` and `eval` results for workflow routing.
- any semantic/runtime drift can change guard outcomes or crash behavior.

Migration proposal:

1. Upgrade `mini_racer` + lockfile in isolated change set.
2. Add focused tests for guard expression truthiness, type conversions, and exception propagation.
3. Run high-volume guard evaluation smoke (case creation/workitem finish paths).

Rollback:

- pin back to `mini_racer 0.6.3` and `libv8-node 16.10.0.0` lock resolution;
- revert only JS-engine track commits without touching unrelated dependency tracks.

### 4.3 rgl Track

Primary external deltas:

- latest release is `0.6.6`;
- changelog shows ongoing fixes and dependency requirement updates, with `Graph#path?` introduced earlier in `0.5.6`.

Local impact:

- current code uses `RGL::DirectedAdjacencyGraph` and `path?` checks in workflow validation.
- API surface used is small, but correctness is business-critical.

Migration proposal:

1. Upgrade `rgl` to latest in isolation.
2. Run/add focused tests around `Workflow#do_validate!` path reachability assertions.
3. Rebuild representative workflow nets (linear, branching, unreachable nodes) and confirm error messages unchanged.

Rollback:

- pin `rgl` back to `0.5.9`;
- revert isolated rgl-only commit.

## 5. Sequencing Recommendation

Recommended execution order:

1. `rgl` track (smallest surface, medium risk)
2. `mini_racer/libv8-node` track (runtime-critical)
3. `bootstrap` track (largest UI blast radius)

Rationale:

- do lower-blast-radius runtime dependency first to reduce concurrent unknowns;
- keep UI migration last so behavior regressions can be attributed more clearly.

## 6. Go/No-Go Gates Per Track

- green CI matrix (`ruby 3.2`, `3.3`)
- full `rails test` green
- no increase in unresolved placeholder tests
- explicit rollback command path documented in each track PR

## 7. Sources

- Bootstrap gem page: https://rubygems.org/gems/bootstrap
- Bootstrap v5 migration guide: https://getbootstrap.com/docs/5.3/migration/
- mini_racer gem page: https://rubygems.org/gems/mini_racer
- mini_racer changelog (`v0.20.0`): https://raw.githubusercontent.com/rubyjs/mini_racer/refs/tags/v0.20.0/CHANGELOG
- libv8-node gem page: https://rubygems.org/gems/libv8-node
- rgl gem page: https://rubygems.org/gems/rgl
- rgl changelog: https://github.com/monora/rgl/blob/master/CHANGELOG.md
