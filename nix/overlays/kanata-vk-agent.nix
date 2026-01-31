_final: prev: {
  kanata-vk-agent = prev.stdenv.mkDerivation rec {
    pname = "kanata-vk-agent";
    version = "0.1.0";

    src = prev.fetchurl {
      url = "https://github.com/devsunb/kanata-vk-agent/releases/download/v${version}/kanata-vk-agent_aarch64.tar.gz";
      hash = "sha256-Vum45YJVLOL+Bar9/vFWbDWzsoNlCjbpiuGOeTr1pYk=";
    };

    sourceRoot = ".";

    nativeBuildInputs = [ prev.gnutar ];

    dontConfigure = true;
    dontBuild = true;

    unpackPhase = ''
      runHook preUnpack
      tar -xzf $src
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp kanata-vk-agent $out/bin/
      chmod +x $out/bin/kanata-vk-agent
      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "Virtual key agent for Kanata to enable app-specific key mappings on macOS";
      homepage = "https://github.com/devsunb/kanata-vk-agent";
      license = licenses.mit;
      maintainers = [ ];
      platforms = [ "aarch64-darwin" ];
      mainProgram = "kanata-vk-agent";
    };
  };
}
