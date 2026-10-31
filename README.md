# Nix

NixOS + home-manager configuration for a Hyprland laptop (Intel + NVIDIA PRIME).

## Apply

- Full system, including home-manager (needs sudo): `nh os switch`
- Home only, no sudo: `nh home switch`

`nh` knows this flake's path (`programs.nh.flake`), so it can be run from anywhere.
Old generations are cleaned weekly by `nh clean` (keeps 5 and anything newer than 7 days).

## Layout

- `hosts/nix/` — host entry point: hardware config and the `features.*` toggles
- `modules/nixos/` — system modules, each gated by `features.<group>.<name>.enable`
- `modules/home/` — home-manager modules, gated by `features.home.*`
- `devshells/` — per-language dev environments

Hyprland's own config lives in `~/.config/hypr` and is deliberately not managed here.

## Devshells

`devshell <name>` (zsh function) enters one in zsh: `cpp`, `go`, `java`, `lean`, `python`, `rust`, `web`.
For a project, put `use flake ~/nix#<name>` in its `.envrc` and run `direnv allow`.

## Formatting

`nix fmt`
