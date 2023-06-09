{
  module Parser = Parser

  let illegal_character loc char =
    Error.error loc "illegal character '%c'" char
}

let spaces = [' ' '\t']+
let comment = '#' [^ '\n']*
let num = ['0'-'9']+
let id = ['a'-'z' 'A'-'Z']+ ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule token = parse
  | spaces     { token lexbuf }
  | comment    { token lexbuf }
  | '\n'       { Lexing.new_line lexbuf; token lexbuf }
  | '+'        { Parser.PLUS }
  | '-'        { Parser.MINUS }
  | '*'        { Parser.TIMES }
  | '/'        { Parser.DIV }
  | '('        { Parser.LPAREN }
  | ')'        { Parser.RPAREN }
  | ','        { Parser.COMMA }
  | ';'        { Parser.SEMICOLON }
  | ":="       { Parser.ASSIGN }
  | "print"    { Parser.PRINT }
  | "if"       { Parser.IF }
  (* UNCOMMENT this for the if and while commands
  | "then"     { Parser.THEN }
  | "else"     { Parser.ELSE }
  | "while"    { Parser.WHILE }
  | "do"       { Parser.DO }
  | "end"      { Parser.END }
  *)
  | num as lxm { Parser.NUM (int_of_string lxm) }
  | id as lxm  { Parser.ID lxm }
  | eof        { Parser.EOF }
  | _          { illegal_character
                   (Location.curr_loc lexbuf)
                   (Lexing.lexeme_char lexbuf 0) }
