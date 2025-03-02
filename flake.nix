{
  description = "LaTeX Document Demo";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.systems.url = "github:nix-systems/default";
  inputs.flake-utils = {
    url = "github:numtide/flake-utils";
    inputs.systems.follows = "systems";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-minimal latex-bin latexmk biblatex infwarerr ltxcmds kvsetkeys l3packages tools acronym bigfoot xstring xcolor hyperref cleveref booktabs epstopdf-pkg;
        };
        dependencies = [
          tex
          pkgs.biber
          pkgs.gnumake
        ];
        compile = pkgs.writeShellApplication {
          name = "compile";
          runtimeInputs = [ pkgs.coreutils ] ++ dependencies;
          text = "make";
        };
      in
      {
        apps.default = { type = "app"; program = "${compile}/bin/compile"; };
      }
    );
}
