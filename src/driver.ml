(* Driver *)

(* Lexical buffer where input source is available *)
let lexbuf =
  match Sys.argv with
  | [| _; input |] ->
     let lexbuf = Lexing.from_channel (open_in input) in
     Lexing.set_filename lexbuf input;
     lexbuf
  | _ ->
     Lexing.from_channel stdin

(* Construct the abstract syntax tree *)
let ast = Parser.program Lexer.token lexbuf

(* Print the abstract syntax tree *)
let () = print_endline (Absyn.show_stm ast)

(* Print the abstract syntax tree in a more fancy way *)
let tree = Absyntree.tree_of_stm ast
let box = PrintBox_text.to_string tree
let () = print_endline box

(* Calculate and print maxargs of the program *)
let () = Printf.printf "maxargs: %i\n" (Maxargs.maxargs ast)
