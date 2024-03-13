#!/run/current-system/sw/bin/bash
set -e
pushd ~/system
sudo nixos-rebuild switch --flake ~/system#default
current=$(nixos-rebuild list-generations --no-build-nix | grep current)
git add . ; git commit -m "default: $current"
popd
