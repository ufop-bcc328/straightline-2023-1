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

  check {|
    x := 2;
    if 10*x - 1 then
      y := x * 3;
      print(x, y)
    else
      print(x + 1)
    end
    |};
  [%expect{|
    CompoundStm
    ├─AssignStm
    │ ├─x
    │ └─NumExp 2
    └─IfStm
      ├─OpExp -
      │ ├─OpExp *
      │ │ ├─NumExp 10
      │ │ └─IdExp x
      │ └─NumExp 1
      ├─CompoundStm
      │ ├─AssignStm
      │ │ ├─y
      │ │ └─OpExp *
      │ │   ├─IdExp x
      │ │   └─NumExp 3
      │ └─PrintStm
      │   ├─IdExp x
      │   └─IdExp y
      └─PrintStm
        └─OpExp +
          ├─IdExp x
          └─NumExp 1

    maxargs: 2 |}];

  check {|
    x := 20;
    while x do
      y := x*x - 5*x + 1;
      print(x, x+y, x-y);
      x := x - 1
    end;
    print(x)
    |};
[%expect{|
  CompoundStm
  ├─AssignStm
  │ ├─x
  │ └─NumExp 20
  └─CompoundStm
    ├─WhileStm
    │ ├─IdExp x
    │ └─CompoundStm
    │   ├─AssignStm
    │   │ ├─y
    │   │ └─OpExp +
    │   │   ├─OpExp -
    │   │   │ ├─OpExp *
    │   │   │ │ ├─IdExp x
    │   │   │ │ └─IdExp x
    │   │   │ └─OpExp *
    │   │   │   ├─NumExp 5
    │   │   │   └─IdExp x
    │   │   └─NumExp 1
    │   └─CompoundStm
    │     ├─PrintStm
    │     │ ├─IdExp x
    │     │ ├─OpExp +
    │     │ │ ├─IdExp x
    │     │ │ └─IdExp y
    │     │ └─OpExp -
    │     │   ├─IdExp x
    │     │   └─IdExp y
    │     └─AssignStm
    │       ├─x
    │       └─OpExp -
    │         ├─IdExp x
    │         └─NumExp 1
    └─PrintStm
      └─IdExp x

  maxargs: 3 |}];
