// parser.mly

%{
  open Absyn
%}

%token                 EOF
%token                 PLUS
%token                 MINUS
%token                 TIMES
%token                 DIV
%token                 LPAREN
%token                 RPAREN
%token                 COMMA
%token                 SEMICOLON
%token                 ASSIGN
%token                 PRINT
(* UNCOMMENT this for the if and while commands
%token                 IF
%token                 THEN
%token                 ELSE
%token                 WHILE
%token                 DO
%token                 END
*)
%token <int>           NUM
%token <string>        ID

%start <stm> program

%right SEMICOLON
%left PLUS MINUS
%left TIMES DIV

%%

program:
| s=stm EOF { s }
;

stm:
| a=stm SEMICOLON b=stm { CompoundStm (a, b) }
| x=ID ASSIGN e=exp { AssignStm (x, e) }
| PRINT LPAREN l=explist RPAREN { PrintStm l }
(* UNCOMMENT this for the if and while commands
| IF test=exp THEN s1=stm ELSE s2=stm END { IfStm (test, s1, s2) }
| WHILE test=exp DO body=stm END { WhileStm (test, body) }
*)
;

exp:
| v=ID { IdExp v }
| c=NUM { NumExp c }
| a=exp op=binop b=exp { OpExp (op, a, b) }
| LPAREN s=stm COMMA x=exp RPAREN { EseqExp (s, x) }
;

explist:
| l=separated_nonempty_list(COMMA, exp) { l }
;

%inline binop:
| PLUS { Plus }
| MINUS { Minus }
| TIMES { Times }
| DIV { Div }
;
