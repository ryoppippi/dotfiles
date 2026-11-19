#!/usr/bin/env python3
"""Exercise the worktree cleaner only against disposable Git repositories."""

from __future__ import annotations

import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest


SCRIPT = Path(__file__).with_name("clean-worktrees.nu")


FAKE_GH = r'''#!/usr/bin/env python3
import json, os, re, sys
mode = os.environ.get("GH_FIXTURE_MODE", "ok")
args = sys.argv[1:]
if args[:2] == ["repo", "view"]:
    print(json.dumps({"owner": {"login": "fixture-owner"}, "name": "fixture-repo"}))
    raise SystemExit(0)
if args[:2] != ["api", "graphql"]:
    print("unexpected gh command: " + repr(args), file=sys.stderr)
    raise SystemExit(2)
if mode == "transport-error":
    print("fixture GraphQL transport failure with full diagnostic", file=sys.stderr)
    raise SystemExit(37)
calls_file = os.environ.get("GH_FIXTURE_CALLS")
call_number = 1
if calls_file:
    try:
        call_number = int(open(calls_file, encoding="utf-8").read()) + 1
    except FileNotFoundError:
        pass
    open(calls_file, "w", encoding="utf-8").write(str(call_number))
query_arg = next((arg for arg in args if arg.startswith("query=")), "")
query = query_arg.removeprefix("query=")
branches = [(alias, json.loads(raw)) for alias, raw in re.findall(r'(b\d+): pullRequests\(headRefName: ("(?:\\.|[^"\\])*")', query)]
prs = json.load(open(os.environ["GH_FIXTURE_PRS"], encoding="utf-8"))
repo = {}
for alias, branch in branches:
    nodes = prs.get(branch, [])
    if mode == "reopen-on-refresh" and call_number > 1:
        nodes = [{**pr, "state": "OPEN"} for pr in nodes]
    repo[alias] = {
        "nodes": nodes,
        "pageInfo": {"hasNextPage": branch in json.load(open(os.environ["GH_FIXTURE_INCOMPLETE"], encoding="utf-8"))},
    }
response = {"data": {"repository": repo}}
if mode == "graphql-error":
    response["errors"] = [{"message": "fixture returned a complete, untruncated GraphQL diagnostic"}]
print(json.dumps(response))
'''


FAKE_GIT = r'''#!/usr/bin/env python3
import os, subprocess, sys
args = sys.argv[1:]
timeout_path = os.environ.get("GIT_TIMEOUT_STATUS_PATH")
if timeout_path and len(args) >= 3 and args[0] == "-C" and args[1] == timeout_path and "status" in args:
    raise SystemExit(124)
path = os.environ.get("GIT_FAIL_STATUS_PATH")
if path and len(args) >= 3 and args[0] == "-C" and args[1] == path and "status" in args:
    print("fixture status failed with a full diagnostic", file=sys.stderr)
    raise SystemExit(29)
remove_path = os.environ.get("GIT_FAIL_REMOVE_PATH")
if remove_path and "worktree" in args and "remove" in args and args[-1] == remove_path:
    print("fixture worktree removal failed with a full diagnostic", file=sys.stderr)
    raise SystemExit(31)
os.execv(os.environ["GIT_REAL"], [os.environ["GIT_REAL"], *args])
'''


def run(*args: str, cwd: Path, env: dict[str, str] | None = None) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, cwd=cwd, env=env, text=True, capture_output=True)


