{
module Parser.Lexer where

import Data.Char (isSpace)
}

%wrapper "basic"

$digit     = 0-9
$upper     = [A-Z]
$lower     = [a-z]
$alphanum  = [A-Za-z0-9_]
$white     = [\ \t\n\r]
$string    = [^\"\\\n\r]
$escape     = [\"\/bfnrt]

tokens :-

  $white                ;

  "game"                { \_ -> TokenGame }
  "target"              { \_ -> TokenTarget }
  "item"                { \_ -> TokenItem }
  "unlock"              { \_ -> TokenUnlock }
  "elements"            { \_ -> TokenElements }
  "onuse"               { \_ -> TokenOnUse }
  "if"                  { \_ -> TokenIf }
  "show"                { \_ -> TokenShow }
  "locked"              { \_ -> TokenLocked }
  "unlocked"            { \_ -> TokenUnlocked }
  "is"                  { \_ -> TokenIs }
  "and"                 { \_ -> TokenAnd }
  "or"                  { \_ -> TokenOr }

  "{"                   { \_ -> TokenLBrace }
  "}"                   { \_ -> TokenRBrace }
  "("                   { \_ -> TokenLPar }
  ")"                   { \_ -> TokenRPar }
  ":"                   { \_ -> TokenColon }
  ","                   { \_ -> TokenComma }
  "->"                  { \_ -> TokenArrow }

  $upper$alphanum*      { \s -> TokenIdent s }    -- tipos si usas identificadores con mayúscula
  $lower$alphanum*      { \s -> TokenIdent s }    -- tipos si usas identificadores con mayúscula
  $digit+               { \s -> TokenNumber (read s) }
  $string               { \s -> TokenString (read s) }
  \"($string|$escape)*\"  { \s -> TokenString (init (tail s)) }

  .                     { \s -> error ("Unexpected character: " ++ show s) }


{
data Token
  = TokenGame
  | TokenTarget
  | TokenItem
  | TokenUnlock
  | TokenElements
  | TokenOnUse
  | TokenIf
  | TokenShow
  | TokenLocked
  | TokenUnlocked
  | TokenIs
  | TokenAnd
  | TokenOr

  | TokenLBrace | TokenRBrace
  | TokenLPar | TokenRPar
  | TokenColon | TokenComma
  | TokenArrow

  | TokenIdent String
  | TokenNumber Int
  | TokenString String
  deriving (Show, Eq)
}