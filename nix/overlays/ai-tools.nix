_final: prev: {
  # AI tools from llm-agents.nix (https://github.com/numtide/llm-agents.nix)
  inherit (prev._llm-agents.packages.${prev.stdenv.hostPlatform.system})
    amp
    codex
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
    ;
}
