final: _prev: {
  gh-triage = final.buildGoModule rec {
    pname = "gh-triage";
    version = "0.5.0";

    src = final.fetchFromGitHub {
      owner = "k1LoW";
      repo = "gh-triage";
      rev = "v${version}";
      hash = "sha256-/Ok+zxVPXrgcd7louZClXclJfTU2GPCUkJdJMRvI6YA=";
    };

    vendorHash = "sha256-uoc7xZOqkXquAYfAvTyNEfGRLUGzTFVhieRZl4yMCFg=";

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${version}"
    ];

    meta = with final.lib; {
      description = "GitHub CLI extension for triaging issues and PRs";
      homepage = "https://github.com/k1LoW/gh-triage";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
}
