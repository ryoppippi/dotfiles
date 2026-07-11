{
  lib,
  writeShellApplication,
  runCommand,
  nushell,
  gh,
  git,
  git-wt,
}:
let
  src = runCommand "git-wtpr-src" { } ''
    mkdir -p $out
    cp ${./git-wtpr.nu} $out/git-wtpr.nu
    cp ${./init.fish} $out/init.fish
    cp ${./init.bash} $out/init.bash
  '';
in
writeShellApplication {
  name = "git-wtpr";
  runtimeInputs = [
    nushell
    gh
    git
    git-wt
  ];
  text = ''
    exec nu ${src}/git-wtpr.nu "$@"
  '';
  meta = with lib; {
    description = "Open a GitHub pull request in a git-wt worktree";
    homepage = "https://github.com/ryoppippi/dotfiles";
    license = licenses.mit;
    mainProgram = "git-wtpr";
    platforms = platforms.unix;
  };
}
