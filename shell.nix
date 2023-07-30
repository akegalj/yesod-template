{ pkgs ? import <nixpkgs> {} }:
with pkgs;
pkgs.mkShell {
    buildInputs = [
        (pkgs.haskellPackages.ghcWithPackages (p: with p; [
            cabal-install
            yesod-bin
        ]))
    ];
}