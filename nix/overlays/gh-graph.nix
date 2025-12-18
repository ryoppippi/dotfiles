final: prev: {
  gh-graph = final.stdenv.mkDerivation rec {
    pname = "gh-graph";
    version = "unstable-2024-10-18";

    src = final.fetchFromGitHub {
      owner = "kawarimidoll";
      repo = "gh-graph";
      rev = "f5982ff53393d33d1efce7568044060c7893aa8a";
      hash = "sha256-X9BVbn/eFCu57TmMXshFvYY2XgP2F5mAESJTSF8/GbQ=";
    };

    nativeBuildInputs = [ final.makeWrapper ];

    installPhase = ''
      runHook preInstall
      install -Dm755 gh-graph $out/bin/gh-graph
      wrapProgram $out/bin/gh-graph \
        --prefix PATH : ${
          final.lib.makeBinPath [
            final.curl
            final.gh
          ]
        }
      runHook postInstall
    '';

    meta = with final.lib; {
      description = "GitHub CLI extension to show contribution graph";
      homepage = "https://github.com/kawarimidoll/gh-graph";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "gh-graph";
    };
  };
}
