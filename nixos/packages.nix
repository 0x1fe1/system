{
  pkgs-unstable,
  pkgs-stable,
}:
(with pkgs-unstable; [
  # * Nix
  home-manager

  # * Terminal
  # kitty
  wezterm
  # nushell
  starship
  # neovim
  vim

  # * Utils
  wget
  # git
  neofetch
  ngrok
  # wl-clipboard
  xclip
  appimage-run
  # wine-wayland
  eza
  bat
  ripgrep
  fzf
  zoxide
  fd
  manix
  # ani-cli
  # mpv
  # aria
  # yt-dlp
  # ffmpeg
  # woeusb
  trashy
  tmux
  unzip
  tree-sitter
  # gnupg
  # pinentry
  # for pix-engine crate
  # SDL2
  # SDL2_image
  # SDL2_mixer
  # SDL2_mixer_2_0
  # SDL2_ttf
  # SDL2_gfx

  # * Apps
  vscodium
  libsForQt5.kate
  vlc
  firefox
  thunderbird
  brave
  obsidian
  qownnotes
  # qbittorrent
  quartus-prime-lite
  discord
  betterdiscordctl
  libreoffice
  unityhub
  # gimp-with-plugins
  # gimpPlugins.gmic
  # gmic-qt

  # * Languages
  # @ JavaScript
  typescript
  nodejs
  yarn
  bun

  # @ Rust
  rustup
  # rust-analyzer

  # @ Nix
  # nil
  alejandra

  # @ Go
  go
  # gopls

  # @ Zig
  zig # zls

  # @ Odin
  odin
  ols

  # @ C/C++
  gcc
  gnumake
  lldb

  # @ Lua
  lua
  stylua
  lua-language-server

  # @ Python
  python3

  # C# and Unity
  neovim-remote
  mono
  wmctrl

  # Other
  (catppuccin-gtk.override {
    accents = ["blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow"];
    size = "compact";
    tweaks = ["rimless"];
    variant = "mocha";
  })
  times-newer-roman

  # maybe fix for tmodloader? -- i gave up, maybe will try later on
  # dotnet-sdk
  # faudio
  # openssl
])
++ (with pkgs-stable; [
  cowsay
])
