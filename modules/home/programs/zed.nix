{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.features.home.programs.zed;
  bin = pkg: name: { binary.path = lib.getExe' pkg name; };
in
{
  options.features.home.programs.zed.enable = lib.mkEnableOption "Zed editor";

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "java"
        "kotlin"
        "lua"
        "toml"
        "make"
        "dockerfile"
      ];

      userSettings = {
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        format_on_save = "on";

        lsp = {
          nil = bin pkgs.nil "nil";
          clangd = lib.recursiveUpdate (bin pkgs.clang-tools "clangd") {
            binary.arguments = [
              "--background-index"
              "--clang-tidy"
              "--query-driver=/nix/store/*-gcc-*/bin/*,/nix/store/*-clang-*/bin/*,/run/current-system/sw/bin/*,/etc/profiles/per-user/*/bin/*"
            ];
          };
          gopls = bin pkgs.gopls "gopls";
          pyright = lib.recursiveUpdate (bin pkgs.pyright "pyright-langserver") {
            binary.arguments = [ "--stdio" ];
          };
          ruff = lib.recursiveUpdate (bin pkgs.ruff "ruff") { binary.arguments = [ "server" ]; };
          typescript-language-server =
            lib.recursiveUpdate (bin pkgs.typescript-language-server "typescript-language-server")
              {
                binary.arguments = [ "--stdio" ];
              };
          lua-language-server = bin pkgs.lua-language-server "lua-language-server";
          jdtls = bin pkgs.jdt-language-server "jdtls";
          kotlin-language-server = bin pkgs.kotlin-language-server "kotlin-language-server";
          rust-analyzer.binary.path_lookup = true;
        };

        languages = {
          Nix = {
            language_servers = [
              "nil"
              "!nixd"
            ];
            formatter.external.command = lib.getExe pkgs.nixfmt;
          };
          Python.language_servers = [
            "pyright"
            "ruff"
            "!basedpyright"
          ];
          TypeScript.language_servers = [
            "typescript-language-server"
            "!vtsls"
            "..."
          ];
          TSX.language_servers = [
            "typescript-language-server"
            "!vtsls"
            "..."
          ];
          JavaScript.language_servers = [
            "typescript-language-server"
            "!vtsls"
            "..."
          ];
          Lua.formatter.external = {
            command = lib.getExe pkgs.stylua;
            arguments = [ "-" ];
          };
          Java.formatter.external = {
            command = lib.getExe pkgs.google-java-format;
            arguments = [ "-" ];
          };
          Kotlin.formatter.external = {
            command = lib.getExe pkgs.ktlint;
            arguments = [
              "--format"
              "--stdin"
              "--log-level=none"
            ];
          };
          "Shell Script".formatter.external = {
            command = lib.getExe pkgs.shfmt;
            arguments = [ "-" ];
          };
        };
      };
    };
  };
}
