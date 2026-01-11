#!/usr/bin/env bash
set -euo pipefail

# Script to update npm package versions and hashes
# Usage: ./update.sh

cd "$(dirname "$0")"

DEFAULT_NIX="default.nix"

# Regenerate package-lock.json for a given npm package
regenerate_package_lock() {
  local npm_name="$1"
  local lock_file="$2"

  echo "  Regenerating package-lock.json"
  local tmp_dir
  tmp_dir=$(mktemp -d)
  trap 'rm -rf "$tmp_dir"' RETURN ERR

  pushd "$tmp_dir" >/dev/null
  npm pack "$npm_name" --pack-destination . 2>/dev/null
  tar -xzf ./*.tgz --strip-components=1
  npm install --package-lock-only --ignore-scripts 2>/dev/null || true
  popd >/dev/null

  cp "$tmp_dir/package-lock.json" "$lock_file"
}

# Extract package list from default.nix (pname and npmName pairs)
get_npm_packages() {
  # Find mkNpmPackage blocks and extract pname/npmName
  perl -0777 -ne '
        while (/mkNpmPackage\s*\{(.*?)\};/gs) {
            my $block = $1;
            my ($pname) = $block =~ /pname\s*=\s*"([^"]+)"/;
            my ($npm_name) = $block =~ /npmName\s*=\s*"([^"]+)"/;
            $npm_name //= $pname;
            print "$pname\t$npm_name\n";
        }
    ' "$DEFAULT_NIX"
}

update_npm_package() {
  local pname="$1"
  local npm_name="$2"
  local current_version latest_version new_hash new_sri new_deps_hash url

  echo "Checking $npm_name..."

  # Get current version from default.nix
  current_version=$(grep -A5 "pname = \"$pname\"" "$DEFAULT_NIX" | perl -ne 'print $1 if /version = "([^"]+)/' | head -1)

  if [[ -z $current_version ]]; then
    echo "  Could not find current version for $pname"
    return
  fi

  # Get latest version from npm
  latest_version=$(npm view "$npm_name" version 2>/dev/null || echo "")

  if [[ -z $latest_version ]]; then
    echo "  Could not fetch latest version for $npm_name"
    return
  fi

  if [[ $current_version == "$latest_version" ]]; then
    echo "  Already at latest version: $current_version"
    return
  fi

  echo "  Updating from $current_version to $latest_version"

  # Update version in default.nix (for this specific package block)
  perl -pi -e "BEGIN{\$found=0} if(/pname = \"$pname\"/){\$found=1} if(\$found && /version = \"$current_version\"/){\$_=~s/$current_version/$latest_version/; \$found=0}" "$DEFAULT_NIX"

  # Get new source hash
  local url="https://registry.npmjs.org/${npm_name}/-/${pname}-${latest_version}.tgz"
  echo "  Fetching new hash for $url"
  new_hash=$(nix-prefetch-url --unpack "$url" 2>/dev/null | tail -1)
  new_sri=$(nix hash convert --hash-algo sha256 --to sri "$new_hash")

  # Update source hash (find the hash after version update)
  perl -0777 -pi -e "s/(pname = \"$pname\".*?version = \"$latest_version\".*?hash = \")sha256-[^\"]+/\${1}$new_sri/s" "$DEFAULT_NIX"

  # Update package-lock.json if it exists
  local lock_file="$pname/package-lock.json"
  if [[ -f $lock_file ]]; then
    regenerate_package_lock "$npm_name" "$lock_file"
  fi

  # Calculate new npmDepsHash
  echo "  Calculating new npmDepsHash (this may take a moment)..."
  new_deps_hash=$(nix build --impure --expr "((import <nixpkgs> {}).callPackage ./. {}).\"$npm_name\"" 2>&1 | perl -ne 'print $1 if /got:\s+(\S+)/' || echo "")

  if [[ -n $new_deps_hash ]]; then
    perl -0777 -pi -e "s/(pname = \"$pname\".*?npmDepsHash = \")sha256-[^\"]+/\${1}$new_deps_hash/s" "$DEFAULT_NIX"
  fi

  echo "  Updated $npm_name to $latest_version"
}

# Update individual npm packages (auto-detected from default.nix)
echo "Updating npm packages..."
while IFS=$'\t' read -r pname npm_name; do
  update_npm_package "$pname" "$npm_name"
done < <(get_npm_packages)

echo ""
echo "Update complete!"
