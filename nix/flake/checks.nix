{
  perSystem =
    { pkgs, lib, ... }:
    {
      checks.agent-hooks =
        pkgs.runCommand "agent-hooks"
          {
            src = ../modules/home/agent-hooks;
          }
          ''
            ${lib.getExe pkgs.nushell} --no-config-file "$src/require-attribution.test.nu"
            touch "$out"
          '';
    };
}
