final: prev: {
  sheep = prev.buildGoModule rec {
    pname = "sheep";
    version = "0.4.0";

    src = prev.fetchFromGitHub {
      owner = "koki-develop";
      repo = "sheep";
      rev = "v${version}";
      hash = "sha256-80SPtlCsT4ewf/HmIxxlw3yxKTW9qxiANDOG0FvgSpI=";
    };

    vendorHash = "sha256-ZrkfKlrCPKyaSkk3CyANUAcVRvrcZjXad+b3rBodk8o=";

    meta = with prev.lib; {
      description = "Sleep with Sheep - A simple sleep/timer CLI tool";
      homepage = "https://github.com/koki-develop/sheep";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "sheep";
    };
  };
}
