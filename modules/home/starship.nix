# modules/home/starship.nix
# Starship prompt configuration
{ config, lib, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      
      character = {
        success_symbol = "[➜](bold green)";
      };

      line_break = {
        disabled = true;
      };

      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
        style = "bold green";
      };

      git_status = {
        format = '[\($all_status$ahead_behind\)]($style) '';
        style = "bold green";
        conflicted = "🏳";
        ahead = "⬆:${count}";
        behind = "⬇:${count}";
        diverged = "⬆:${ahead_count}-⬇:${behind_count}";
        untracked = "🤷‍";
        stashed = "📦";
        modified = "📝";
        staged = "[++\\($count\\)](green)";
        renamed = "👅";
        deleted = "🗑";
      };

      directory = {
        truncation_length = 1;
        truncation_symbol = "../";
        home_symbol = "~";
        read_only_style = "197";
        read_only = "🔒";
        style = "bold cyan";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      aws = {
        format = "on [$symbol($profile )(\\($region\\) )]($style)";
        style = "bold blue";
        symbol = "🅰 ";
      };

      username = {
        style_user = "white bold";
        style_root = "black bold";
        format = "user: [$user]($style) ";
        disabled = false;
        show_always = false;
      };

      hostname = {
        ssh_only = true;
        format = "[$ssh_symbol](bold blue) on [$hostname](bold red) ";
        trim_at = ".companyname.com";
        disabled = false;
      };
    };
  };
}
