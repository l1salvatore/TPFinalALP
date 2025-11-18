{
module Parser.Parser where
import AST
import Parser.Lexer
}

%name parseEscapeRoom
%tokentype { Token }
%error { parseError }

%left "and" "or"
%left ','

%token
    game        { TokenGame }
    target      { TokenTarget }
    item        { TokenItem }
    unlock      { TokenUnlock }
    elements    { TokenElements }
    onuse       { TokenOnUse }
    if          { TokenIf }
    show        { TokenShow }
    locked      { TokenLocked }
    unlocked    { TokenUnlocked }
    is          { TokenIs }
    and         { TokenAnd }
    or          { TokenOr }
    '{'         { TokenLBrace }
    '}'         { TokenRBrace }
    '('         { TokenLPar }
    ')'         { TokenRPar }
    ':'         { TokenColon }
    ','         { TokenComma }
    "->"        { TokenArrow }
    objectname  { TokenIdent $$ }
    number      { TokenNumber $$ }
    string      { TokenString $$ }

%%

GameDefinition : Definition                          { [$1] }
               | GameDefinition Definition           { $1 ++ [$2] }

Definition : game '{' Elements '}'                   { Game $3 }
           | Type objectname '{' Declarations '}'    { ObjectDef $1 $2 $4 }

Type : target                                        { TTarget }
     | item                                          { TItem }

Declarations : Declaration                           { [$1] }
             | Declarations Declaration              { $1 ++ [$2] }

Declaration : unlock ':' number                      { Unlock $3 }
            | elements '{' Elements '}'              { Elements $3 }
            | onuse '{' Sentences '}'                { OnUse $3 }

Elements : objectname                               { [$1] }
         | Elements ',' Elements                    { $1 ++ $3 }

Sentences : Sentence                                { [$1] }
          | Sentences ',' Sentence                  { $1 ++ [$3] }

Sentence : if Condition "->" Command                { IfCommand $2 $4 }
         | Command                                  { Command $1 }

Command : show ShowMode                             { Show $2 }

ShowMode : objectname                               { ShowObject $1 }
         | string                                   { ShowMessage $1 }

Condition : locked                                  { Locked }
           | unlocked                               { Unlocked }
           | objectname is locked                   { ObjectLocked $1 }
           | objectname is unlocked                 { ObjectUnlocked $1 }
           | Condition and Condition                { And $1 $3 }
           | Condition or Condition                 { Or $1 $3 }
           | '(' Condition ')'                      { $2 }

{
parseError :: [Token] -> a
parseError _ = error "Parse error"
}