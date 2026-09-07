{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      writeNu,
      ...
    }:
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
            writeNu "flake-update" ''
              def main [] {
                print "Updating flake.lock..."
                ^nix flake update
                print "Done! Run 'nix run .#switch' to apply changes."
              }
            ''
          );
        };

        update-ai-tools = {
          type = "app";
          program = toString (
            writeNu "update-ai-tools" ''
              def main [] {
                print "Updating AI tools inputs..."
                ^nix flake update llm-agents
                print "Done! Run 'nix run .#switch' to apply changes."
              }
            ''
          );
        };

        # Runs the working-tree copy rather than a store one because it rewrites
        # the generated files back into the repository.
        update-node-packages = {
          type = "app";
          program = toString (
            writeNu "update-node-packages" ''
              # --wrapped so unknown flags reach update.nu instead of being parsed
              # as flags to main.
              def --wrapped main [...rest] {
                exec ${nu} nix/packages/node/update.nu ...$rest
              }
            ''
          );
        };
      };
    };
}
