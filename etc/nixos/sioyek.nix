{ pkgs, ... }:

{
  programs.sioyek = {
    enable = true;
    bindings = {
      "toggle_custom_color" = "<f8>";
    };
    config = {
      "custom_text_color" = "#ebdbb2";
      "custom_background_color" = "#282828";
      "status_bar_text_color" = "#ebdbb2";
      "ui_background_color" = "#504945";
      "ui_selected_text_color" = "#282828";
      "ui_selected_background_color" = "#ebdbb2";
      "text_highlight_color" = "#504945";
      "visual_mark_color" = "#504945";
      "search_highlight_color" = "#fabd2f";
      "link_highlight_color" = "#fabd2f";
      "synctex_highlight_color" = "#fabd2f";
      "startup_commands" = "toggle_custom_color";
    };
  };
}
