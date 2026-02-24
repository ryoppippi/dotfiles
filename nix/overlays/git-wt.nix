final: prev: {
  git-wt = prev.buildGo126Module (finalAttrs: {
    pname = "git-wt";
    version = "0.25.0";

    src = prev.fetchFromGitHub {
      owner = "k1LoW";
      repo = "git-wt";
      tag = "v${finalAttrs.version}";
      hash = "sha256-QdyONDVokpOaH5dI5v1rmaymCgIiWZ16h26FAIsAHPc=";
    };

    vendorHash = "sha256-O4vqouNxvA3GvrnpRO6GXDD8ysPfFCaaSJVFj2ufxwI=";

    nativeBuildInputs = [ prev.installShellFiles ];

    buildFlagsArray = [
      "-ldflags"
      "-X"
      "github.com/k1LoW/git-wt/version.Version=v${finalAttrs.version}"
    ];

    nativeCheckInputs = [ prev.git ];

    postInstall = ''
      installShellCompletion --cmd git-wt \
        --bash <($out/bin/git-wt --init bash --nocd) \
        --zsh <($out/bin/git-wt --init zsh --nocd) \
        --fish <($out/bin/git-wt --init fish --nocd)
    '';
  });
}
