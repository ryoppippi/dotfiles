final: prev: {
  gh-do = final.buildGoModule rec {
    pname = "gh-do";
    version = "0.4.0";

    src = final.fetchFromGitHub {
      owner = "k1LoW";
      repo = "gh-do";
      rev = "v${version}";
      hash = "sha256-s8E+CXtImic+/5SQaBKtS92C11i/IWL5Y3Pb/6No470=";
    };

    vendorHash = "sha256-AbbdwfiUoZhVCV5HMZDidabe7zSWAlmGA/EtAobImfU=";

    ldflags = [
      "-s"
      "-w"
      "-X main.version=${version}"
    ];

    meta = with final.lib; {
      description = "GitHub CLI extension for task management";
      homepage = "https://github.com/k1LoW/gh-do";
      license = licenses.mit;
      maintainers = [ ];
    };
  };
}
