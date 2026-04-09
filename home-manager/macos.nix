# ~/nix-config/macos.nix
{ pkgs, aiToolsPkgs, ... }:

{
  home.username = "godinus";
  home.homeDirectory = "/Users/godinus";

  # Packages only for macOS
  home.packages = [
    # pkgs.bash
    pkgs.cargo
    # pkgs.gemini-cli
    # pkgs.go
    pkgs.ffmpeg
    # pkgs.neofetch
    # pkgs.tig
  ];
}
