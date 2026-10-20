# comma, except that with no terminal to show its picker on (an agent's shell)
# it chooses the package itself instead of failing with "Failed to open tty".
# A terminal keeps the usual picker.
{
  lib,
  gawk,
  symlinkJoin,
  writeShellScript,
  comma-with-db,
}:
let
  # stdin: the packages that provide the command, one `<attr>.<output>` per
  # line. It prints the one to run, and says on stderr which and why.
  picker = writeShellScript "comma-pick" ''
    exec ${lib.getExe gawk} -v cmd="$COMMA_CMD" '
      { line[NR] = $0 }
      END {
        # The package named after the command: cowsay.out over neo-cowsay.out.
        for (i = 1; i <= NR; i++) {
          attr = line[i]
          sub(/\.[^.]*$/, "", attr)
          if (attr == cmd) { pick = line[i]; break }
        }
        # Otherwise the shortest attribute path that is not a test fixture.
        if (pick == "") {
          for (i = 1; i <= NR; i++) {
            if (line[i] ~ /^tests\./) continue
            depth = gsub(/\./, ".", line[i])
            if (pick == "" || depth < best) { pick = line[i]; best = depth }
          }
        }
        if (pick == "") pick = line[1]
        printf "comma: no terminal to choose on, so running %s (`, -p %s` lists all %d)\n", pick, cmd, NR > "/dev/stderr"
        print pick
      }'
  '';

  wrapper = writeShellScript "comma" ''
    if ! { : >/dev/tty; } 2>/dev/null; then
      # The command is the first argument that is neither a flag, a flag's
      # value nor the `man` subcommand.
      cmd= skip=
      for arg in "$@"; do
        if [ -n "$skip" ]; then skip=; continue; fi
        case "$arg" in
          -P | --picker | -F | --nixpkgs-flake | -c | --print-completions | --cache-level) skip=1 ;;
          -* | man) ;;
          *) cmd=$arg; break ;;
        esac
      done
      export COMMA_PICKER="''${COMMA_PICKER:-${picker}}" COMMA_CMD="$cmd"
    fi
    exec ${comma-with-db}/bin/comma "$@"
  '';
in
symlinkJoin {
  name = "comma-with-db-auto-pick";
  paths = [ comma-with-db ];
  postBuild = ''
    rm $out/bin/, $out/bin/comma
    ln -s ${wrapper} $out/bin/,
    ln -s ${wrapper} $out/bin/comma
  '';
  meta.mainProgram = "comma";
}
