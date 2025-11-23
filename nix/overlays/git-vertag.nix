final: prev: {
  git-vertag = prev.stdenv.mkDerivation rec {
    pname = "git-vertag";
    version = "2.1.2";

    src = prev.fetchurl {
      url = "https://github.com/kyoh86/git-vertag/releases/download/v${version}/git-vertag_${version}_darwin_arm64.tar.gz";
      hash = "sha256-IVnccqdNDYZewC1mN3JZVY2ALEYZCTgfkmzJz/bBHKA=";
    };

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -D -m755 git-vertag $out/bin/git-vertag
      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "A tool to manage version-tag with the semantic versioning specification";
      homepage = "https://github.com/kyoh86/git-vertag";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "git-vertag";
      platforms = [ "aarch64-darwin" ];
    };
  };
}
