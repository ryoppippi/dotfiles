final: prev: {
  git-branches = prev.stdenv.mkDerivation rec {
    pname = "git-branches";
    version = "0.1.0";

    src = prev.fetchurl {
      url = "https://github.com/kyoh86/git-branches/releases/download/v${version}/git-branches_${version}_darwin_arm64.tar.gz";
      hash = "sha256-oA5CXs9m/0NFjLFujrOH+RbzVMJNRGtqJP3Hd6fXHaY=";
    };

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      install -D -m755 git-branches $out/bin/git-branches
      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "Show each branch, upstream, author in git repository";
      homepage = "https://github.com/kyoh86/git-branches";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "git-branches";
      platforms = [ "aarch64-darwin" ];
    };
  };
}
