_final: prev: {
  audio-priority-bar = prev.stdenv.mkDerivation rec {
    pname = "AudioPriorityBar";
    version = "1.2.1";

    src = prev.fetchurl {
      url = "https://github.com/tobi/AudioPriorityBar/releases/download/v${version}/AudioPriorityBar.zip";
      hash = "sha256-8p8j2M/LkHZapXFpgyVNiqasPHJd6Hs67YYU7vCHO8A=";
    };

    nativeBuildInputs = [ prev.unzip ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall
      mkdir -p $out/Applications
      cp -r AudioPriorityBar.app $out/Applications/
      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "macOS menu bar app for audio device priority management";
      homepage = "https://github.com/tobi/AudioPriorityBar";
      license = licenses.mit;
      platforms = platforms.darwin;
    };
  };
}
