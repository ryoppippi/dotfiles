final: prev: {
  oglens = prev.rustPlatform.buildRustPackage rec {
    pname = "oglens";
    version = "0.1.1";

    src = prev.fetchFromGitHub {
      owner = "uzimaru0000";
      repo = "oglens";
      rev = "v${version}";
      hash = "sha256-8ycWZFcqd9fSrV3LBukXdKjif9hpfnfn7pSE+6JB8u4=";
    };

    cargoHash = "sha256-pKf15OJbzCHRPnFFPJlakd8gyoErtmTEzkbqduA8hjY=";

    meta = with prev.lib; {
      description = "JSON viewer";
      homepage = "https://github.com/uzimaru0000/oglens";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "oglens";
    };
  };
}
