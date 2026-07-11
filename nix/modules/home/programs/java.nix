{ pkgs, lib, ... }:
{
  # Installs the default OpenJDK and sets JAVA_HOME in the session environment
  programs.java = {
    enable = true;
    package = pkgs.jdk;
  };

  # macOS GUI apps locate Java via /usr/libexec/java_home, which only scans
  # Library/Java/JavaVirtualMachines and ignores PATH/JAVA_HOME, so the JDK
  # bundle shipped inside the Nix package must be registered there
  home.file."Library/Java/JavaVirtualMachines" = lib.mkIf pkgs.stdenv.isDarwin {
    source = "${pkgs.jdk}/Library/Java/JavaVirtualMachines";
  };
}
