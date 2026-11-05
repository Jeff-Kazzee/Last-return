#!/usr/bin/env bash
set -u -o pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

python3 formal/check_duel_model.py || exit $?
set +e
python3 formal/check_duel_model.py --mutate duplicate-goal
mutant_status=$?
set -e
if [ "$mutant_status" -ne 1 ]; then
  echo "FORMAL NEGATIVE CONTROL FAILED: expected counterexample exit 1, got $mutant_status" >&2
  exit 1
fi
echo "FORMAL NEGATIVE CONTROL PASS: duplicate-goal mutation was rejected with exit 1"
