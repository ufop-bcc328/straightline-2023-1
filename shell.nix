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
    ocamlPackages.utop
    ocamlPackages.ocaml-lsp
    ocamlPackages.ppxlib
    ocamlPackages.ppx_deriving
    ocamlPackages.ppx_expect
    ocamlPackages.ppx_import
    ocamlPackages.printbox
    ocamlPackages.printbox-text
    ocamlPackages.menhir

    pkgs.rlwrap

    (pkgs.emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
      ocamlPackages.dune_3
    ])))

    pkgs.vscode
  ];
}
