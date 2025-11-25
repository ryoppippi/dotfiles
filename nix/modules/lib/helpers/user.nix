{ config }:
let
  username = config.home.username;
  githubId = "1560508";
  email = "${githubId}+${username}@users.noreply.github.com";
in
{
  inherit username githubId email;
}
