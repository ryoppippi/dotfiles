final: prev: {
  # AI tools from llm-agents.nix (https://github.com/numtide/llm-agents.nix)
  inherit (prev._llm-agents.packages.${prev.system})
    amp
    claude-code
    codex
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
    ;
}
