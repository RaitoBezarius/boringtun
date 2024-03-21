{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    charon.url = "github:AeneasVerif/charon";
    aeneas.url = "github:AeneasVerif/aeneas";
  };

  outputs = { self, nixpkgs, utils, naersk, charon, aeneas }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        naersk-lib = pkgs.callPackage naersk { };
      in
      {
        defaultPackage = naersk-lib.buildPackage ./.;
        devShell = with pkgs; mkShell {
          packages = [
            charon.packages.${system}.default
            aeneas.packages.${system}.default
          ];

          # Use Charon's rustc.
          inputsFrom = [
            charon.packages.${system}.default
          ];
          # buildInputs = [ cargo rustc rustfmt pre-commit rustPackages.clippy ];
          # RUST_SRC_PATH = rustPlatform.rustLibSrc;
        };
      });
}
