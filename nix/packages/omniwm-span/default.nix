{
  lib,
  writeShellApplication,
  nushell,
  omniwm,
}:
writeShellApplication {
  name = "omniwm-span";
  runtimeInputs = [
    nushell
    omniwm
  ];
  text = ''
    exec nu ${./omniwm-span.nu} "$@"
  '';
  meta = with lib; {
    description = "Halve or double the focused OmniWM column width";
    homepage = "https://github.com/ryoppippi/dotfiles";
    license = licenses.mit;
    mainProgram = "omniwm-span";
    platforms = platforms.darwin;
  };
}
