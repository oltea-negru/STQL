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
  [\+\-]?$number+                                         { \p s -> TokenLiteral p s } 
  $letters+                                               { \p s -> TokenLiteral p s }
  PRINT                                                   { \p s -> TokenPrint p}
  WHERE                                                   { \p s -> TokenWhere p}
  UNION                                                   { \p s -> TokenUnion p}
  \<                                                      { \p s -> TokenLessThan p}
  \>                                                      { \p s -> TokenGreaterThan p}
  PRED                                                    { \p s -> TokenPred p}
  SUB                                                     { \p s -> TokenSub p}
  OBJ                                                     { \p s -> TokenObj p}
  AND                                                     { \p s -> TokenAnd p}
  OR                                                      { \p s -> TokenOr p}
  FROM                                                    { \p s -> TokenFrom p}
  NOT                                                     { \p s -> TokenNot p}
  ADD                                                     { \p s -> TokenAdd p}
  DELETE                                                  { \p s -> TokenDelete p}
  CHANGE                                                  { \p s -> TokenChange p}
  RESTRICT                                                { \p s -> TokenRestrict p}  
  SORT                                                    { \p s -> TokenSort p}
  GET                                                     { \p s -> TokenGet p}
  \=                                                      { \p s -> TokenEquals p }

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
  TokenPrint AlexPosn             |
  TokenWhere AlexPosn             |
  TokenUnion AlexPosn             |
  TokenLessThan AlexPosn          |
  TokenGreaterThan AlexPosn       |
  TokenPred AlexPosn              |
  TokenSub AlexPosn               |
  TokenObj AlexPosn               |
  TokenAnd AlexPosn               |
  TokenComment AlexPosn           |
  TokenOr AlexPosn                |
  TokenFrom AlexPosn              |
  TokenEquals AlexPosn            |
  TokenNot AlexPosn               |
  TokenAdd AlexPosn               |
  TokenDelete AlexPosn            |
  TokenChange AlexPosn            | 
  TokenRestrict AlexPosn          |
  TokenSort AlexPosn              |
  TokenGet AlexPosn               
  deriving (Eq, Show)

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
tokenPosn (TokenPrint (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenWhere (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenUnion (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenLessThan (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenGreaterThan (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenPred (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenSub (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenObj (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenAnd (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenComment (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenOr (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenEquals (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenNot (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenAdd (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenChange (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenDelete (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenRestrict (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenSort (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenGet (AlexPn _ x y)) = show  x ++":"++show y


main = do
    file<- getArgs
    contents <- readFile $ head file 
    let list = alexScanTokens contents
    print list
}