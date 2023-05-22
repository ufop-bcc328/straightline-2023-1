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
%token <int>           NUM
%token <string>        ID

%start <stm> program

%left SEMICOLON
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
