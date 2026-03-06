final: _prev: {
  gh-poi = final.buildGoModule rec {
    pname = "gh-poi";
    version = "0.15.3";

    src = final.fetchFromGitHub {
      owner = "seachicken";
      repo = "gh-poi";
      rev = "v${version}";
      hash = "sha256-Ycq5uEp+Slae1G4DXiZnjk4UvbnXoTMmpPq0Kx5AHow=";
    };

    vendorHash = "sha256-UHkNSTRH9m6H8Wh7S7uUy5SHuGe0uAmmYuoeR76C7m0=";

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${version}"
    ];

    meta = with final.lib; {
      description = "GitHub CLI extension to safely clean up your local branches";
      homepage = "https://github.com/seachicken/gh-poi";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
}
