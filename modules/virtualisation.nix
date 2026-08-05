{ ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    rootless = {
      enable = false;
    };

    daemon.settings = {
      features = {
        buildkit = true;
      };
    };

    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
