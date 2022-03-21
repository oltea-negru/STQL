{ 
module Lexer where 
import System.IO
import System.Environment
}

%wrapper "posn" 
$digit = 0-9     
-- digits 
$alpha = [a-zA-Z]    
-- alphabetic characters

tokens :-
$white+                                                   ; 
  "#".*                                                   ; 
  \.                                { \p s -> TokenDot p }
  \<                                { \p s -> TokenLeftArrow p}
  \>                                { \p s -> TokenRighttArrow p}
  "@base"                           { \p s -> TokenBase p } 
  "BASE"                            { \p s -> TokenBase p }
  "@prefix"                         { \p s -> TokenPrefix p  } 
  "PREFIX"                          { \p s -> TokenPrefix p }
  $digit+                           { \p s -> TokenInt p (read s) } 
  $alpha [$alpha $digit \_ \â€™]*   { \p s -> TokenVar p s } 

{ 
-- Each action has type ::  AlexPosn -> String -> Token 
-- The token type: 
data Token = 
  TokenLeftArrow AlexPosn    | 
  TokenRighttArrow AlexPosn  | 
  TokenDot AlexPosn          |
  TokenBase AlexPosn         | 
  TokenPrefix AlexPosn       |
  TokenInt AlexPosn Int      |
  TokenVar AlexPosn String   
  deriving (Eq,Show) 

tokenPosn :: Token -> String
tokenPosn (TokenLeftArrow (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenRighttArrow (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenBase (AlexPn _ x y)) =show x++":"++ show y 
tokenPosn (TokenPrefix (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenInt (AlexPn _ x y) a) = show  x ++":"++show y
tokenPosn (TokenVar (AlexPn _ x y) a) = show  x ++":"++show y
tokenPosn (TokenDot (AlexPn _ x y)) = show  x ++":"++show y

main = do
    contents <- readFile "test.ttl"
    let list = alexScanTokens contents
    print list
}