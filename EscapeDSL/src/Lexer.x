{
module Lexer where
}

%wrapper "basic"

$digit     = 0-9
$upper     = [A-Z]
$lower     = [a-z]
$alpha     = [A-Za-z]
$alphanum  = [A-Za-z0-9_]
$white     = [ \t\n\r]+

tokens :-

  $white                ;  -- Ignora espacios y saltos de línea

  "game"                { TokenGame }
  "target"              { TokenTarget }
  "object"              { TokenObject }
  "unlock"              { TokenUnlock }
  "elements"            { TokenElements }
  "init"                { TokenInit }
  "actions"             { TokenActions }
  "return"              { TokenReturn }
  "as"                  { TokenAs }
  "show"                { TokenShow }

  "{"                   { TokenLBrace }
  "}"                   { TokenRBrace }
  "["                   { TokenLBracket }
  "]"                   { TokenRBracket }
  "("                   { TokenLPar }
  ")"                   { TokenRPar }

  ":"                   { TokenColon }
  ","                   { TokenComma }
  "="                   { TokenEquals }
  "->"                  { TokenArrow }
  "&&"                  { TokenAnd }
  "||"                  { TokenOr }
  "!"                   { TokenNot }

  $upper$alphanum*      { TokenType yytext }      -- Tipo: empieza en mayúscula
  $lower$alphanum*      { TokenIdent yytext }     -- Variable: empieza en minúscula
  $digit+               { TokenNumber (read yytext) }

{
data Token
  = TokenGame
  | TokenTarget
  | TokenObject
  | TokenUnlock
  | TokenElements
  | TokenInit
  | TokenActions
  | TokenAs
  | TokenReturn
  | TokenShow

  | TokenLBrace | TokenRBrace
  | TokenLBracket | TokenRBracket
  | TokenLPar | TokenRPar
  | TokenColon | TokenComma | TokenEquals | TokenArrow

  | TokenAnd | TokenOr | TokenNot

  | TokenIdent String
  | TokenType String
  | TokenNumber Int
  deriving (Show, Eq)
}