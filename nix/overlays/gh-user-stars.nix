final: prev: {
  gh-user-stars = final.stdenv.mkDerivation rec {
    pname = "gh-user-stars";
    version = "unstable-2024-05-19";

    src = final.fetchFromGitHub {
      owner = "korosuke613";
      repo = "gh-user-stars";
      rev = "1829ccdb28159e4924a22e533a5d8b81698dc218";
      hash = "sha256-lXuoBbxd6bViMXpSiDxOoGuLCzrk2YmRotIBjKxmWrA=";
    };

    dontBuild = true;

    patches = [
      (final.writeText "gh-user-stars-tmpdir.patch" ''
        --- a/gh-user-stars
        +++ b/gh-user-stars
        @@ -22,8 +22,9 @@

         choose() {
           number=$1
        -  (loop_list_stars "''${1}" & echo $! >&3) 3>"''${extensionPath}/pid" | fzf --height 90% --layout=reverse
        -  kill $(<"''${extensionPath}/pid") 2>/dev/null
        +  pid_file="''${TMPDIR:-/tmp}/gh-user-stars-$$-$RANDOM.pid"
        +  (loop_list_stars "''${1}" & echo $! >&3) 3>"''${pid_file}" | fzf --height 90% --layout=reverse
        +  kill $(<"''${pid_file}") 2>/dev/null && rm -f "''${pid_file}"
         }

         while [ $# -gt 0 ]; do
      '')
    ];

    installPhase = ''
      runHook preInstall
      install -Dm755 gh-user-stars $out/bin/gh-user-stars
      install -Dm644 libs.sh $out/bin/libs.sh
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "GitHub CLI extension to list user's starred repositories";
      homepage = "https://github.com/korosuke613/gh-user-stars";
      license = licenses.asl20;
      maintainers = [ ];
    };
  };
}
