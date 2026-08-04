{
  pkgs,
  tgrab,
  ...
}:
let
  # pi has no built-in web tool, so it searches by running these CLIs itself.
  # ax and tgrab are otherwise scoped to the web-fetch skill directory, which a
  # pi process launched from an arbitrary cwd cannot reach; bun is what the exa
  # SDK scripts run on, and rg/fd are how it investigates a codebase.
  subagentTools = [
    pkgs.llm-agents.ax
    tgrab.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.llm-agents.grok
    pkgs.bun
    pkgs.ripgrep
    pkgs.fd
  ];

  # Delegated grunt work is billed to the Codex subscription rather than to the
  # calling agent's tokens. The flags keep it throwaway: no session on disk, no
  # AGENTS.md/CLAUDE.md in the prompt, and no edit or write tools, so a subagent
  # cannot change the repo it was launched from.
  pi-sub = pkgs.writeShellApplication {
    name = "pi-sub";
    runtimeInputs = [ pkgs.llm-agents.pi ] ++ subagentTools;
    text = ''
      exec pi \
        --print \
        --provider "''${PI_SUB_PROVIDER:-openai-codex}" \
        --model "''${PI_SUB_MODEL:-gpt-5.6-luna}" \
        --thinking "''${PI_SUB_THINKING:-low}" \
        --no-session \
        --no-context-files \
        --tools bash,read \
        "$@"
    '';
  };
in
{
  home.packages = [
    pkgs.llm-agents.pi
    pi-sub
  ];
}
