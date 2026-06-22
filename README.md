# IMP — a Parser and Interpreter in Haskell - Coursework at Leciester

A parser and interpreter for **IMP**, a small imperative programming language, written from
scratch in Haskell. The project implements the full front-to-back pipeline of a language
implementation — **tokenize → parse → evaluate** — including a hand-written tokenizer, a
combinatory parsing library, a precedence-aware grammar, and a big-step operational-semantics
evaluator, all wrapped in an interactive REPL.

IMP supports integer and boolean expressions, variable assignment, sequencing, `if`/`then`/`else`
conditionals, and `while` loops over an explicit program state.

## Features

- **Hand-written tokenizer** with maximal-munch scanning (identifiers, keywords, symbols, integers).
- **Parser-combinator library built from scratch** — `next` (sequencing), `alt` (ordered choice),
  `build` (semantic actions), and `many` (repetition) — with no external parsing dependencies.
- **Precedence-layered grammar**: `*` binds tighter than `+`/`-`, with parenthesised sub-expressions,
  expressed by stratifying the grammar into `iexp → factor → iatom`.
- **Big-step operational-semantics evaluator** for expressions and commands, threading an explicit
  `State` (a variable → integer mapping).
- **Precedence-aware pretty printer** that re-renders ASTs with minimal parentheses.
- **Two run modes**: an interactive REPL and a batch mode that evaluates each line of a file.

## Requirements

- [GHC](https://www.haskell.org/ghc/) (tested with 9.4.8). No external libraries are used beyond
  `base` and `System.Directory`.

## Build & Run

```bash
# Compile the REPL to an executable
ghc Main.hs -o imp
./imp

# Or run without compiling
runghc Main.hs

# Load a module interactively to test individual parsers/evaluators
ghci ImpPar.hs EvSem.hs
```

## Usage

At the `>IMP>` prompt:

| Command                 | Meaning                                                    |
| ----------------------- | ---------------------------------------------------------- |
| `eval (<code>,<state>)` | Parse and evaluate a program.                              |
| `run <filename>`        | Evaluate every line of a file, annotating each with `==>`. |
| `help` / `help 1\|2\|3` | Show help and the BNF grammar.                             |
| `quit`                  | Exit the REPL.                                             |

`<code>` is either `C <com>` (a command — evaluates to a final state) or `E <intexp>` (an integer
expression — evaluates to an `Int`). `<state>` is `[]` or a list of bindings like `[(x,5),(y,2)]`.

### Examples

```text
>IMP> eval (E 1+2*3,[])
 ==> 7

>IMP> eval (C x:=4+5+6,[])
 ==> [("x",15)]

>IMP> eval (C while x<=3 do x:=x+1,[(x,0)])
 ==> [("x",4)]
```

The first shows that `*` binds tighter than `+` (the parser builds `1 + (2 * 3)`). The third runs a
`while` loop that increments `x` from `0` until the guard `x <= 3` fails, leaving `x = 4`.

## Language Reference (BNF)

```text
<state>   ::= [ { (<var>, <integer>) }@ ]
<prog>    ::= ( <code>, <state> )
<code>    ::= C <com> | E <intexp>
<com>     ::= <var> := <intexp>
            | <com> ; <com>
            | if <boolexp> then <com> else <com>
            | while <boolexp> do <com>
<boolexp> ::= true | false
            | <intexp> <= <intexp> | <intexp> >= <intexp>
            | <intexp> <  <intexp> | <intexp> >  <intexp>
<intexp>  ::= <int> | <var>
            | <intexp> + <intexp> | <intexp> - <intexp> | <intexp> * <intexp>
```

where `<var>` is an alphabetic string and `<int>` is an integer.

## Project Layout

| Module      | Responsibility                                                                  |
| ----------- | ------------------------------------------------------------------------------- |
| `Tokens.hs` | Tokenizer: `String → [Token]` via maximal-munch scanning.                       |
| `Parse.hs`  | Generic parser-combinator library (`next`, `alt`, `build`, `many`, primitives). |
| `ImpPar.hs` | The IMP grammar built from the combinators, plus AST-building functions.        |
| `AST.hs`    | Algebraic data types for the language: `Com`, `IntExp`, `BoolExp`, `State`.     |
| `EvSem.hs`  | Evaluator: big-step semantics `evalint` / `evalbool` / `evalcom`.               |
| `Pretty.hs` | Precedence-aware pretty printer (`Pretty` typeclass).                           |
| `Basic.hs`  | List / association-list helpers (`mem`, `lookUp`, `update`).                    |
| `Files.hs`  | File-batch evaluation mode.                                                     |
| `Help.hs`   | REPL banner and help text.                                                      |
| `Main.hs`   | The REPL loop dispatching on parsed instructions.                               |

## Attribution

Built from a module skeleton provided in a University of Leicester functional-programming course
(© Roy L. Crole and Paula Severi). The tokenizer, parser combinators, grammar, evaluator, and
supporting functions were implemented by the author.
