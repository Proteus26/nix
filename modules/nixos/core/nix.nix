{ hostspec, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # nh: `nh os switch` / `nh home switch` without passing the flake path,
  # plus generation cleanup (replaces nix.gc).
  programs.nh = {
    enable = true;
    flake = "/home/${hostspec.username}/nix";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
