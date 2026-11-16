# Hooks shared by Claude Code and Codex, which read the same `hooks` shape.
{ pkgs, lib }:
{
  PreToolUse = [
    {
      matcher = "Bash";
      hooks = [
        {
          type = "command";
          command = "${lib.getExe pkgs.nushell} --no-config-file --stdin ${./require-comment-attribution.nu}";
        }
      ];
    }
  ];
}
