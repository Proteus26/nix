{ pkgs, ... }:

{
  users.users."proteus" = {
    isNormalUser = true;
    description = "proteus";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };
}
