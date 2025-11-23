final: prev: {
  gyazo-cli = prev.buildGoModule rec {
    pname = "gyazo-cli";
    version = "1.0.0";

    src = prev.fetchFromGitHub {
      owner = "tomohiro";
      repo = "gyazo-cli";
      rev = version;
      hash = "sha256-okGPPhPtoAP25p7J9MXJUIa1VBywlLRsbSnhEUWka3s=";
    };

    vendorHash = "sha256-xQFTheCNQZpz55ypa9C1nFJSkLweeqO+XQtJtM8RidA=";

    meta = with prev.lib; {
      description = "Gyazo CLI client";
      homepage = "https://github.com/tomohiro/gyazo-cli";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "gyazo-cli";
    };
  };
}
