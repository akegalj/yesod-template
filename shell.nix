{ pkgs ? import <nixpkgs> {} }:

with pkgs; mkShell {
  buildInputs = [
    (haskellPackages.ghcWithPackages (p: with p; [
      cabal-install
      yesod-bin
      stack
      postgresql
      postgresql-libpq
    ]))
  ];
}