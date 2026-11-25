{ pkgs, ... }:
let
  # The T3 Code server enforces this for the desktop app, browsers and the
  # mobile app, and unlike the environment variables a user setting cannot
  # turn any of it back on. It reads the policy only when it starts.
  policy = (pkgs.formats.json { }).generate "t3code-policy.json" {
    schemaVersion = 1;
    organization = "ryoppippi";
    limits = {
      # Product events to ingest.t3.codes and relay traces to Axiom.
      telemetry = false;
      # T3 Connect relays traffic through T3's Cloudflare tunnel in plaintext;
      # remote access goes over Tailscale instead.
      connect = false;
      # Webhook deliveries pass through the same relay.
      webhookTasks = false;
    };
  };
  policyDir = "/Library/Application Support/T3Code";
in
{
  # The policy file must be writable only by administrators.
  system.activationScripts.postActivation.text = ''
    mkdir -p "${policyDir}"
    install -m 0644 -o root -g wheel ${policy} "${policyDir}/policy.json"
  '';
}
