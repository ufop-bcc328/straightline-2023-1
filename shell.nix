{ nixpkgs ? import <nixpkgs> {} } :

let
  inherit (nixpkgs) pkgs;
  ocamlPackages = pkgs.ocamlPackages;
  #ocamlPackages = pkgs.ocamlPackages_latest;
in

pkgs.stdenv.mkDerivation {
  name = "my-ocaml-env";
  buildInputs = [
    ocamlPackages.dune_3
    ocamlPackages.findlib # essential
    ocamlPackages.ocaml
    ocamlPackages.ppxlib
    ocamlPackages.ppx_import
    ocamlPackages.ppx_deriving
    ocamlPackages.printbox
    ocamlPackages.printbox-text
    ocamlPackages.menhir
    ocamlPackages.utop
    ocamlPackages.ocaml-lsp

    pkgs.rlwrap

    (pkgs.emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
      ocamlPackages.dune_3
    ])))

    pkgs.vscode
  ];
}
