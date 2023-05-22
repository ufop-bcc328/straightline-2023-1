(* Driver *)

let lexbuf =
  match Sys.argv with
  | [| _; input |] ->
     let lexbuf = Lexing.from_channel (open_in input) in
     Lexing.set_filename lexbuf input;
     lexbuf
  | _ ->
     Lexing.from_channel stdin
  
let ast = Parser.program Lexer.token lexbuf

let () = print_int (Maxargs.maxargs ast)