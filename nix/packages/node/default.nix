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
  gh-actions-language-server = mkNpmPackage {
    pname = "gh-actions-language-server";
    version = "0.0.3";
    hash = "sha256-vTRClb1oyqH1u4Rvqu9xoCNcWeMBn9aIZ6Vj1sZYcrY=";
    npmDepsHash = "sha256-mu4ZmokeQzQMRzDobMzXkdAlOTNm/ahHYERi1n+By3c=";
    description = "GitHub Actions Language Server";
    homepage = "https://github.com/actions/languageservices";
    mainProgram = "gh-actions-language-server";
  };

  typescript-svelte-plugin = mkNpmPackage {
    pname = "typescript-svelte-plugin";
    version = "0.3.50";
    hash = "sha256-QE9dp4Mh6ttNrc2vLVaoEwYZWHGIK22pFQvEpX7+3jY=";
    npmDepsHash = "sha256-ojwxXkTfgQpSjnB2qlBtpTETRI3m8N/heDqsFLO/Wi4=";
    description = "A TypeScript plugin for Svelte intellisense";
    homepage = "https://github.com/sveltejs/language-tools";
    mainProgram = "typescript-svelte-plugin";
  };

  unocss-language-server = mkNpmPackage {
    pname = "unocss-language-server";
    version = "0.1.8";
    hash = "sha256-jHFuTpcf4dk8i7Ty1HS9A8OOLarct3w/jovE6/KZHDs=";
    npmDepsHash = "sha256-hqo+J1o4sG+jGQBSGwQ1uvSCS9mCFX6TfjEC9kut9fI=";
    description = "UnoCSS Language Server";
    homepage = "https://github.com/unocss/unocss";
    mainProgram = "unocss-language-server";
  };
}
