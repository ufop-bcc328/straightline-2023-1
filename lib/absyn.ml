type id = string
  [@@deriving show]

type binop =
  | Plus
  | Minus
  | Times
  | Div
  [@@deriving show]

type stm =
  | CompoundStm of stm * stm
  | AssignStm of id * exp
  | PrintStm of exp list
  [@@deriving show]

and exp =
  | IdExp of id
  | NumExp of int
  | OpExp of binop * exp * exp
  | EseqExp of stm * exp
  [@@deriving show]

(*
 let show_stm stm =
  match stm with
  | CompoundStm (a, b) -> "CompoundStm (" ^ show_stm a ^ "," ^ show_stm b ^ ")"
  | AssignStm (v, e) -> "AssignStm (" ^ v ^ ", " ^ show_exp e ^ ")"
  | PrintStm lst -> "PrintStm [" ^ show_exp_list lst ^ "]"
 *)
