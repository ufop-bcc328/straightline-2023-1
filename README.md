# The *straightline* programming language

**Straightline** is a micro programming language used in the book series [Modern Compiler Implementation](http://www.cs.princeton.edu/~appel/modern/) by Andrew Appel.

# Grammar

- The syntax of the language is given by a context free grammar.
- Only the production rules are explicitly given.
- The sets of terminals and non-terminals are obtained from the rules.
- The initial symbol is the non-terminal on the left side of the first production rule.

## Production rules

_Stm_ → _Stm_ `;` _Stm_  
_Stm_ → `id` `:=` _Exp_  
_Stm_ → `print` `(` _ExpList_ `)`  
_Exp_ → `id`  
_Exp_ → `num`  
_Exp_ → _Exp_ _Binop_ _Exp_  
_Exp_ → `(` _Stm_ `,` _Exp_ `)`  
_ExpList_ → _Exp_  
_ExpList_ → _Exp_ `,` _ExpList_  
_Binop_ → `+`  
_Binop_ → `-`  
_Binop_ → `*`  
_Binop_ → `/`  

## Operator Precedence and Associativity

In order to resolve possible conflicts during syntactic analysis, the following relation of operator precedence and associativity, in descending order, should be observed:

| operators | associativity |
|-|-|
|`*` `\`|left|
|`+` `-`|left|
|`:=`|right|
|`;`|right|

## Lexical symbols

- Spaces, newlines, and tabulators are **white spaces**.
- **Comments** starts with `#` and extends to the end of the line.
- A **numerical literal** is a sequence of one or more digits optionally followed by a dot and another sequence of one or more digits.
- An **identifier** is a sequence of one or more letters, digits and underscores, beginning with a letter, that is not a keyword.
- The **keywords** are: `print`.
- The **operators** are: `:=`, `+`, `-`, `*` and `/`.
- The **special symbols** are: `,`, `;`, `(` and `)`.

# Example

```
a := 5 + 3;
b := ( print(a, a-1), 10*a);
print(b)
```

# Activity

You are going to extend the straightline programming language to include two commands:

- a selection command:
  ```
  if <condition> then <command1> else <command2> end
  ```
  where `<condition>` is an expression and `<command1>` and `<command2>` are commands. When executred, `<condition>` is evaluated and its value is checked: if it is not zero, `<command1>` is executred and `<command2>` is ignored; otherwise `<command1>` is ignored and `<command2>` is executed.

- a repetition command:
  ```
  while <condition> do <body> end
  ```
  where `<condition>` is an expression and `<body>` is a command. When executred, `<condition>` is evaluated and it value is checked: if it is not zero, `<body>` is executed and the process repeats.

You need to add appropriate  value constructors `IfStm` and `WhileStm` to type `stm` in the module in file `lib/absyn.ml`.

Also the module in `lib/absyntree.ml` needs to be modified in order to take into account these new value constructors when commands are converted to general trees for proper drawing.

The module in `lib/maxargs.ml` should also be updated accordingly.

The code needed for the lexical and syntatical analysis of these new commands are already included as comments in the lexical specification `lib/lexer.mll` and in the grammar `lib/parser.mly`. It should be uncomment.

Finally the all the tests in `lib/test_maxargs.ml` should succeed.
