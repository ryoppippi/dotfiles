final: _prev: {
  gh-triage = final.buildGoModule rec {
    pname = "gh-triage";
    version = "0.11.0";

    src = final.fetchFromGitHub {
      owner = "k1LoW";
      repo = "gh-triage";
      rev = "v${version}";
      hash = "sha256-aa98DfXxyOuk1Q7yYGKNqYqTa9tuNP57hYwNqIYxPeo=";
    };

    vendorHash = "sha256-uBPwtlOpdWvGg+ZZNu8b1XCn2vDN5J6qwFeZFGC5V4s=";

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
