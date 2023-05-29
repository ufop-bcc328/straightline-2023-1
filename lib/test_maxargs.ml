(* Test parser and maxargs *)

module L = Lexing

let check str =
  let lexbuf = L.from_string str in
  try
    let ast = Parser.program Lexer.token lexbuf in
    let tree = Absyntree.tree_of_stm ast in
    let box = PrintBox_text.to_string tree in
    Format.printf "%s\n\n%!" box;
    Format.printf "maxargs: %i\n%!" (Maxargs.maxargs ast);
  with
  | Parser.Error ->
     Format.printf "%a error: syntax\n%!" Location.pp_position lexbuf.L.lex_curr_p
  | Error.Error (loc, msg) ->
     Format.printf "%a error: %s%!" Location.pp_location loc msg

let%expect_test "test programs" =
  check "x := 10";
  [%expect{|
    AssignStm
    ├─x
    └─NumExp 10

    maxargs: 0 |}];

  check "print(10, 20+3, 4*18-1)";
  [%expect{|
    PrintStm
    ├─NumExp 10
    ├─OpExp +
    │ ├─NumExp 20
    │ └─NumExp 3
    └─OpExp -
      ├─OpExp *
      │ ├─NumExp 4
      │ └─NumExp 18
      └─NumExp 1

    maxargs: 3 |}];

  check "x := 2; print(x); print(x*x-1, x+2, x/2); print(x)";
  [%expect{|
    CompoundStm
    ├─AssignStm
    │ ├─x
    │ └─NumExp 2
    └─CompoundStm
      ├─PrintStm
      │ └─IdExp x
      └─CompoundStm
        ├─PrintStm
        │ ├─OpExp -
        │ │ ├─OpExp *
        │ │ │ ├─IdExp x
        │ │ │ └─IdExp x
        │ │ └─NumExp 1
        │ ├─OpExp +
        │ │ ├─IdExp x
        │ │ └─NumExp 2
        │ └─OpExp /
        │   ├─IdExp x
        │   └─NumExp 2
        └─PrintStm
          └─IdExp x

    maxargs: 3 |}];

  check {|
         x := 2;
         y := (print(x, x+1, x-1, x*1, x/1), x*x);
         print(x)
         |};
  [%expect{|
    CompoundStm
    ├─AssignStm
    │ ├─x
    │ └─NumExp 2
    └─CompoundStm
      ├─AssignStm
      │ ├─y
      │ └─EseqExp
      │   ├─PrintStm
      │   │ ├─IdExp x
      │   │ ├─OpExp +
      │   │ │ ├─IdExp x
      │   │ │ └─NumExp 1
      │   │ ├─OpExp -
      │   │ │ ├─IdExp x
      │   │ │ └─NumExp 1
      │   │ ├─OpExp *
      │   │ │ ├─IdExp x
      │   │ │ └─NumExp 1
      │   │ └─OpExp /
      │   │   ├─IdExp x
      │   │   └─NumExp 1
      │   └─OpExp *
      │     ├─IdExp x
      │     └─IdExp x
      └─PrintStm
        └─IdExp x

    maxargs: 5 |}];
