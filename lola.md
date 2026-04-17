## LoLA

LoLA is a Petri net model-checking tool used by this project for workflow net checks.

## Source Package

Current `lola-2.0.tar.gz` source URL:

`https://theo.informatik.uni-rostock.de/storages/uni-rostock/Alle_IEF/Inf_THEO/images/tools_daten/lola-2.0.tar.gz`

Validation status (2026-04-17):

- HTTP status: `200`
- `content-type`: `application/x-gzip`
- Download and `tar -tzf` extraction listing: success

## Build (Recommended via Rake task)

The project provides `app:wf` to download/build/install LoLA into a local prefix under dummy app tmp:

- install location: `test/dummy/tmp/lola-prefix/bin/lola`

Example:

```bash
RAILS_ENV=test \
WF_LOLA_URL='https://theo.informatik.uni-rostock.de/storages/uni-rostock/Alle_IEF/Inf_THEO/images/tools_daten/lola-2.0.tar.gz' \
CXXFLAGS='-std=gnu++98' \
bundle exec rake app:wf
```

Notes:

- `WF_LOLA_URL` can override source URL if needed.
- On modern macOS/clang, LoLA 2.0 may require `CXXFLAGS='-std=gnu++98'` to compile successfully.

## Manual Build (if you need to debug build issues)

```bash
curl -fL -o lola.tar.gz 'https://theo.informatik.uni-rostock.de/storages/uni-rostock/Alle_IEF/Inf_THEO/images/tools_daten/lola-2.0.tar.gz'
tar -zxf lola.tar.gz
cd lola-2.0
CXXFLAGS='-std=gnu++98' ./configure --prefix="$PWD/../lola-prefix"
make
make install
```

## End-to-End Usage Example

1) Create a minimal Petri net file:

```text
PLACE P1,P2,P3;

MARKING P1;

TRANSITION T1
CONSUME P1:1;
PRODUCE P3:1;

TRANSITION T2
CONSUME P3:1;
PRODUCE P2:1;
```

2) Run model checking with JSON output:

```bash
LOLA_BIN='test/dummy/tmp/lola-prefix/bin/lola'
NET='test/dummy/tmp/sample-flow.lola'
OUT='test/dummy/tmp/lola-run'
mkdir -p "$OUT"

"$LOLA_BIN" "$NET" --markinglimit=1000 --timelimit=5 \
  --formula="AGEF(P1 = 0 AND P3 = 0 AND P2 >= 1)" \
  --json="$OUT/reachability.json"

"$LOLA_BIN" "$NET" --markinglimit=1000 --timelimit=5 \
  --formula="AG NOT FIREABLE (T1)" \
  --json="$OUT/dead_transition_t1.json"

"$LOLA_BIN" "$NET" --markinglimit=1000 --timelimit=5 \
  --formula="EF (DEADLOCK AND (P2 = 0))" \
  --json="$OUT/deadlock_before_end.json"
```

3) Expected result summary for this net:

- `reachability.json`: `analysis.result = true`
- `dead_transition_t1.json`: `analysis.result = false`
- `deadlock_before_end.json`: `analysis.result = false`

## Integration Notes

- Runtime checks in `Wf::Lola` invoke `lola` directly from `PATH`.
- If you use the local prefix build, either:
  - call binary by absolute path, or
  - export `PATH="$PWD/test/dummy/tmp/lola-prefix/bin:$PATH"` before app-level checks.
