final: prev: {
  bluetooth-connector = prev.stdenv.mkDerivation rec {
    pname = "BluetoothConnector";
    version = "2.1.0";

    src = prev.fetchurl {
      url = "https://github.com/lapfelix/BluetoothConnector/releases/download/${version}/BluetoothConnector";
      hash = "sha256-5Bq8jPIv1erDE63BpWm1d3vbAbAB8eD2iCaQmt/W/Do=";
    };

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 $src $out/bin/BluetoothConnector
      runHook postInstall
    '';

    meta = with prev.lib; {
      description = "Simple macOS CLI to connect/disconnect a Bluetooth device";
      homepage = "https://github.com/lapfelix/BluetoothConnector";
      license = licenses.mit;
      platforms = platforms.darwin;
      mainProgram = "BluetoothConnector";
    };
  };
}
