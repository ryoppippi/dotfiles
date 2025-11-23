final: prev: {
  # AI tools from nix-ai-tools (https://github.com/numtide/nix-ai-tools)
  inherit (prev._ai-tools.packages.${prev.system})
    amp
    codex
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
    ;
}
