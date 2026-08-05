{ ... }:

{
  services.openssh.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=Y
  '';

  services.blueman.enable = true;

  services.printing.enable = true;

  security.rtkit.enable = true;

  services.udisks2.enable = true;

  services.gvfs.enable = true;
}
