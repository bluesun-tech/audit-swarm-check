#!/usr/bin/env bash

set -euo pipefail

RESULTS_DIR="${1:-results}"
OUT="${2:-bundle.json}"

python3 <<PY
import json
import os
import pathlib

checks = {}
root = pathlib.Path("${RESULTS_DIR}")
for path in root.rglob("result.json"):
    name = path.parent.name
    if name.startswith("audit-swarm-"):
        job = name.removeprefix("audit-swarm-")
    else:
        job = name
    checks[job] = json.loads(path.read_text())

pr = os.environ.get("PR", "")
payload = {
    "run_id": os.environ.get("RUN_ID", ""),
    "head_sha": os.environ.get("HEAD_SHA", ""),
    "pull_number": int(pr) if pr.isdigit() else pr,
    "repository": os.environ.get("REPOSITORY", ""),
    "workflow_run_id": int(os.environ.get("WORKFLOW_RUN_ID", "0")),
    "matrix_result": os.environ.get("MATRIX_RESULT", ""),
    "checks": checks,
}

if not checks:
    raise SystemExit("No check results found in artifact download")

pathlib.Path("${OUT}").write_text(json.dumps(payload))
print(f"Bundled {len(checks)} check(s) into ${OUT}")
PY
