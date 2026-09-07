{
  perSystem =
    { pkgs, lib, ... }:
    let
      nu = lib.getExe pkgs.nushell;

      # `makeScriptWriter` invokes the check as `${check} $out`, so the script
      # under test arrives as a positional argument rather than on stdin.
      # `--debug` is what makes nu-check exit non-zero instead of printing false.
      nuCheck = pkgs.writeShellScript "nu-check" ''
        exec ${nu} --no-config-file --commands "nu-check --debug '$1'"
      '';
    in
    {
      # `--no-config-file` is baked into the shebang by writeNu, so these scripts
      # never see the interactive Nushell config.
      _module.args.writeNu = name: body: pkgs.writers.writeNu name { check = nuCheck; } body;
    };
}
