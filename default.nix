# TODO: try using https://zero-to-flakes.com/haskell-flake/
let
  pkgs = import <nixpkgs> {}; # pin the channel to ensure reproducibility!
in
  pkgs.haskell.lib.overrideCabal (pkgs.haskellPackages.developPackage {
    root = ./.;
  }) {
    doHaddock = false;
    doCheck = false;
  }