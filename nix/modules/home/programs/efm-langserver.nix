{
  pkgs,
  lib,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };

  # Every tool is referenced by its absolute store path rather than a bare
  # command name, so the generated config is the single declaration of what efm
  # depends on: Nix retains each tool through the config file's own store
  # references, and none of them has to be pushed onto PATH to be found.
  actionlint = lib.getExe pkgs.actionlint;
  bash = lib.getExe pkgs.bash;
  fish = lib.getExe pkgs.fish;
  fishIndent = lib.getExe' pkgs.fish "fish_indent";
  fixjson = lib.getExe pkgs.fixjson;
  gofmt = lib.getExe' pkgs.go "gofmt";
  goimports = lib.getExe' pkgs.gotools "goimports";
  golines = lib.getExe pkgs.golines;
  hadolint = lib.getExe pkgs.hadolint;
  revive = lib.getExe pkgs.revive;
  stylua = lib.getExe pkgs.stylua;
  textlint = lib.getExe pkgs.textlint;
  uv = lib.getExe pkgs.uv;

  # efm substitutes the buffer's path for this placeholder, so it must survive
  # Nix interpolation untouched.
  input = "\${INPUT}";

  goMarkers = [
    "go.mod"
    "go.sum"
  ];

  prettierMarkers = [
    ".prettierrc"
    ".prettierrc.json"
    ".prettierrc.js"
    ".prettierrc.yml"
    ".prettierrc.yaml"
    ".prettierrc.json5"
    ".prettierrc.mjs"
    ".prettierrc.cjs"
    ".prettierrc.toml"
  ];

  # efm's errorformat dialect spells a severity capture as `%t` followed by the
  # letters it should match, so `%trror` matches "error" and binds the severity
  # to `e`.
  severityFormats = [
    "%f:%l:%c: %trror: %m"
    "%f:%l:%c: %tarning: %m"
    "%f:%l:%c: %tote: %m"
  ];

  # Formatters and linters, keyed by the name they had as a YAML anchor in the
  # previous hand-written config. `languages` below inlines these, which is what
  # the `<<: *anchor` merge keys used to produce.
  tools = {
    stylua = {
      format-command = "${stylua} -s --color Never -";
      format-stdin = true;
      require-marker = true;
      root-markers = [
        "stylua.toml"
        ".stylua.toml"
      ];
    };

    # Python tooling deliberately goes through `uv run` instead of a pinned
    # store path: type errors and formatting must follow the version the
    # project itself resolves, not a version this config chose.
    mypy = {
      lint-command = "${uv} run mypy --show-column-numbers";
      lint-formats = severityFormats;
    };

    ruff-format = {
      format-command = "${uv} run ruff format --stdin-filename ${input}";
      format-stdin = true;
    };

    # revive replaces the archived golint. It has no stdin mode, so efm hands
    # it the file path instead of piping the buffer.
    revive = {
      prefix = "revive";
      lint-command = "${revive} -formatter unix ${input}";
      lint-stdin = false;
      lint-formats = [ "%f:%l:%c: %m" ];
      require-marker = true;
      root-markers = goMarkers;
    };

    gofmt = {
      format-command = gofmt;
      format-stdin = true;
      require-marker = true;
      root-markers = goMarkers;
    };

    golines = {
      format-command = golines;
      format-stdin = true;
      require-marker = true;
      root-markers = goMarkers;
    };

    goimports = {
      format-command = goimports;
      format-stdin = true;
      require-marker = true;
      root-markers = goMarkers;
    };

    # The one tool kept as a relative path: web projects pin their own prettier,
    # and formatting must match what the project's CI runs.
    prettier = {
      format-command = "./node_modules/.bin/prettier --stdin --stdin-filepath ${input}";
      format-stdin = true;
      format-can-range = true;
      require-marker = true;
      root-markers = prettierMarkers;
    };

    textlint = {
      lint-command = "${textlint} -f unix --stdin --stdin-filename ${input}";
      lint-ignore-exit-code = true;
      lint-stdin = true;
      lint-formats = [ "%f:%l:%c: %m [%trror/%r]" ];
      root-markers = [
        ".textlintrc"
        ".git"
      ];
    };

    fish-indent = {
      format-command = fishIndent;
      format-stdin = true;
    };

    fish-diagnostics = {
      lint-command = "${fish} --no-execute ${input}";
      lint-stdin = true;
      lint-ignore-exit-code = true;
      lint-formats = [ "%.%#(line %l): %m" ];
    };

    hadolint = {
      lint-command = hadolint;
      lint-stdin = true;
      lint-formats = [ "%f:%l %m" ];
    };

    # actionlint only understands workflow files, so the guard short-circuits
    # before it ever sees an unrelated YAML buffer.
    actionlint = {
      prefix = "actionlint";
      lint-command = "${bash} -c \"[[ '${input}' =~ \\\\.github/workflows/ ]]\" && ${actionlint} -oneline -no-color -";
      lint-stdin = true;
      lint-formats = [ "%f:%l:%c: %m" ];
      root-markers = [ ".github" ];
    };

    fixjson = {
      format-command = "${fixjson} --stdin-filename ${input}";
      format-stdin = true;
    };
  };

  prettierOnlyLanguages = [
    "astro"
    "css"
    "graphql"
    "handlebars"
    "html"
    "javascript"
    "javascript.jsx"
    "javascriptreact"
    "json5"
    "jsonc"
    "less"
    "scss"
    "svelte"
    "typescript"
    "typescript.tsx"
    "typescriptreact"
    "vue"
  ];

  settings = {
    version = 2;
    log-level = 1;
    root-markers = [
      ".git/"
      "package.json"
    ];

    languages =
      lib.genAttrs prettierOnlyLanguages (_: [ tools.prettier ])
      // lib.genAttrs [
        "markdown"
        "markdown.mdx"
      ] (_: [ tools.textlint ])
      // {
        lua = [ tools.stylua ];

        python = [
          tools.mypy
          tools.ruff-format
        ];

        go = [
          tools.revive
          tools.gofmt
          tools.golines
          tools.goimports
        ];

        json = [
          tools.fixjson
          tools.prettier
        ];

        yaml = [
          tools.prettier
          tools.actionlint
        ];

        fish = [
          tools.fish-diagnostics
          tools.fish-indent
        ];

        dockerfile = [ tools.hadolint ];
      };
  };
in
{
  # Neovim launches efm from PATH (`nvim/after/lsp/efm.lua`), so the server
  # itself is the only package that needs to be installed.
  home.packages = [ pkgs.efm-langserver ];

  xdg.configFile."efm-langserver/config.yaml" = {
    source = yamlFormat.generate "efm-langserver-config.yaml" settings;
    force = true;
  };
}
