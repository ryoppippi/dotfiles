final: _prev: {
  roots = final.buildGoModule rec {
    pname = "roots";
    version = "0.4.1";

    src = final.fetchFromGitHub {
      owner = "k1LoW";
      repo = "roots";
      rev = "v${version}";
      hash = "sha256-ACMRfWY/lhc3C/KVhuUyS1rgkSHGWPxZrmYt+pXupJI=";
    };

    vendorHash = "sha256-uxcT5VzlTCxxnx09p13mot0wVbbas/otoHdg7QSDt4E=";

    ldflags = [
      "-s"
      "-w"
      "-X github.com/k1LoW/roots/version.Version=${version}"
    ];

    nativeBuildInputs = [ final.installShellFiles ];

    postInstall = ''
      installShellCompletion --cmd roots \
        --bash <($out/bin/roots completion bash) \
        --fish <($out/bin/roots completion fish) \
        --zsh <($out/bin/roots completion zsh)
    '';

    meta = with final.lib; {
      description = "CLI for finding root directories in monorepo";
      homepage = "https://github.com/k1LoW/roots";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "roots";
    };
  };
}