class CleanerFixture(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        if not shutil.which("nu"):
            raise unittest.SkipTest("run inside `nix shell nixpkgs#nushell`")
        cls.git = shutil.which("git")
        if not cls.git:
            raise unittest.SkipTest("git is unavailable")

    def setUp(self) -> None:
        self.temp = tempfile.TemporaryDirectory(prefix="clean-worktrees-")
        self.root = Path(self.temp.name).resolve()
        self.repo = self.root / "repo with spaces"
        self.repo.mkdir()
        self.bin = self.root / "bin"
        self.bin.mkdir()
        (self.bin / "gh").write_text(FAKE_GH, encoding="utf-8")
        (self.bin / "git").write_text(FAKE_GIT, encoding="utf-8")
        (self.bin / "gh").chmod(0o755)
        (self.bin / "git").chmod(0o755)
        self.prs_path = self.root / "prs.json"
        self.incomplete_json_path = self.root / "incomplete.json"
        self.prs: dict[str, list[dict[str, object]]] = {}
        self.incomplete: list[str] = []
        self.env = os.environ.copy()
        self.env.update(
            {
                "PATH": str(self.bin) + os.pathsep + self.env["PATH"],
                "GIT_REAL": self.git,
                "GIT_CONFIG_GLOBAL": os.devnull,
                "GIT_CONFIG_NOSYSTEM": "1",
                "GH_FIXTURE_MODE": "ok",
                "GH_FIXTURE_PRS": str(self.prs_path),
                "GH_FIXTURE_INCOMPLETE": str(self.incomplete_json_path),
            }
        )
        self.git_run("init", "-b", "main")
        (self.repo / ".gitignore").write_text(".env\nignored-dir/\n", encoding="utf-8")
        self.git_run("add", ".gitignore")
        self.git_run(
            "-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid",
            "-c", "commit.gpgsign=false", "commit", "-m", "base",
        )
        self.base = self.git_output("rev-parse", "HEAD")

        self.finished_path, self.finished_head = self.add_worktree(
            "finished-clean", 'finished 東京 "quoted" path', commit=True
        )
        self.add_pr("finished-clean", self.finished_head, "MERGED")

        self.dirty_path, self.dirty_head = self.add_worktree("dirty-branch", "dirty files", commit=True)
        self.add_pr("dirty-branch", self.dirty_head, "CLOSED")
        (self.dirty_path / "untracked data.txt").write_text("keep me", encoding="utf-8")

        self.ignored_path, self.ignored_head = self.add_worktree("ignored-branch", "ignored data", commit=True)
        self.add_pr("ignored-branch", self.ignored_head, "MERGED")
        (self.ignored_path / ".env").write_text("fixture secret-like value", encoding="utf-8")

        self.open_path, self.open_head = self.add_worktree("open-branch", "open pr", commit=True)
        self.add_pr("open-branch", self.open_head, "OPEN")

        self.reused_path, self.reused_head = self.add_worktree("reused-branch", "reused branch", commit=True)
        self.add_pr("reused-branch", self.reused_head, "CLOSED")
        self.add_pr("reused-branch", self.reused_head, "OPEN")

        self.fork_path, self.fork_head = self.add_worktree("fork-branch", "fork pr", commit=True)
        self.add_pr("fork-branch", self.fork_head, "MERGED", cross=True)

        self.ahead_path, self.ahead_head = self.add_worktree("ahead-branch", "new local commit", commit=True)
        self.add_pr("ahead-branch", self.base, "CLOSED")

        self.locked_path, self.locked_head = self.add_worktree("locked-branch", "locked worktree", commit=True)
        self.add_pr("locked-branch", self.locked_head, "CLOSED")
        self.git_run("worktree", "lock", "--reason", "fixture active", str(self.locked_path))

        self.detached_path, self.detached_head = self.add_worktree("detached-branch", "detached worktree", commit=True)
        self.git_run("-C", str(self.detached_path), "checkout", "--detach", self.detached_head)
        self.add_pr("detached-branch", self.detached_head, "MERGED")

        self.status_error_path, self.status_error_head = self.add_worktree("status-error", "status error", commit=True)
        self.add_pr("status-error", self.status_error_head, "MERGED")

        self.protected_path, self.protected_head = self.add_worktree("protected-branch", "guarded/active task", commit=True)
        self.add_pr("protected-branch", self.protected_head, "MERGED")

        self.incomplete_path, self.incomplete_head = self.add_worktree("incomplete-branch", "incomplete results", commit=True)
        self.add_pr("incomplete-branch", self.incomplete_head, "MERGED")
        self.incomplete.append("incomplete-branch")
        self.flush_prs()

    def tearDown(self) -> None:
        self.temp.cleanup()

    def git_run(self, *args: str) -> subprocess.CompletedProcess[str]:
        result = run(self.git, "-C", str(self.repo), *args, cwd=self.root, env=self.env)
        if result.returncode:
            self.fail(f"git {' '.join(args)} failed: {result.stderr}")
        return result

    def git_output(self, *args: str) -> str:
        return self.git_run(*args).stdout.strip()

    def add_worktree(self, branch: str, dirname: str, *, commit: bool) -> tuple[Path, str]:
        path = self.repo.parent / dirname
        path.parent.mkdir(parents=True, exist_ok=True)
        result = run(self.git, "-C", str(self.repo), "worktree", "add", "-b", branch, str(path), self.base, cwd=self.root, env=self.env)
        if result.returncode:
            self.fail(f"git worktree add failed: {result.stderr}")
        if commit:
            (path / "fixture.txt").write_text(branch, encoding="utf-8")
            result = run(self.git, "-C", str(path), "add", "fixture.txt", cwd=self.root, env=self.env)
            self.assertEqual(result.returncode, 0, result.stderr)
            result = run(self.git, "-C", str(path), "-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid", "-c", "commit.gpgsign=false", "commit", "-m", branch, cwd=self.root, env=self.env)
            self.assertEqual(result.returncode, 0, result.stderr)
        head = run(self.git, "-C", str(path), "rev-parse", "HEAD", cwd=self.root, env=self.env).stdout.strip()
        return path, head

    def add_pr(self, branch: str, head: str, state: str, *, cross: bool = False) -> None:
        self.prs.setdefault(branch, []).append(
            {"headRefName": branch, "headRefOid": head, "state": state, "isCrossRepository": cross}
        )

    def flush_prs(self) -> None:
        self.prs_path.write_text(json.dumps(self.prs), encoding="utf-8")
        self.incomplete_json_path.write_text(json.dumps(self.incomplete), encoding="utf-8")

    def cleaner(self, *args: str, cwd: Path | None = None, **env_values: str) -> subprocess.CompletedProcess[str]:
        self.flush_prs()
        env = self.env | env_values
        return run(shutil.which("nu") or "nu", str(SCRIPT), *args, str(self.repo), cwd=cwd or self.root, env=env)

    def test_dry_run_keeps_uncertain_and_protected_worktrees(self) -> None:
        result = self.cleaner("--dry-run", "--keep", str(self.protected_path.parent))
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        self.assertIn(f"would remove:", result.stdout)
        self.assertIn(str(self.finished_path), result.stdout)
        for path in (
            self.dirty_path,
            self.ignored_path,
            self.open_path,
            self.reused_path,
            self.fork_path,
            self.ahead_path,
            self.locked_path,
            self.detached_path,
            self.status_error_path,
            self.protected_path,
            self.incomplete_path,
        ):
            self.assertIn(str(path), result.stdout)
        self.assertIn("kept: worktree has modified, untracked, or ignored files", result.stdout)
        self.assertIn("kept: branch has an open PR", result.stdout)
        self.assertIn("kept: locked", result.stdout)
        self.assertIn("kept: detached HEAD", result.stdout)
        self.assertIn("kept: explicitly protected", result.stdout)
        self.assertIn("PR results exceeded 100", result.stdout)
        for path in (self.finished_path, self.dirty_path, self.ignored_path, self.protected_path):
            self.assertTrue(path.exists(), path)

    def test_git_status_error_never_means_clean(self) -> None:
        result = self.cleaner("--dry-run", GIT_FAIL_STATUS_PATH=str(self.status_error_path))
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        self.assertIn("kept: git status failed: fixture status failed with a full diagnostic", result.stdout)
        self.assertTrue(self.status_error_path.exists())

    def test_status_timeout_keeps_the_worktree(self) -> None:
        result = self.cleaner("--dry-run", GIT_TIMEOUT_STATUS_PATH=str(self.status_error_path))
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        self.assertIn("git status timed out after 30 seconds", result.stdout)
        self.assertTrue(self.status_error_path.exists())

    def test_graphql_errors_are_reported_without_removal(self) -> None:
        for mode, diagnostic in (
            ("transport-error", "fixture GraphQL transport failure with full diagnostic"),
            ("graphql-error", "fixture returned a complete, untruncated GraphQL diagnostic"),
        ):
            result = self.cleaner(GH_FIXTURE_MODE=mode)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn(diagnostic, result.stdout)
            self.assertTrue(self.finished_path.exists())

    def test_open_pr_for_reused_branch_wins_over_older_closed_pr(self) -> None:
        result = self.cleaner("--dry-run")
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        self.assertIn(f"kept: branch has an open PR\t{self.reused_path}", result.stdout)

    def test_new_open_pr_during_refresh_reclassifies_candidate_as_kept(self) -> None:
        calls_path = self.root / "graphql-calls.txt"
        result = self.cleaner(
            GH_FIXTURE_MODE="reopen-on-refresh",
            GH_FIXTURE_CALLS=str(calls_path),
            GIT_FAIL_STATUS_PATH=str(self.status_error_path),
        )
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        self.assertIn(f"kept: branch has an open PR\t{self.finished_path}", result.stdout)
        self.assertTrue(self.finished_path.exists())
        self.assertIn("Removed: 0; would remove: 0; kept: 12; errors: 0", result.stdout)

    def test_active_current_worktree_is_kept(self) -> None:
        nested = self.protected_path / "nested"
        nested.mkdir()
        result = self.cleaner("--dry-run", cwd=nested)
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        self.assertIn(f"kept: current directory\t{self.protected_path}", result.stdout)

    def test_help_describes_wrapped_command_line_options(self) -> None:
        result = run(shutil.which("nu") or "nu", str(SCRIPT), "--help", cwd=self.root, env=self.env)
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        self.assertIn("Usage: clean-worktrees.nu", result.stdout)
        self.assertIn("[--keep PATH]...", result.stdout)

    def test_removes_only_confirmed_worktree_and_retains_its_branch(self) -> None:
        result = self.cleaner(
            "--keep",
            str(self.protected_path.parent),
            GIT_FAIL_STATUS_PATH=str(self.status_error_path),
        )
        self.assertEqual(result.returncode, 0, result.stderr + result.stdout)
        self.assertFalse(self.finished_path.exists())
        self.assertEqual(
            run(self.git, "-C", str(self.repo), "show-ref", "--verify", "--quiet", "refs/heads/finished-clean", cwd=self.root, env=self.env).returncode,
            0,
        )
        self.assertIn("Removed: 1; would remove: 0; kept: 11; errors: 0", result.stdout)
        for path in (self.dirty_path, self.ignored_path, self.open_path, self.reused_path, self.fork_path, self.ahead_path, self.locked_path, self.detached_path, self.status_error_path, self.protected_path, self.incomplete_path):
            self.assertTrue(path.exists(), path)

    def test_git_worktree_remove_failure_is_reported_as_error(self) -> None:
        result = self.cleaner(
            "--keep",
            str(self.protected_path),
            GIT_FAIL_STATUS_PATH=str(self.status_error_path),
            GIT_FAIL_REMOVE_PATH=str(self.finished_path),
        )
        self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("error: git worktree remove failed: fixture worktree removal failed with a full diagnostic", result.stdout)
        self.assertIn("errors: 1", result.stdout)
        self.assertTrue(self.finished_path.exists())


if __name__ == "__main__":
    unittest.main(verbosity=2)
