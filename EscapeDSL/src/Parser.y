{
module Parser where
import AST
import Lexer
}

%name parseEscapeRoom
%tokentype { Token }
%error { parseError }

%left "&&" "||"
%left ',' 
%nonassoc "==" "!="
%left '.'

%token
    game        { TokenGame }
    target      { TokenTarget }
    object      { TokenObject }
    unlock      { TokenUnlock }
    elements    { TokenElements }
    init        { TokenInit }
    actions     { TokenActions }
    return      { TokenReturn }
    as          { TokenAs }
    show        { TokenShow }
    true        { TokenTrue }
    false       { TokenFalse }

    '{'         { TokenLBrace }
    '}'         { TokenRBrace }
    '['         { TokenLBracket }
    ']'         { TokenRBracket }
    '('         { TokenLPar }
    ')'         { TokenRPar }
    ':'         { TokenColon }
    ','         { TokenComma }
    '='         { TokenAssign }
    '.'         { TokenDot }
    "=="        { TokenEquals }
    "->"        { TokenArrow }
    "&&"        { TokenAnd }
    "||"        { TokenOr }
    "!"         { TokenNot }
    "!="        { TokenDistinct }

    ident       { TokenIdent $$ }
    type        { TokenType $$ }
    number      { TokenNumber $$ }
    string      { TokenString $$ }  -- Added missing token

%%

GameDefinitions : Definition                          { [$1] }
                | GameDefinitions Definition          { $1 ++ [$2] }

Definition : game '{' Declarations '}'               { Game $3 }
           | target type '{' Declarations '}'        { Target $2 $4 }
           | object type '{' Declarations '}'        { Object $2 $4 }

Declarations : Declaration                           { [$1] }
             | Declarations Declaration              { $1 ++ [$2] }

Declaration : elements ':' '[' Elements ']'          { Elements $4 }
            | init ':' '[' Assignments ']'           { Init $4 }
            | actions ':' '[' Actions ']'            { Actions $4 }
            | unlock ':' '[' UnlockConditions ']'    { Unlock $4 }

UnlockConditions : BoolExp                          { [$1] }
                 | BoolExp ',' UnlockConditions     { $1 : $3 }

Actions : {- empty -}                               { [] }
        | Action                                    { [$1] }
        | Action ',' Actions                        { $1 : $3 }

Action : ident '(' Elements ')' ActionReturnType "->" Command  { ActionDeclare $1 $3 $5 $7 }

ActionReturnType : {- empty -}                      { Nothing }
                 | as type                          { Just $2 }

Command : Assignment                                { Assign $1 }
        | ChainedBase                              { ChainedCall $1 }
        | return Exp                               { Return $2 }
        | show Exp                                 { Show $2 }

Elements : {- empty -}                             { [] }
         | Element                                 { [$1] }
         | Element ',' Elements                    { $1 : $3 }

Element : type ident                               { ElementDeclare $1 $2 }

Assignments : {- empty -}                          { [] }
            | Assignment                           { [$1] }
            | Assignment ',' Assignments           { $1 : $3 }

Assignment : ident '=' Exp                         { Let $1 $3 }

Exp : SimpleExp                     { $1 }
    | ComparisonExp                 { $1 }

SimpleExp : Chained                 { Chained $1 }
         | number                   { Natural $1 }
         | string                   { Message $1 }

ComparisonExp : SimpleExp "==" SimpleExp  { Eq $1 $3 }
              | SimpleExp "!=" SimpleExp  { NEq $1 $3 }

BoolExp : AndExp                    { $1 }
        | BoolExp "||" AndExp       { Or $1 $3 }

AndExp : NotExp                                   { $1 }
       | AndExp "&&" NotExp                       { And $1 $3 }

NotExp : AtomicBool                               { $1 }
       | "!" NotExp                               { Not $2 }

AtomicBool : true                                 { BTrue }
           | false                                { BFalse }
           | ComparisonExp                        { $1 }
           | '(' BoolExp ')'                      { $2 }

-- Expresiones encadenadas sin ambigüedad
Chained : ChainedBase                             { $1 }

ChainedBase : ident                               { Variable $1 }
            | ident '(' Args ')'                  { Action $1 $3 }
            | ChainedBase '.' ident               { ChainAccess $1 $3 }
            | ChainedBase '.' ident '(' Args ')'  { ChainCall $1 $3 $5 }

Args : {- empty -}                               { [] }
     | ident                                     { [$1] }
     | ident ',' Args                           { $1 : $3 }

{
parseError :: [Token] -> a
parseError _ = error "Syntax error"
}