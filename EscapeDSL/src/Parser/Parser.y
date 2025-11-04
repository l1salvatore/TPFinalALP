{
module Parser.Parser where
import AST
import Parser.Lexer
}

%name parseEscapeRoom
%tokentype { Token }
%error { parseError }

%left "&&" "||"
%left ',' 
%nonassoc "==" "!="
%left '.'
%nonassoc EMPTY
%nonassoc ident

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
    typename    { TokenType $$ }
    numbertype  { TokenNumberType }  -- Added missing token
    messagetype { TokenMessageType }  -- Added missing token
    number      { TokenNumber $$ }
    string      { TokenString $$ }  -- Added missing token

%%

-- game-definition ::= game { declarations }
--                 | target typename { declarations }
--                 | object typename { declarations }
--                 | game-definition game-definition

GameDefinition : Definition                          { [$1] }
                | GameDefinition Definition          { $1 ++ [$2] }

Definition : game '{' Declarations '}'               { Game $3 }
           | target typename '{' Declarations '}'        { Target $2 $4 }
           | object typename '{' Declarations '}'        { Object $2 $4 }

-- declarations ::= unlock : [ unlock-conditions ]
--              |   elements : [ elements ]
--              |   init  : [ init-commands ]
--              |   actions : [ actions ]
--              |   declarations declarations 

Declarations : Declaration                           { [$1] }
             | Declarations Declaration              { $1 ++ [$2] }

Declaration : elements ':' '[' Elements ']'          { Elements $4 }
            | init ':' '[' InitCommands ']'          { Init $4 }
            | actions ':' '[' Actions ']'            { Actions $4 }
            | unlock ':' '[' UnlockConditions ']'    { Unlock $4 }

-- unlock-conditions ::= e | unlock-conditions-1
-- unlock-conditions-1 ::= boolexp 
--                  | unlock-conditions-1 , unlock-conditions-1

UnlockConditions :{- empty -}                       { [] }     
                 | BoolExp                          { [$1] }
                 | BoolExp ',' UnlockConditions     { $1 : $3 }

-- actions ::= e | actions1
-- actions1 ::= variable ( elements ) return-type -> command 
--           |  actions1 , actions1

Actions : {- empty -}                               { [] }
        | Action                                    { [$1] }
        | Action ',' Actions                        { $1 : $3 }

Action : ident '(' Elements ')' ActionReturnType "->" Command  { ActionDeclare $1 $3 $5 $7 }

-- return-type ::= e | as type 

ActionReturnType : {- empty -}                      { Nothing }
                 | as Type                          { Just $2 }

-- command ::= assignment
--         | chained-call
--         | return exp
--         | show exp

Command : Assignment                               { Assign $1 }
        | ChainedCall                              { ChainedCall $1 }
        | return Exp                               { Return $2 }
        | show Exp                                 { Show $2 }

-- elements ::= e | elements1
-- elements1 ::= type variable 
--          | elements1 , elements1

Elements : {- empty -}                             { [] }
         | Element                                 { [$1] }
         | Element ',' Elements                    { $1 : $3 }

Element : Type ident                               { ElementDeclare $1 $2 }

-- type ::= number | message | typename
Type : numbertype                                   { TNatural }
     | messagetype                                  { TMessage }
     | typename                                     { TypeName $1 }

-- init-commands ::= e | init-commands1
-- init-commands1 ::= init-command 
--               |  init-commands1 , init-commands1

InitCommands : {- empty -}                          { [] }
            | InitCommand                           { [$1] }
            | InitCommand ',' InitCommands           { $1 : $3 }

-- init-command ::= assignment
--                | chained-call

InitCommand : Assignment                           { InitAssign $1  }
           |  ident '.' init '(' ')'               { InitializeObject $1}

-- assignment ::= variable = exp

Assignment : ident '=' Exp                         { Let $1 $3 }

-- exp ::= chained 
--       | natural
--       | message

Exp : SimpleExp                     { $1 }

SimpleExp : Chained                 { Chained $1 }
         | number                   { Natural $1 }
         | string                   { Message $1 }

-- boolexp ::= true | false
--        | boolexp && boolexp
--        | boolexp || boolexp
--        | ( boolexp )
--        | ! boolexp
--        | exp == exp
--        | exp != exp

BoolExp : true                                   { BTrue }
        | false                                  { BFalse }
        | '(' BoolExp ')'                       { $2 }
        | "!" BoolExp                           { Not $2 }
        | BoolExp "&&" BoolExp                  { And $1 $3 }
        | BoolExp "||" BoolExp                  { Or $1 $3 }
        | CompExp                               { $1 }

CompExp : Exp "==" Exp                          { Eq $1 $3 }
        | Exp "!=" Exp                          { NEq $1 $3 }

-- Expresiones encadenadas sin ambigüedad
-- chained ::= variable
--           | chained . variable
--           | chained-call

-- chained-call ::= variable ( args )
--                | chained . variable ( args )

Chained : ChainedCall                            { Call $1 }
        | ChainedAccess                          { Access $1 }

ChainedCall : ident '(' Args ')'                 { Action $1 $3 }
            | Chained '.' ident '(' Args ')'     { ChainCall $1 (Action $3 $5) }

ChainedAccess : ident                            { Variable $1 }
              | Chained '.' ident                { ChainAccess $1 (Variable $3) }

-- args ::= e | args1
-- args1 ::= exp | args1 , args1
Args : {- empty -}                               { [] }
     | Exp                                     { [$1] }
     | Exp ',' Args                           { $1 : $3 }

{
parseError :: [Token] -> a
parseError _ = error "Syntax error"
}