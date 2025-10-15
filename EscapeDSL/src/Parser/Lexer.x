{
module Parser.Lexer where

}

%wrapper "basic"

$digit     = 0-9
$upper     = [A-Z]
$lower     = [a-z]
$alpha     = [A-Za-z]
$alphanum  = [A-Za-z0-9_]
$white     = [\ \t\n\r]
$stringChar = [^\"\\\n\r]
$escape     = [\"\/bfnrt]

tokens :-

  $white                ;

  "game"                { \s -> TokenGame }
  "target"              { \s -> TokenTarget }
  "object"              { \s -> TokenObject }
  "unlock"              { \s -> TokenUnlock }
  "elements"            { \s -> TokenElements }
  "init"                { \s -> TokenInit }
  "actions"             { \s -> TokenActions }
  "return"              { \s -> TokenReturn }
  "as"                  { \s -> TokenAs }
  "show"                { \s -> TokenShow }
  "true"                { \s -> TokenTrue }
  "false"               { \s -> TokenFalse }
  "message"             { \s -> TokenMessageType }
  "number"              { \s -> TokenNumberType }

  "{"                   { \s -> TokenLBrace }
  "}"                   { \s -> TokenRBrace }
  "["                   { \s -> TokenLBracket }
  "]"                   { \s -> TokenRBracket }
  "("                   { \s -> TokenLPar }
  ")"                   { \s -> TokenRPar }

  ":"                   { \s -> TokenColon }
  "."                   { \s -> TokenDot }
  ","                   { \s -> TokenComma }
  "=="                  { \s -> TokenEquals }
  "="                   { \s -> TokenAssign }
  "->"                  { \s -> TokenArrow }
  "&&"                  { \s -> TokenAnd }
  "||"                  { \s -> TokenOr }
  "!="                  { \s -> TokenDistinct }
  "!"                   { \s -> TokenNot }

  $upper$alphanum*      { \s -> TokenType s }
  $lower$alphanum*      { \s -> TokenIdent s }
  $digit+               { \s -> TokenNumber (read s) }
  \"($stringChar|$escape)*\"  { \s -> TokenString (init (tail s)) }


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
  | TokenTrue
  | TokenFalse
  | TokenNumberType
  | TokenMessageType

  | TokenLBrace | TokenRBrace
  | TokenLBracket | TokenRBracket
  | TokenLPar | TokenRPar
  | TokenColon | TokenComma | TokenAssign
  | TokenEquals | TokenArrow
  | TokenDistinct | TokenDot

  | TokenAnd | TokenOr | TokenNot

  | TokenIdent String
  | TokenType String
  | TokenNumber Int
  | TokenString String
  deriving (Show, Eq)
}