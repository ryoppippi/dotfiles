{ config }:
let
  inherit (config.home) username;
  githubId = "75629350";
  email = "${githubId}+${username}@users.noreply.github.com";
in
{
  inherit username githubId email;
}
