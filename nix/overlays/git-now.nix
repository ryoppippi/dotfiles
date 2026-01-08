_final: prev: {
  git-now = prev.stdenv.mkDerivation rec {
    pname = "git-now";
    version = "0.1.1.0";

    src = prev.fetchFromGitHub {
      owner = "iwata";
      repo = "git-now";
      rev = "v${version}";
      hash = "sha256-r1Xl9i2SXkaxVBjChdsnqgsex8f+AyVsPbBMwLHOVpM=";
    };

    shFlagsSrc = prev.fetchFromGitHub {
      owner = "nvie";
      repo = "shFlags";
      rev = "2fb06af13de884e9680f14a00c82e52a67c867f1";
      hash = "sha256-Xp+2MOIRpe06DoD4+QV8pE+oEdgFQB7/J0jgfV/6WqQ=";
    };

    nativeBuildInputs = [ prev.makeWrapper ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/git-now

      # Copy shFlags library
      cp $shFlagsSrc/src/shflags $out/share/git-now/

      # Copy common file and shFlags symlink to bin (where scripts expect them)
      cp gitnow-common $out/bin/
      ln -s $out/share/git-now/shflags $out/bin/gitnow-shFlags

      # Copy main scripts
      cp git-now $out/bin/
      cp git-now-add $out/bin/
      cp git-now-grep $out/bin/
      cp git-now-push $out/bin/
      cp git-now-rebase $out/bin/

      # Make scripts executable
      chmod +x $out/bin/git-now*

      # Wrap scripts to ensure git is in PATH
      for script in $out/bin/git-now $out/bin/git-now-add $out/bin/git-now-grep $out/bin/git-now-push $out/bin/git-now-rebase; do
        wrapProgram "$script" \
          --prefix PATH : "${prev.lib.makeBinPath [ prev.git ]}"
      done

      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "Command-line tool for light and temporary commits";
      homepage = "https://github.com/iwata/git-now";
      license = licenses.asl20;
      maintainers = [ ];
      platforms = platforms.unix;
    };
  };
}
