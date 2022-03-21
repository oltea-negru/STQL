{ 
module Lexer where 
import System.IO
import System.Environment
}

%wrapper "posn"   
$letters = [a-zA-Z] 
$number = [0-9]

tokens :-
$white+                                                   ; 
  "#".*                                                   ; 
  \.                                { \p s -> TokenDot p }
  \<                                { \p s -> TokenLeftArrow p}
  \>                                { \p s -> TokenRighttArrow p}
  \,                                { \p s -> TokenComma p }                                
  \;                                { \p s -> TokenSemiColon p }
  \:                                { \p s -> TokenColon p }
  \/                                { \p s -> TokenSlash p }
  \"                                { \p s -> TokenQuote p }
  "http://"                         { \p s -> TokenURI p}
  "@base"                           { \p s -> TokenBase p } 
  "@prefix"                         { \p s -> TokenPrefix p  } 
  [\+\-]?$number+                   { \p s -> TokenLiteral p s } 
  $letters+                         { \p s -> TokenLiteral p s } 

{ 

data Token = 
  TokenLeftArrow AlexPosn         | 
  TokenRighttArrow AlexPosn       | 
  TokenDot AlexPosn               |
  TokenBase AlexPosn              | 
  TokenPrefix AlexPosn            |
  TokenLiteral AlexPosn String    |
  TokenComma AlexPosn             | 
  TokenSemiColon AlexPosn         |     
  TokenColon AlexPosn             | 
  TokenSlash AlexPosn             |
  TokenURI AlexPosn               |
  TokenQuote AlexPosn
  deriving (Eq,Show) 

tokenPosn :: Token -> String
tokenPosn (TokenLeftArrow (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenRighttArrow (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenBase (AlexPn _ x y)) =show x++":"++ show y 
tokenPosn (TokenPrefix (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenLiteral (AlexPn _ x y) a) = show  x ++":"++show y
tokenPosn (TokenColon (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenComma (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenSemiColon (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenSlash (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenQuote (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenURI (AlexPn _ x y)) = show  x ++":"++show y

main = do
    contents <- readFile "test.ttl"
    let list = alexScanTokens contents
    print list
}