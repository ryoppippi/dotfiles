final: prev: {
  git-branches = prev.buildGoModule rec {
    pname = "git-branches";
    version = "0.1.0";

    src = prev.fetchFromGitHub {
      owner = "kyoh86";
      repo = "git-branches";
      rev = "v${version}";
      hash = "sha256-IbqIU+tDhMhLpjRVtZMw+g0dBNXzM8Nao+Qn0nEWmAY=";
    };

    vendorHash = "sha256-NXCOGvRg4y9vq1gU2GRbFKM++nqcgwp8Rz1/FEGqvkM=";

    ldflags = [ "-s" "-w" ];

    meta = with prev.lib; {
      description = "Show each branch, upstream, author in git repository";
      homepage = "https://github.com/kyoh86/git-branches";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "git-branches";
    };
  };
}
