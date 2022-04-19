{ 
module Lexer where 
import System.IO
import System.Environment
}

%wrapper "posn"   
$letters = [a-zA-Z] 
$number = [0-9]
$mix =[0-9a-zA-Z]

tokens :-
$white+                                                                    ; 
  "#".*                                                                    ; 
  "<""http://www"\.$mix+\.$mix+(\/$mix+)*(\/\#$mix+)?\/?">"        { \p s -> TokenURI p s}
  "<"$mix+\/?">"                                          {\p s ->TokenShort p s}
  \.                                                      { \p s -> TokenDot p }
  \,                                                      { \p s -> TokenComma p }    
  \;                                                      { \p s -> TokenSemiColon p }
  \:                                                      { \p s -> TokenColon p }
  \"                                                      { \p s -> TokenQuote p }
  "@base"                                                 { \p s -> TokenBase p } 
  "@prefix"                                               { \p s -> TokenPrefix p } 
  \^^ $alpha [$alpha $digit \_ \’]*                       { \p s -> TokenComment p}                            
  OUTPUT                                                  { \p s -> TokenOutput p}
  ALL                                                     { \p s -> TokenAll p }
  IN                                                      { \p s -> TokenIn p}
  WHERE                                                   { \p s -> TokenWhere p}
  LINK                                                    { \p s -> TokenLink p}
  LESSTHAN                                                { \p s -> TokenLessThan p}
  GREATERTHAN                                             { \p s -> TokenGreaterThan p}
  PRED                                                    { \p s -> TokenPred p}
  SUB                                                     { \p s -> TokenSub p}
  OBJ                                                     { \p s -> TokenObj p}
  AND                                                     { \p s -> TokenAnd p}
  OR                                                      { \p s -> TokenOr p}
  FROM                                                    { \p s -> TokenFrom p}
  \=                                                      { \p s -> TokenEquals p }
  [\+\-]?$mix+                                         { \p s -> TokenLiteral p s } 

{ 

data Token = 
  TokenShort AlexPosn String      | 
  TokenDot AlexPosn               |
  TokenBase AlexPosn              | 
  TokenPrefix  AlexPosn           |
  TokenLiteral AlexPosn String    |
  TokenComma AlexPosn             | 
  TokenSemiColon AlexPosn         | 
  TokenQuote AlexPosn             |    
  TokenColon AlexPosn             |
  TokenURI AlexPosn String        |
  TokenOutput AlexPosn            |
  TokenIn AlexPosn                |
  TokenWhere AlexPosn             |
  TokenLink AlexPosn              |
  TokenLessThan AlexPosn          |
  TokenGreaterThan AlexPosn       |
  TokenInt AlexPosn Int           |
  TokenPred AlexPosn              |
  TokenSub AlexPosn               |
  TokenObj AlexPosn               |
  TokenAnd AlexPosn               |
  TokenComment AlexPosn           |
  TokenOr AlexPosn                |
  TokenFrom AlexPosn              |
  TokenEquals AlexPosn            |
  deriving (Eq,Show) 


tokenPosn :: Token -> String
tokenPosn (TokenShort (AlexPn _ x y)a) = show  x ++":"++show y
tokenPosn (TokenBase (AlexPn _ x y)) =show x++":"++ show y 
tokenPosn (TokenPrefix (AlexPn _ x y) ) = show  x ++":"++show y
tokenPosn (TokenLiteral (AlexPn _ x y) a) = show  x ++":"++show y
tokenPosn (TokenColon (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenQuote (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenComma (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenSemiColon (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenURI (AlexPn _ x y) s) = show  x ++":"++show y
tokenPosn (TokenOutput (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenIn  (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenWhere (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenLink (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenLessThan  (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenGreaterThan  (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenInt  Int (AlexPn _ x y)a) = show  x ++":"++show y
tokenPosn (TokenPred  (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenSub  (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenObj  (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenAnd  (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenComment (AlexPn _ x y) a) = show  x ++":"++show y
tokenPosn (TokenOr   (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenFrom  (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenEquals  (AlexPn _ x y)) = show  x ++":"++show y

-- main = do
--     file<- getArgs
--     contents <- readFile $ head file 
--     let list = alexScanTokens contents
--     print list
}