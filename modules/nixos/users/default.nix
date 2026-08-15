{ config, lib, pkgs, hostspec, ... }:

{
  users.users.${hostspec.username} = {
    isNormalUser = true;
    description = hostspec.username;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "audio"
    ];
    shell = pkgs.zsh;
  };
}
