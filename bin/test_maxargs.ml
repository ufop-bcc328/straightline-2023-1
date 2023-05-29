open Absyn

let p1 =
  CompoundStm (
    AssignStm ("a", OpExp (Plus, NumExp 5, NumExp 3)),
    CompoundStm (
      AssignStm (
        "b",
        EseqExp (
          PrintStm [
            IdExp "a";
            OpExp (Minus, IdExp "a", NumExp 1)
          ],
          OpExp (Times, NumExp 10, IdExp "a")
        )
      ),
      PrintStm [IdExp "b"]
    )
  )

let () = Format.printf "maxargs: %i\n" (Maxargs.maxargs p1)
