# LoLA Integration Guide

Last updated: 2026-04-17

## 1. Binary Resolution Order

Petri Flow resolves the LoLA executable in this order:

1. `WF_LOLA_BIN` (environment variable)
2. `Wf.lola_bin` (application initializer config)
3. bundled binary at `tmp/lola-prefix/bin/lola` (if executable)
4. `lola` from global `PATH`

## 2. Build Bundled LoLA

Use the built-in task:

```bash
bundle exec rake app:wf
```

Optional environment variables:

- `WF_LOLA_URL`: source tarball URL  
  default: `https://theo.informatik.uni-rostock.de/storages/uni-rostock/Alle_IEF/Inf_THEO/images/tools_daten/lola-2.0.tar.gz`
- `CXXFLAGS=-std=gnu++98`: useful on modern compilers for LoLA 2.0 build compatibility

## 3. Configure Explicit Binary Path

### Option A: per-process via env

```bash
export WF_LOLA_BIN=/absolute/path/to/lola
```

### Option B: app initializer

```ruby
# config/initializers/wf_config.rb
Wf.lola_bin = "/absolute/path/to/lola"
```

## 4. Diagnose Runtime Readiness

Run:

```bash
bundle exec rake app:wf:lola:doctor
```

The task reports:

- env/config values
- bundled binary location and executable status
- resolved final binary
- final readiness status (`READY` or `NOT READY`)

If not ready, it exits with code `1` and prints remediation hints.

## 5. OS Notes

### macOS

- install build tools (`xcode-select --install`)
- for Graphviz-dependent features: `brew install graphviz`

### Ubuntu/Debian

- install build tools: `build-essential`
- CI also installs: `libpq-dev`, `default-libmysqlclient-dev`, `graphviz`

## 6. Troubleshooting

- `LoLA command failed ...`: run `bundle exec rake app:wf:lola:doctor` first.
- build fails during `make`: retry with `CXXFLAGS=-std=gnu++98`.
- custom path ignored: verify absolute path and executable permission (`chmod +x`).
