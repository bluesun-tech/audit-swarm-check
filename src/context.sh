#!/usr/bin/env bash

set -euo pipefail

BASE_SHA=$(git merge-base origin/main HEAD)
HEAD_SHA=$(git rev-parse HEAD)

git diff "$BASE_SHA...HEAD" > /tmp/diff.patch
git diff --name-only "$BASE_SHA...HEAD" > /tmp/files.txt
