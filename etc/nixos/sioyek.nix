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
      "ui_text_color" = "#ebdbb2";
      "ui_background_color" = "#504945";
      "ui_selected_text_color" = "#282828";
      "ui_selected_background_color" = "#ebdbb2";
      "visual_mark_color" = "#fabd2f";
      "text_highlight_color" = "#fabd2f";
      "search_highlight_color" = "#fabd2f";
      "link_highlight_color" = "#fabd2f";
      "synctex_highlight_color" = "#fabd2f";
      "startup_commands" = "toggle_custom_color";
    };
  };
}
