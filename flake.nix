{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        poetry_env = pkgs.poetry2nix.mkPoetryEnv {
          projectDir = ./.;
          preferWheels = true;
          python = pkgs.python310;
        };
        poetry_scripts = pkgs.poetry2nix.mkPoetryApplication ({
          projectDir = ./.;
          preferWheels = true;
          python = pkgs.python310;
        });
        docker = pkgs.dockerTools.buildLayeredImage {
          name = "flake_test";
          tag = "latest";
          config.Cmd = [ "${poetry_scripts}/bin/my_ci_script" ];
          maxLayers = 120;
        };

      in {
        packages = { inherit docker; };
        devShells.default = poetry_env.env.overrideAttrs (old: {
          buildInputs = [ pkgs.vim pkgs.poetry pkgs.hdf5 poetry_scripts ];
        });
      });
}
