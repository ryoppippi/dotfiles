{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Cursor CLI configuration
  xdg.configFile."cursor/cli-config.json".text = builtins.toJSON {
    permissions = {
      allow = [
        "Shell(ls)"
        "Shell(uv)"
        "Shell(git status)"
        "Shell(git diff)"
      ];
      deny = [ ];
    };
    version = 1;
    editor = {
      vimMode = false;
    };
    model = {
      modelId = "composer-1";
      displayModelId = "composer-1";
      displayName = "Composer 1";
      displayNameShort = "Composer 1";
      aliases = [ ];
    };
    hasChangedDefaultModel = true;
    privacyCache = {
      ghostMode = false;
      privacyMode = 3;
      updatedAt = 1763647036545;
    };
    network = {
      useHttp1ForAgent = false;
    };
  };
}
