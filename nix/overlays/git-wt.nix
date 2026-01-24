final: _prev: {
  git-wt = final.buildGoModule rec {
    pname = "git-wt";
    version = "0.15.0";

    src = final.fetchFromGitHub {
      owner = "k1LoW";
      repo = "git-wt";
      rev = "v${version}";
      hash = "sha256-A8vkwa8+RfupP9UaUuSVjkt5HtWvqR5VmSsVg2KpeMo=";
    };

    vendorHash = "sha256-K5geAvG+mvnKeixOyZt0C1T5ojSBFmx2K/Msol0HsSg=";

    ldflags = [
      "-s"
      "-w"
      "-X github.com/k1LoW/git-wt/version.Version=${version}"
    ];

    # Skip e2e tests that require git in sandbox
    doCheck = false;

    nativeBuildInputs = [ final.installShellFiles ];

    postInstall = ''
      installShellCompletion --cmd git-wt \
        --bash <($out/bin/git-wt completion bash) \
        --fish <($out/bin/git-wt completion fish) \
        --zsh <($out/bin/git-wt completion zsh)
    '';

    meta = with final.lib; {
      description = "A Git subcommand that makes git worktree simple";
      homepage = "https://github.com/k1LoW/git-wt";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "git-wt";
    };
  };
}
