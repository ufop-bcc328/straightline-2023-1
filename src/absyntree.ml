(* Convert abstract syntax trees to multiway trees of string *)

open Absyn

(* Helper functions *)

let sprintf = Format.sprintf

let mkt root children =
  PrintBox.tree (PrintBox.text root) children

(* Convert a binary operator to a string *)
let string_of_operator op =
  match op with
  | Plus -> "+"
  | Minus -> "-"
  | Times -> "*"
  | Div -> "/"

(* Convert a statement to a generic tree *)
let rec tree_of_stm stm =
  match stm with
  | CompoundStm (s1, s2) ->
     mkt "CompoundStm" [tree_of_stm s1; tree_of_stm s2]
  | AssignStm (v, e) ->
     mkt "AssignStm" [mkt v []; tree_of_exp e]
  | PrintStm args ->
     mkt "PrintStm" (List.map tree_of_exp args)

(* Convert an expression to a generic tree *)
and tree_of_exp exp =
  match exp with
  | IdExp v ->
     mkt (sprintf "IdExp %s" v) []
  | NumExp x ->
     mkt (sprintf "NumExp %i" x) []
  | OpExp (op, e1, e2) ->
     mkt
       (sprintf "OpExp %s" (string_of_operator op))
       [tree_of_exp e1; tree_of_exp e2]
  | EseqExp (s, e) ->
     mkt "EseqExp" [tree_of_stm s; tree_of_exp e]
