{ pkgs, ... }@inputs: {
  imports = [
    ../../modules/default.nix
  ];

  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Emoji" ];
      monospace = [ "FiraCode Nerd Font" ];
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.file = { };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      defaultWorkspace = "workspace number $ws1";
      # menu = "${pkgs.rofi}/bin/rofi -show drun -show-icons";
      bars = [
        {
          colors = {
            background = "#000000";
            statusline = "#ffffff";
            separator = "#666666";
            focusedWorkspace = {
              background = "#285577";
              border = "#4c7899";
              text = "#ffffff";
            };
            activeWorkspace = {
              background = "#5f676a";
              border = "#333333";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              background = "#222222";
              border = "#333333";
              text = "#888888";
            };
            urgentWorkspace = {
              background = "#900000";
              border = "#2f343a";
              text = "#ffffff";
            };
            bindingMode = {
              background = "#900000";
              border = "#2f343a";
              text = "#ffffff";
            };
          };

          fonts = {
            names = [ "FiraCode" ];
            style = "Regular";
            size = 8.0;
          };

          # command = "${pkgs.i3}/bin/i3bar --transparency";
          statusCommand = "${pkgs.i3status}/bin/i3status";
          mode = "dock";
          hiddenState = "hide";
          position = "bottom";
          workspaceButtons = true;
          workspaceNumbers = true;
          trayOutput = "none";
        }
      ];

      startup = [
        { command = "xrandr --output DP-0 --mode 3440x1440 --rate 144"; notification = false; }
        { command = "xinput set-prop \"12\" \"libinput Accel Profile Enabled\" 0 1 0"; notification = false; }
        { command = "picom --config ~/.config/picom/picom.conf"; always = true; notification = false; }
        { command = "i3-msg 'workspace $ws2; exec brave'"; notification = false; }
      ];

      floating.modifier = "Mod4";

      gaps = { };
      window = { };

      fonts = {
        names = [ "FiraCode" ];
        style = "Regular";
        size = 8.0;
      };

      modes = {
        resize = {
          Escape = "mode default";
          Return = "mode default";
          q = "mode default";
          h = "resize grow width 4 px or 4 ppt";
          j = "resize shrink height 4 px or 4 ppt";
          k = "resize grow height 4 px or 4 ppt";
          l = "resize shrink width 4 px or 4 ppt";
        };
      };

      keybindings = {
        # screenshot
        "Print" = "exec --no-startup-id maim --format=png --select | xclip -selection clipboard -t image/png";
        "Ctrl+Print" = "exec --no-startup-id maim --format=png --select \"/home/$USER/Pictures/screenshot-$(date -u +'%Y.%m.%d-%H:%M:%S').png\"";

        # pipewire controls
        "XF86AudioRaiseVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ #increase sound volume";
        "XF86AudioLowerVolume" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- #decrease sound volume";
        "XF86AudioMute" = "exec --no-startup-id wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle # mute sound";
        # "XF86AudioMute" = "exec --no-startup-id wpctl set-volume @DEFAULT_AUDIO_SINK@ 50% # set sound volume to mid";

        # screen brightness controls
        "XF86MonBrightnessUp" = "exec --no-startup-id xbacklight -inc 5 # increase screen brightness";
        "XF86MonBrightnessDown" = "exec --no-startup-id xbacklight -dec 5 # decrease screen brightness";

        # touchpad controls
        "XF86TouchpadToggle" = "exec --no-startup-id ~/.config/i3/toggletouchpad.sh # toggle touchpad";

        # media player controls
        "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
        "XF86AudioPause" = "exec --no-startup-id playerctl play-pause";
        "XF86AudioNext" = "exec --no-startup-id playerctl next";
        "XF86AudioPrev" = "exec --no-startup-id playerctl previous";

        # workspaces
        "$mod+1" = "workspace number $ws1";
        "$mod+2" = "workspace number $ws2";
        "$mod+3" = "workspace number $ws3";
        "$mod+4" = "workspace number $ws4";
        "$mod+5" = "workspace number $ws5";
        "$mod+6" = "workspace number $ws6";
        "$mod+7" = "workspace number $ws7";
        "$mod+8" = "workspace number $ws8";
        "$mod+9" = "workspace number $ws9";
        "$mod+0" = "workspace number $ws0";
        "$mod+Shift+1" = "move container to workspace number $ws1";
        "$mod+Shift+2" = "move container to workspace number $ws2";
        "$mod+Shift+3" = "move container to workspace number $ws3";
        "$mod+Shift+4" = "move container to workspace number $ws4";
        "$mod+Shift+5" = "move container to workspace number $ws5";
        "$mod+Shift+6" = "move container to workspace number $ws6";
        "$mod+Shift+7" = "move container to workspace number $ws7";
        "$mod+Shift+8" = "move container to workspace number $ws8";
        "$mod+Shift+9" = "move container to workspace number $ws9";
        "$mod+Shift+0" = "move container to workspace number $ws0";

        # navigation
        "$mod+h" = "focus left";
        "$mod+j" = "focus down";
        "$mod+k" = "focus up";
        "$mod+l" = "focus right";
        "$mod+Shift+h" = "move left";
        "$mod+Shift+j" = "move down";
        "$mod+Shift+k" = "move up";
        "$mod+Shift+l" = "move right";

        # i3 reload
        "$mod+Shift+c" = "reload";
        "$mod+Shift+r" = "restart";

        # scratchpad?
        #  $mod+Shift+minus move scratchpad
        #  $mod+minus scratchpad show

        # important apps
        "$mod+Shift+e" = "exec --no-startup-id i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "$mod+d" = "exec --no-startup-id /nix/store/a37r84wxwbrkkf7ii728a7cgmzqj3qxg-dmenu-5.3/bin/dmenu_run";
        "$mod+Return" = "exec --no-startup-id kitty";

        # modes or smth
        "$mod+Shift+w" = "floating toggle";
        "$mod+w" = "focus mode_toggle";
        "$mod+a" = "focus parent";
        "$mod+e" = "layout toggle split";
        "$mod+f" = "fullscreen toggle";
        "$mod+Shift+q" = "kill";
        "$mod+r" = "mode resize";
        "$mod+s" = "layout stacking";
        "$mod+t" = "layout tabbed";
        # "$mod+h" = "split h";
        # "$mod+v" = "split v";
      };
    };
    extraConfig = ''
      set $mod Mod4
      set $ws1 "1: term"
      set $ws2 "2: www"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws0 "10"
    '';
  };

  programs.i3status = {
    enable = true;
    enableDefault = false;
    general = {
      colors = true;
      color_good = "#a6e3a1";
      color_degraded = "#f9e2af";
      color_bad = "#f38ba8";
      interval = 1;
      separator = "";
    };
    modules = {
      "volume master" = {
        settings = {
          format = " <Audio: %volume>";
          format_muted = " <Audio: muted (%volume)>";
        };
        position = 1;
      };
      "ethernet _first_" = {
        settings = {
          format_down = " <Ethernet: down>";
          format_up = " <Ethernet: %ip (%speed)>";
        };
        position = 2;
      };
      "wireless _first_" = {
        settings = {
          format_down = " <W: down>";
          format_up = " <Wireless: (%quality at %essid, %bitrate / %frequency) %ip>";
        };
        position = 3;
      };
      "battery 0" = {
        settings = {
          format = " <%status %percentage %remaining>";
        };
        position = 4;
      };
      "disk /" = {
        settings = {
          format = " <DISK: %free (%avail) / %total>";
        };
        position = 5;
      };
      memory = {
        settings = {
          format = " <RAM: %used / %available>";
          format_degraded = " <MEMORY < %available>";
          threshold_degraded = "1G";
        };
        position = 6;
      };
      "tztime local" = {
        settings = {
          format = " <Time: %Y-%m-%d %H:%M:%S>";
        };
        position = 7;
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "glx";
    settings = {
      blur =
        {
          method = "gaussian";
          size = 10;
          deviation = 5.0;
        };
      blur-background-exclude = [
        "class_g != 'konsole' &&
window_type != 'tooltip' &&
window_type != 'menu' &&
window_type != 'popup_menu' &&
window_type != 'dropdown_menu' &&
window_type != 'splash' &&
window_type != 'combo'"
      ];
    };
  };
}
