{ inputs, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      nu = lib.getExe pkgs.nushell;
    in
    {
      apps = {
        # Resolve every registry/sources/*.nix pin and rewrite
        # registry/sources.lock.json. Replaces `nix flake update <skill>`
        # for skill repositories.
        skills-sources-lock = {
          type = "app";
          program = "${
            inputs.agent-skills.lib.agent-skills.mkSourceLockProgram {
              inherit pkgs;
            }
          }/bin/skills-sources-lock";
        };

        update = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "flake-update" ''
              set -e
              echo "Updating flake.lock..."
              nix flake update
              echo "Done! Run 'nix run .#switch' to apply changes."
            ''
          );
        };

        update-ai-tools = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-ai-tools" ''
              set -e
              echo "Updating AI tools inputs..."
              nix flake update llm-agents
              echo "Done! Run 'nix run .#switch' to apply changes."
            ''
          );
        };

        update-node-packages = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "update-node-packages" ''
              set -e
              exec ${nu} nix/packages/node/update.nu "$@"
            ''
          );
        };
      };
    };
}
