final: prev: {
  tv = prev.rustPlatform.buildRustPackage rec {
    pname = "tv";
    version = "0.7.0";

    src = prev.fetchFromGitHub {
      owner = "uzimaru0000";
      repo = "tv";
      rev = "v${version}";
      hash = "sha256-qODv45smZ6jHCJBaa6EEvFLG+7g+FWrRf6BiHRFLzqM=";
    };

    cargoHash = "sha256-pg8u+1C68ilg0uhszQnsN1bRbniJd39yQHujerQx+mI=";

    meta = with prev.lib; {
      description = "TSV viewer";
      homepage = "https://github.com/uzimaru0000/tv";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "tv";
    };
  };
}
