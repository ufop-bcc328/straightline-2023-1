(lang dune 3.2)

(using menhir 2.1)

(generate_opam_files true)

(package
 (name straightline)
 (depends
   ocaml
   dune
   menhir
   ppx_deriving
   (ppx_expect :with-test)
   ppx_import
   printbox
   printbox-text)
 (allow_empty))
 
