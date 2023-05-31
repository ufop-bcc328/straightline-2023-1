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
   ppx_expect
   ppx_import
   printbox
   printbox_text)
 (allow_empty))
 
