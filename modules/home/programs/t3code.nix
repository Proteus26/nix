{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.home.programs.t3code;

  launcher = "${config.home.profileDirectory}/bin/t3code-desktop";

  # t3code:// handler uses Exec=$APPIMAGE, else the bare Electron binary.
  t3code = pkgs.symlinkJoin {
    name = "t3code-${pkgs.t3code.version}";
    paths = [ pkgs.t3code ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      wrapProgram $out/bin/t3code-desktop \
        --set APPIMAGE ${launcher} \
        --set-default T3CODE_DISABLE_AUTO_UPDATE 1 \
        --prefix PATH : ${lib.makeBinPath [ pkgs.lsof ]}
    '';
  };
in
{
  options.features.home.programs.t3code.enable = lib.mkEnableOption "T3 Code";

  config = lib.mkIf cfg.enable {
    home.packages = [ t3code ];

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };
}
