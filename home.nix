{ config, pkgs, ... }:

let
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    systemctl --user start plasma-polkit-agent
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww-daemon &
    ${pkgs.mako}/bin/mako &

    sleep 1

    ${pkgs.waypaper}/bin/waypaper --random --folder /home/paulov/.config/wallpapers/ --backend swww
  '';
in {
  home.username = "paulov";
  home.homeDirectory = "/home/paulov";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    fastfetch
    cava

    zip
    xz
    unzip
    p7zip

    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    libwebp
    
    zathura # pdf vim-like reader

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Paulo Viteri";
    userEmail = "undevoted@proton.me";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
    '';
  };

  programs.zsh = {
    enable = true;
  };

  # Doing that homemanager do things with hyprland
  wayland.windowManager.hyprland = {
    enable = true;

    # I took my old config of hyprland, that is on my dotfiles repo
    settings = {
      monitor = ",preferred,auto,auto";

      exec-once = ''${startupScript}/bin/start'';

      "$terminal" = "kitty";
      "$browser" = "firefox";
      "$fileManager" = "nnn";
      "$screenshot" = "hyprshot";
      "$menu" = "rofi";
      "$notifyLib" = "dunst";

      env = [
        "XCURSOR_SIZE, 24"
        "HYPRCURSOR_THEME, phinger-cursors-light"
        "HYPRCURSOR_SIZE, 24"
      ];

      general = {
      gaps_in = "5";
        gaps_out = "20";

        border_size = "2";

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        resize_on_border = "false";

        allow_tearing = "false";

        layout = "dwindle";
      };

      decoration = {
        rounding = "8";

        active_opacity = "1.0";
        inactive_opacity = "1.0";

        # drop_shadow = "true";
        # shadow_range = "4";
        # shadow_render_power = "3";

        # "col.shadow" = "rgba(1a1a1aee)";

        blur = {
          enabled = "true";
          size = "3";
          passes = "-1";

          vibrancy = "0.1696";
        };
      };

      animations = {
        enabled = "true";

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      # dwindle = {
        # pseudotitle = "true";
        # preserve_split = "true";
      # };

      master = {
        new_status = "master";
      };

      misc = {
        force_default_wallpaper = "0";
        disable_hyprland_logo = "true";
      };

      gestures = {
        workspace_swipe = "false";
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };

      "$mainMod" = "SUPER";

      bind = [
        "CTRL SHIFT, P, exec, $screenshot -m region"
        "$mainMod, SPACE, exec, $menu -show drun"
        "$mainMod, K, exec, $terminal"
        "$mainMod, F, exec, $browser"

        "$mainMod, Q, killactive"
        "$mainMod SHIFT, M, exit"
        "$mainMod, V, togglefloating"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = "suppressevent maximize, class:.*";
    };
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 11;
    };

    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      cursor_sheap = "beam";
      enable_audio_bell = "no";
      window_padding_width = "22";
      hide_window_decorations = "yes";

      background_opacity = "0.8";

      tab_bar_min_tabs = "1";
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''";

      background = "#181818"; # Eerie Black

      cursor = "#f5e0dc"; # Pale Pink
      cursor_text_color = "#1e1e2e"; # Dark Gunmetal

      url_color = "#f5e0dc"; # Pale Pink

      wayland_titlebar_color = "system";

      active_tab_foreground = "#11111b"; # Chinese Black
      active_tab_background = "#cba6f7"; # Pale Violet
      inactive_tab_foreground = "#cdd6f4"; # Lavender Blue
      inactive_tab_background = "#181825"; # Eerie Black
      tab_bar_background = "#1f1f1f"; # Eerie Black

      mark1_foreground = "#1e1e2e"; # Dark Gunmetal
      mark1_background = "#b4befe"; # Vodka
      mark2_foreground = "#1e1e2e"; # Dark Gunmetal
      mark2_background = "#cba6f7"; # Pale Violet
      mark3_foreground = "#1e1e2e"; # Dark Gunmetal
      mark3_background = "#74c7ec"; # Maya Blue
    };
  };

  services.mako = {
    enable = true;
    anchor = "top-right";
    borderRadius = 7;
    backgroundColor = "#1C1E26b1";
    borderColor = "#01708a";
    margin = "15";
    defaultTimeout = 5000;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
