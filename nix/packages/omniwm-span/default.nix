{
  lib,
  writeScriptBin,
  omniwm,
}:
(writeScriptBin "omniwm-span" (
  builtins.replaceStrings [ "@omniwmctl@" ] [ (lib.getExe' omniwm "omniwmctl") ] (
    builtins.readFile ./omniwm-span.sh
  )
)).overrideAttrs
  {
    meta = with lib; {
      description = "Halve or double the focused OmniWM column width";
      homepage = "https://github.com/ryoppippi/dotfiles";
      license = licenses.mit;
      mainProgram = "omniwm-span";
      platforms = platforms.darwin;
    };
  }
