{ pkgs, ... }:

{
  home.sessionVariables = { TERMINAL = "alacritty"; };
  programs.alacritty = {
    enable  = true;
    settings = {
      window = {
        decorations = "None";
        padding = {
          x = 2;
          y = 2;
        };
        dynamic_padding = true;
      };
      font = {
        normal = {
          family = "FantasqueSansM Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "FantasqueSansM Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "FantasqueSansM Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "FantasqueSansM Nerd Font";
          style = "Bold Italic";
        };
        size = 16;
      };
      keyboard.bindings = [
        # windows fix
        # {
        #   key = "Space";
        #   mods = "Control";
        #   chars = "\u0000";
        # }
      ];
      colors.primary = {
        background = "#1E1E2E";
        foreground = "#CDD6F4";
        dim_foreground = "#CDD6F4";
        bright_foreground = "#CDD6F4";
      };
      colors.cursor = {
        text = "#1E1E2E";
        cursor = "#F5E0DC";
      };
      colors.vi_mode_cursor = {
        text = "#1E1E2E";
        cursor = "#B4BEFE";
      };
      colors.search.matches = {
        foreground = "#1E1E2E";
        background = "#A6ADC8";
      };
      colors.search.focused_match = {
        foreground = "#1E1E2E";
        background = "#A6E3A1";
      };
      colors.footer_bar = {
        foreground = "#1E1E2E";
        background = "#A6ADC8";
      };
      colors.hints.start = {
        foreground = "#1E1E2E";
        background = "#F9E2AF";
      };
      colors.hints.end = {
        foreground = "#1E1E2E";
        background = "#A6ADC8";
      };
      colors.selection = {
        text = "#1E1E2E";
        background = "#F5E0DC";
      };
      colors.normal = {
        black = "#45475A";
        red = "#F38BA8";
        green = "#A6E3A1";
        yellow = "#F9E2AF";
        blue = "#89B4FA";
        magenta = "#F5C2E7";
        cyan = "#94E2D5";
        white = "#BAC2DE";
      };
      colors.bright = {
        black = "#585B70";
        red = "#F38BA8";
        green = "#A6E3A1";
        yellow = "#F9E2AF";
        blue = "#89B4FA";
        magenta = "#F5C2E7";
        cyan = "#94E2D5";
        white = "#A6ADC8";
      };
      colors.dim = {
        black = "#45475A";
        red = "#F38BA8";
        green = "#A6E3A1";
        yellow = "#F9E2AF";
        blue = "#89B4FA";
        magenta = "#F5C2E7";
        cyan = "#94E2D5";
        white = "#BAC2DE";
      };
      # there were more colors in the
      # original file from github,
      # but I don't know how to write them in nix
    };
  };
}
