{
  pkgs,
  lib ? pkgs.lib,
}:
let
  inherit (pkgs) buildNpmPackage fetchzip;

  # Helper for npm CLI packages from registry
  mkNpmPackage =
    {
      pname,
      npmName ? pname,
      version,
      hash,
      npmDepsHash,
      description,
      homepage,
      license ? lib.licenses.mit,
      mainProgram ? pname,
      forceEmptyCache ? false,
      npmFlags ? [ ],
      env ? { },
      postInstall ? "",
    }:
    buildNpmPackage rec {
      inherit
        pname
        version
        npmDepsHash
        npmFlags
        env
        postInstall
        ;
      inherit forceEmptyCache;

      src = fetchzip {
        url = "https://registry.npmjs.org/${npmName}/-/${pname}-${version}.tgz";
        inherit hash;
      };

      postPatch = ''
        cp ${./${pname}/package-lock.json} package-lock.json
        mkdir -p node_modules
      '';

      dontNpmBuild = true;

      meta = {
        inherit
          description
          homepage
          license
          mainProgram
          ;
      };
    };
in
{
  cssmodules-language-server = mkNpmPackage {
    pname = "cssmodules-language-server";
    version = "1.5.2";
    hash = "sha256-T3I4wosgdq+EDq20HFtWDEdxyOK590QqSduKclFw7Zg=";
    npmDepsHash = "sha256-xyP82fpNFEVs4HDydIR/fCJp3kkQKlA0FiUEIiPbZZQ=";
    description = "Language server for CSS Modules";
    homepage = "https://github.com/antonk52/cssmodules-language-server";
    mainProgram = "cssmodules-language-server";
  };

  gh-actions-language-server = mkNpmPackage {
    pname = "gh-actions-language-server";
    version = "0.0.3";
    hash = "sha256-vTRClb1oyqH1u4Rvqu9xoCNcWeMBn9aIZ6Vj1sZYcrY=";
    npmDepsHash = "sha256-ftVhsu3mU/Gk7xO9Eh9D0aCdR6FZp/rPwCYVWtDACrw=";
    description = "GitHub Actions Language Server";
    homepage = "https://github.com/lttb/gh-actions-language-server";
    mainProgram = "gh-actions-language-server";
  };

  unocss-language-server = mkNpmPackage {
    pname = "unocss-language-server";
    version = "0.1.9";
    hash = "sha256-MybWS44jNSJTksxa8F1lNTdO80poceVm3wCj2wPwImw=";
    npmDepsHash = "sha256-liURgUcZBXLm+ex108IoFLFaLIh6RsEJhj+udn09XkQ=";
    description = "UnoCSS Language Server";
    homepage = "https://github.com/unocss/unocss";
    mainProgram = "unocss-language-server";
  };
}
