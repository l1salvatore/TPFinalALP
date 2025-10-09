{
module Parser where
import AST
}

%name parseEscapeRoom
%tokentype { Token }
%error { parseError }

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

    '{'         { TokenLBrace }
    '}'         { TokenRBrace }
    '['         { TokenLBracket }
    ']'         { TokenRBracket }
    '('         { TokenLPar }
    ')'         { TokenRPar }
    ':'         { TokenColon }
    ','         { TokenComma }
    '='         { TokenEquals }
    "->"        { TokenArrow }

    "&&"        { TokenAnd }
    "||"        { TokenOr }
    "!"         { TokenNot }

    ident       { TokenIdent $$ }
    type        { TokenType $$ }
    number      { TokenNumber $$ }

%%

GameDefinition : game '{' Declarations '}' Definition { GameDefinition $3 $5 }
             |  Definition GameDefinition             { GameDefinitionSeq $1 $2 }

Definition : target type '{' TargetDeclarations '}'   { }

{
parseError :: [Token] -> a
parseError _ = error "Syntax error"
}