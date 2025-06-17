#!/bin/bash

echo "Testing Nix configuration..."

# Check if nix is installed
if ! command -v nix &> /dev/null; then
    echo "❌ Nix is not installed. Please install Nix first."
    echo "   Run: sh <(curl -L https://nixos.org/nix/install)"
    exit 1
fi

echo "✅ Nix is installed"

# Check if flakes are enabled
if ! nix flake show &> /dev/null; then
    echo "❌ Nix flakes are not enabled."
    echo "   Add to ~/.config/nix/nix.conf:"
    echo "   experimental-features = nix-command flakes"
    exit 1
fi

echo "✅ Nix flakes are enabled"

# Validate the flake
echo "Validating flake.nix..."
if nix flake check 2>&1 | grep -q "error"; then
    echo "❌ Flake validation failed"
    nix flake check
    exit 1
fi

echo "✅ Flake is valid"

# Build the home-manager configuration
echo "Building home-manager configuration (dry run)..."
if ! nix build .#homeConfigurations.ryoppippi.activationPackage --dry-run 2>&1; then
    echo "❌ Home Manager configuration build failed"
    exit 1
fi

echo "✅ Home Manager configuration is valid"

echo ""
echo "All checks passed! You can now apply the configuration with:"
echo "  nix run home-manager/master -- switch --flake ."