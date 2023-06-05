open Absyn
let rec maxargs stm =
  match stm with
  | CompoundStm (s1, s2) -> max (maxargs s1) (maxargs s2)
  | AssignStm (_, e) -> maxargs_exp e
  | PrintStm lst -> max (List.length lst) (maxargs_exp_list lst)

and maxargs_exp exp =
  match exp with
  | IdExp _ -> 0
  | NumExp _ -> 0
  | OpExp (_, e1, e2) -> max (maxargs_exp e1) (maxargs_exp e2)
  | EseqExp (s, e) -> max (maxargs s) (maxargs_exp e)

and maxargs_exp_list lst =
  match lst with
  | [] -> 0
  | h :: t -> max (maxargs_exp h) (maxargs_exp_list t)

and maxargs_exp_list_ lst =
  let l = List.map maxargs_exp lst in
  List.fold_left max 0 l
