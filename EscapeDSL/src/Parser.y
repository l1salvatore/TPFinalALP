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



GameDefinition : Definition                          { [$1] }
                | GameDefinition Definition          { $1 ++ [$2] }

Definition : game '{' Declarations '}'               { Game $3 }
           | target typename '{' Declarations '}'        { Target $2 $4 }
           | object typename '{' Declarations '}'        { Object $2 $4 }

Declarations : Declaration                           { [$1] }
             | Declarations Declaration              { $1 ++ [$2] }

Declaration : elements ':' '[' Elements ']'          { Elements $4 }
            | init ':' '[' Assignments ']'           { Init $4 }
            | actions ':' '[' Actions ']'            { Actions $4 }
            | unlock ':' '[' UnlockConditions ']'    { Unlock $4 }

UnlockConditions :{- empty -}                       { [] }     
                 | BoolExp                          { [$1] }
                 | BoolExp ',' UnlockConditions     { $1 : $3 }

Actions : {- empty -}                               { [] }
        | Action                                    { [$1] }
        | Action ',' Actions                        { $1 : $3 }

Action : ident '(' Elements ')' ActionReturnType "->" Command  { ActionDeclare $1 $3 $5 $7 }

ActionReturnType : {- empty -}                      { Nothing }
                 | as Type                          { Just $2 }

Command : Assignment                                { Assign $1 }
        | ChainedCall                              { ChainedCall $1 }
        | return Exp                               { Return $2 }
        | show Exp                                 { Show $2 }

Elements : {- empty -}                             { [] }
         | Element                                 { [$1] }
         | Element ',' Elements                    { $1 : $3 }

Type : numbertype                                   { TNatural }
     | messagetype                                  { TMessage }
     | typename                                     { TypeName $1 }

Element : Type ident                               { ElementDeclare $1 $2 }

Assignments : {- empty -}                          { [] }
            | Assignment                           { [$1] }
            | Assignment ',' Assignments           { $1 : $3 }

Assignment : ident '=' Exp                         { Let $1 $3 }

Exp : SimpleExp                     { $1 }

SimpleExp : Chained                 { Chained $1 }
         | number                   { Natural $1 }
         | string                   { Message $1 }

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
Chained : ChainedCall                            { Call $1 }
        | ChainedAccess                          { Access $1 }

ChainedCall : ident '(' Args ')'                 { Action $1 $3 }
            | Chained '.' ident '(' Args ')'     { ChainCall $1 (Action $3 $5) }

ChainedAccess : ident                            { Variable $1 }
              | Chained '.' ident                { ChainAccess $1 (Variable $3) }

Args : {- empty -}                               { [] }
     | ident                                     { [$1] }
     | ident ',' Args                           { $1 : $3 }

{
parseError :: [Token] -> a
parseError _ = error "Syntax error"
}