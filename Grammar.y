{ 
module Grammar where 
import Tokens 
}

%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token 
    let   { TokenLet p } 
    in    { TokenIn p } 
    int   { TokenInt p $$ } 
    var   { TokenVar p $$ } 
    '='   { TokenEq p } 
    '+'   { TokenPlus p } 
    '-'   { TokenMinus p } 
    '*'   { TokenTimes p } 
    '/'   { TokenDiv p } 
    '('   { TokenLParen p } 
    ')'   { TokenRParen p } 
    expon { TokenExpon p }

%left '+' '-' 
%left '*' '/' 
%right in expon
%left NEG 
%% 
Exp : let var '=' Exp in Exp { Let $2 $4 $6 } 
    | Exp expon Exp          { Expon $1 $3 }
    | Exp '+' Exp            { Plus $1 $3 } 
    | Exp '-' Exp            { Minus $1 $3 } 
    | Exp '*' Exp            { Times $1 $3 } 
    | Exp '/' Exp            { Div $1 $3 } 
    | '(' Exp ')'            { $2 } 
    | '-' Exp %prec NEG      { Negate $2 } 
    | int                    { Int $1 } 
    | var                    { Var $1 } 
    
{ 
    
parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b

data Exp = Let String Exp Exp 
         | Expon Exp Exp
         | Plus Exp Exp 
         | Minus Exp Exp 
         | Times Exp Exp 
         | Div Exp Exp 
         | Negate Exp
         | Int Int 
         | Var String 
         deriving Show 

main = do
     contents <- readFile "input.txt"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     print result
} 