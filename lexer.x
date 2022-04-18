{ 
module Lexer where 
import System.IO
import System.Environment
}

%wrapper "posn"   
$letters = [a-zA-Z] 
$number = [0-9]

tokens :-
$white+                                                                    ; 
  "#".*                                                                    ; 
  "<""http://www"\.$letters+\.$letters+(\/$letters+)*(\/\#$letters+)?">"        { \p s -> TokenURI p s}
  "<"$letters+">" {\p s ->TokenShort p s}
  \.                                                      { \p s -> TokenDot p }
  \,                                                      { \p s -> TokenComma p }                                
  \;                                                      { \p s -> TokenSemiColon p }
  \:                                                      { \p s -> TokenColon p }
  "@base"                                                 { \p s -> TokenBase p } 
  "@prefix"                                               { \p s -> TokenPrefix p } 
  [\+\-]?$number+                                         { \p s -> TokenLiteral p s } 
  $letters+                                               { \p s -> TokenLiteral p s } 

{ 

data Token = 
  TokenShort AlexPosn String      | 
  TokenDot AlexPosn               |
  TokenBase AlexPosn              | 
  TokenPrefix  AlexPosn           |
  TokenLiteral AlexPosn String    |
  TokenComma AlexPosn             | 
  TokenSemiColon AlexPosn         |     
  TokenColon AlexPosn             |
  TokenURI AlexPosn String        
  deriving (Eq,Show) 

tokenPosn :: Token -> String
tokenPosn (TokenShort (AlexPn _ x y)a) = show  x ++":"++show y
tokenPosn (TokenBase (AlexPn _ x y)) =show x++":"++ show y 
tokenPosn (TokenPrefix (AlexPn _ x y) ) = show  x ++":"++show y
tokenPosn (TokenLiteral (AlexPn _ x y) a) = show  x ++":"++show y
tokenPosn (TokenColon (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenComma (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenSemiColon (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenURI (AlexPn _ x y) s) = show  x ++":"++show y

-- main = do
--     file<- getArgs
--     contents <- readFile $ head file 
--     let list = alexScanTokens contents
--     print list
}