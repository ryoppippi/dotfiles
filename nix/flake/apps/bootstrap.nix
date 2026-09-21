{ constants, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      writeNu,
      ...
    }:
    let
      inherit (constants) username darwinHomedir linuxHomedir;
      inherit (pkgs.stdenv.hostPlatform) isDarwin;

      ghq = lib.getExe pkgs.ghq;
      gitBin = "${lib.getBin pkgs.git}/bin";

      repoSlug = "github.com/ryoppippi/dotfiles";

      # nix/modules/home/dotfiles.nix symlinks the live fish, zsh and nvim
      # configuration out of the working tree, so the checkout has to sit at the
      # path the host passes as `dotfilesDir`, which is the ghq root this
      # configuration goes on to set in programs/git.
      homedir = if isDarwin then darwinHomedir else linuxHomedir;
      ghqRoot = "${homedir}/ghq";
      checkout = "${ghqRoot}/${repoSlug}";

      # A top-level definition rather than a block spliced into `main`: Nix
      # strips the indentation of an interpolated literal, so anything nested
      # inside one comes back out flush against the left margin.
      platformSteps =
        if isDarwin then
          ''
            # The two things a fresh Mac needs that the switch cannot arrange
            # for itself. Neither exists on Linux, where this is a no-op.
            def platform-steps [] {
                # masApps installs through the App Store, and an entry fails
                # with little to say for itself when nobody is signed in.
                if (is-terminal --stdin) {
                    print ""
                    print "Sign in to the Mac App Store, or every masApps entry will fail."
                    let answer = (input "Open the App Store now? [y/N] ")
                    if ($answer | str downcase | str starts-with "y") {
                        ^open -a "App Store"
                        input "Press Enter once you are signed in."
                    }
                }

                # Homebrew and some build inputs stop at an unaccepted licence.
                # It needs full Xcode, so a machine carrying only the Command
                # Line Tools skips the step rather than failing the bootstrap.
                if (which xcodebuild | is-not-empty) {
                    try {
                        ^sudo xcodebuild -license accept
                    } catch {
                        print "Could not accept the Xcode licence; accept it by hand if a build asks for it."
                    }
                }
            }
          ''
        else
          ''
            # Linux needs nothing before the switch: Home Manager runs as the
            # user, with no system-level step and no app store to sign in to.
            def platform-steps [] { }
          '';
    in
    {
      apps.default = {
        type = "app";
        program = toString (
          writeNu "bootstrap" ''
            # Set this machine up from nothing: fetch the checkout the
            # configuration expects, then hand over to `nix run .#switch`.
            #
            # Installing Nix stays manual, because this script only runs once
            # Nix is there. Nothing after it does.

            ${platformSteps}
            def main [] {
                let user = (^id -un | str trim)
                if $user != "${username}" {
                    error make {msg: $"This configuration builds for `${username}`, but you are `($user)`. Fork it and change `username` in nix/flake/constants.nix."}
                }

                if ("${checkout}" | path exists) {
                    print "Using the checkout already at ${checkout}"
                } else {
                    print "Fetching ${repoSlug} into ${ghqRoot}"
                    # GHQ_ROOT is pinned rather than left to ghq's own default,
                    # because the modules symlink out of ${checkout} by absolute
                    # path and a root configured earlier would put it elsewhere.
                    # ghq shells out to git, which is not on PATH yet.
                    with-env {GHQ_ROOT: "${ghqRoot}", PATH: ($env.PATH | prepend "${gitBin}")} {
                        ^${ghq} get ${repoSlug}
                    }
                    if not ("${checkout}" | path exists) {
                        error make {msg: "ghq did not leave the repository at ${checkout}"}
                    }
                }

                platform-steps

                # Hand over to the checkout's own switch, so there is a single
                # definition of what applying this configuration means. It
                # re-evaluates the flake from the clone, which is what leaves
                # the symlinks pointing at a tree that can be edited afterwards.
                cd "${checkout}"
                ^nix run --accept-flake-config ".#switch"
            }
          ''
        );
      };
    };
}
