{ pkgs }: with pkgs; [
  (writeShellScriptBin "custom-system-edit" ''
    set -e
    pushd ~/system
    nix run ~/neovim .
    popd
  '')

  # to rebuild boot use:
  # $ NIXOS_INSTALL_BOOTLOADER=1 custom-system-rebuild
  (writeShellScriptBin "custom-system-rebuild" ''
    set -e
    pushd ~/system
    nh os switch
    current=$(nixos-rebuild list-generations --no-build-nix | grep current)
    git add . ; git commit --allow-empty -m "$(hostname)@system: $current"
    popd
  '')

  (writeShellScriptBin "custom-home-rebuild" ''
    set -e
    pushd ~/system
    nh home switch --configuration=$(hostname)
    current=$(nixos-rebuild list-generations --no-build-nix | grep current)
    git add . ; git commit --allow-empty -m "$(hostname)@home: $current"
    popd
  '')
]
