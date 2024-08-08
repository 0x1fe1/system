{ pkgs, lib, ... }@inputs: {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      defaultWorkspace = "workspace number $ws1";
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

          # command = "i3bar --transparency";
          statusCommand = "i3blocks -c ~/.config/i3blocks/default";
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
        { command = "i3-msg 'workspace $ws2; exec firefox'"; notification = false; }
        { command = "playerctld daemon"; notification = false; }
        { command = "cp $HOME/wallpapers/$(ls ~/wallpapers/ | shuf -n1) ~/.background-image"; notification = false; }
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
        # "$mod+a" = "workspace number $ws1";
        # "$mod+s" = "workspace number $ws2";
        # "$mod+d" = "workspace number $ws3";
        # "$mod+f" = "workspace number $ws4";
        # "$mod+Shift+a" = "move container to workspace number $ws1";
        # "$mod+Shift+s" = "move container to workspace number $ws2";
        # "$mod+Shift+d" = "move container to workspace number $ws3";
        # "$mod+Shift+f" = "move container to workspace number $ws4";

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

        "$mod+mod2+KP_1" = "workspace number $ws1";
        "$mod+mod2+KP_2" = "workspace number $ws2";
        "$mod+mod2+KP_3" = "workspace number $ws3";
        "$mod+mod2+KP_4" = "workspace number $ws4";
        "$mod+mod2+KP_5" = "workspace number $ws5";
        "$mod+mod2+KP_6" = "workspace number $ws6";
        "$mod+mod2+KP_7" = "workspace number $ws7";
        "$mod+mod2+KP_8" = "workspace number $ws8";
        "$mod+mod2+KP_9" = "workspace number $ws9";
        "$mod+mod2+KP_0" = "workspace number $ws0";
        "$mod+Shift+mod2+KP_1" = "move container to workspace number $ws1";
        "$mod+Shift+mod2+KP_2" = "move container to workspace number $ws2";
        "$mod+Shift+mod2+KP_3" = "move container to workspace number $ws3";
        "$mod+Shift+mod2+KP_4" = "move container to workspace number $ws4";
        "$mod+Shift+mod2+KP_5" = "move container to workspace number $ws5";
        "$mod+Shift+mod2+KP_6" = "move container to workspace number $ws6";
        "$mod+Shift+mod2+KP_7" = "move container to workspace number $ws7";
        "$mod+Shift+mod2+KP_8" = "move container to workspace number $ws8";
        "$mod+Shift+mod2+KP_9" = "move container to workspace number $ws9";
        "$mod+Shift+mod2+KP_0" = "move container to workspace number $ws0";

        "$mod+KP_End" = "workspace number $ws1";
        "$mod+KP_Down" = "workspace number $ws2";
        "$mod+KP_Next" = "workspace number $ws3";
        "$mod+KP_Left" = "workspace number $ws4";
        "$mod+KP_Begin" = "workspace number $ws5";
        "$mod+KP_Right" = "workspace number $ws6";
        "$mod+KP_Home" = "workspace number $ws7";
        "$mod+KP_Up" = "workspace number $ws8";
        "$mod+KP_Prior" = "workspace number $ws9";
        "$mod+KP_Insert" = "workspace number $ws0";
        "$mod+Shift+KP_End" = "move container to workspace number $ws1";
        "$mod+Shift+KP_Down" = "move container to workspace number $ws2";
        "$mod+Shift+KP_Next" = "move container to workspace number $ws3";
        "$mod+Shift+KP_Left" = "move container to workspace number $ws4";
        "$mod+Shift+KP_Begin" = "move container to workspace number $ws5";
        "$mod+Shift+KP_Right" = "move container to workspace number $ws6";
        "$mod+Shift+KP_Home" = "move container to workspace number $ws7";
        "$mod+Shift+KP_Up" = "move container to workspace number $ws8";
        "$mod+Shift+KP_Prior" = "move container to workspace number $ws9";
        "$mod+Shift+KP_Insert" = "move container to workspace number $ws0";

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
        "$mod+d" = "exec --no-startup-id dmenu_run";
        "$mod+Return" = "exec --no-startup-id kitty";

        # modes or smth
        "$mod+Shift+w" = "floating toggle";
        "$mod+e" = "layout toggle split";
        "$mod+f" = "fullscreen toggle";
        "$mod+Shift+q" = "kill";
        "$mod+r" = "mode resize";
        "$mod+s" = "layout stacking";
        "$mod+t" = "layout tabbed";

        "$mod+n" = "split h";
        "$mod+m" = "split v";
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

  programs.i3blocks = {
    enable = true;
    bars.default = {
      media = {
        command = "~/.config/i3blocks/media.sh";
        interval = "repeat";
        min_width = 150;
        align = "center";
      };

      audio = lib.hm.dag.entryAfter [ "media" ] {
        command = "wpctl get-volume @DEFAULT_AUDIO_SINK@";
        interval = "repeat";
        min_width = 150;
        align = "center";
      };

      language = lib.hm.dag.entryAfter [ "audio" ] {
        command = "~/.config/i3blocks/lang.sh";
        interval = "repeat";
        min_width = 100;
        align = "center";
      };

      capslock = lib.hm.dag.entryAfter [ "language" ] {
        command = "~/.config/i3blocks/capslock.sh";
        interval = "repeat";
        min_width = 150;
        align = "center";
      };

      numlock = lib.hm.dag.entryAfter [ "capslock" ] {
        command = "~/.config/i3blocks/numlock.sh";
        interval = "repeat";
        min_width = 150;
        align = "center";
      };

      weather = lib.hm.dag.entryAfter [ "numlock" ] {
        command = "curl -Ss 'https://wttr.in?0&T&Q' | cut -c 16- | head -2 | xargs echo";
        interval = 3600;
        color = "#89b4fa";
        min_width = 250;
        align = "center";
      };

      time = lib.hm.dag.entryAfter [ "weather" ] {
        command = "date +'%Y/%m/%d  %H:%M:%S'";
        interval = 1;
        min_width = 250;
        align = "center";
      };
    };
  };

  services.picom = {
    enable = true;
    backend = "glx";
    settings = {
      blur = {
        method = "gaussian";
        size = 10;
        deviation = 5.0;
      };
      blur-background-exclude = [
        "class_g != 'kitty'"
      ];
    };
  };
}
