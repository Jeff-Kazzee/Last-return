#!/usr/bin/env python3
"""Enforce the documented PR direction and naming convention.

Run: python3 scripts/check_branch_policy.py HEAD_BRANCH BASE_BRANCH
This checks PR naming/direction, not GitHub protection settings.
"""
import re
import sys

TASK_TYPES = {"feat", "fix", "chore", "test", "docs", "art", "refactor", "perf", "spike"}
SLUG = re.compile(r"^[a-z0-9][a-z0-9._-]*$")

def allowed(head: str, base: str) -> tuple[bool, str]:
    if base == "prod":
        if head == "dev" or (head.startswith("hotfix/") and SLUG.fullmatch(head[7:])):
            return True, "Release or production hotfix PR"
        return False, "Only dev or hotfix/* may propose changes to prod"
    if base == "dev":
        if head == "prod":
            return True, "Production hotfix reconciliation"
        prefix, sep, slug = head.partition("/")
        if sep and prefix in TASK_TYPES and SLUG.fullmatch(slug):
            return True, "Task PR into dev"
        return False, "PRs into dev must use a supported task branch or prod hotfix sync"
    return False, f"PR base {base!r} is not a supported integration or release branch"

def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: check_branch_policy.py HEAD_BRANCH BASE_BRANCH", file=sys.stderr)
        return 2
    head, base = sys.argv[1:]
    ok, reason = allowed(head, base)
    print(f"{head} -> {base}: {reason}")
    return 0 if ok else 1

if __name__ == "__main__":
    raise SystemExit(main())
