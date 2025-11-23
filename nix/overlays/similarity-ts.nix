final: prev: {
  similarity-ts = prev.rustPlatform.buildRustPackage rec {
    pname = "similarity-ts";
    version = "0.2.4";

    src = prev.fetchFromGitHub {
      owner = "mizchi";
      repo = "similarity";
      rev = "v${version}";
      hash = "sha256-Z2ZaKBpq7N8KIX8nOzPhm8evfoUxBzaAK0+4cU9qBDE=";
    };

    cargoHash = "sha256-oYqdCHGY6OZSbYXhjIt20ZL2JkZP7UEOhn0fhuZQnZo=";

    # Build only the similarity-ts crate
    buildAndTestSubdir = "crates/similarity-ts";

    meta = with prev.lib; {
      description = "High-performance code duplicate detection tool for TypeScript/JavaScript";
      homepage = "https://github.com/mizchi/similarity";
      license = licenses.mit;
      maintainers = [ ];
      mainProgram = "similarity-ts";
    };
  };
}
