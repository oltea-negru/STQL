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
$white+                                                                   ; 
  \#.*                                                                    ; 
  "<""http://www"\.$mix+\.$mix+(\/$mix+)*(\/\#$mix+)?\/?">"  { \p s -> TokenURI p s}
  "<"$mix+\/?">"                                             {\p s ->TokenShort p s}
  \(                                                         {\p s -> TokenLBrack p}
  \)                                                         {\p s -> TokenRBrack p}
  \.                                                         { \p s -> TokenDot p }
  \,                                                         { \p s -> TokenComma p }    
  \;                                                         { \p s -> TokenSemiColon p }
  \:                                                         { \p s -> TokenColon p }
  \"                                                         { \p s -> TokenQuote p }
  "@base"                                                    { \p s -> TokenBase p } 
  "@prefix"                                                  { \p s -> TokenPrefix p } 
  \<                                                         { \p s -> TokenLess p}
  \>                                                         { \p s -> TokenGreater p}
  \<\=                                                       { \p s -> TokenLessEq p}
  \>\=                                                       { \p s -> TokenGreaterEq p}
  $number+                                                   { \p s -> TokenInt p (read s) }
  "true"                                                     { \p s -> TokenTrue p  s}
  "false"                                                    { \p s -> TokenFalse p  s}
  PRINT                                                      { \p s -> TokenPrint p}
  WHERE                                                      { \p s -> TokenWhere p}
  UNION                                                      { \p s -> TokenUnion p}
  PRED                                                       { \p s -> TokenPred p s}
  SUB                                                        { \p s -> TokenSub p s}
  OBJ                                                        { \p s -> TokenObj p s}
  AND                                                        { \p s -> TokenAnd p}
  OR                                                         { \p s -> TokenOr p}
  FROM                                                       { \p s -> TokenFrom p}
  NOT                                                        { \p s -> TokenNot p}
  ADD                                                        { \p s -> TokenAdd p}
  DELETE                                                     { \p s -> TokenDelete p}
  RESTRICT                                                   { \p s -> TokenRestrict p}  
  GET                                                        { \p s -> TokenGet p}
  \=                                                         { \p s -> TokenEquals p }
  \"$letters+".ttl"\"                                        { \p s -> TokenFile p s}
  \""http://www"\.$mix+\.$mix+(\/$mix+)*(\/\#$mix+)?\/?\"    { \p s -> TokenURIValue p s} 
  [\+\-]?$mix+                                            { \p s -> TokenLiteral p s } 

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
  TokenInt AlexPosn Int           |
  TokenWhere AlexPosn             |
  TokenUnion AlexPosn             |
  TokenLess AlexPosn              |
  TokenGreater AlexPosn           |
  TokenLessEq AlexPosn            |
  TokenGreaterEq AlexPosn         |
  TokenPred AlexPosn String       |
  TokenSub AlexPosn  String       |
  TokenObj AlexPosn  String       |
  TokenAnd AlexPosn               |
  TokenComment AlexPosn           |
  TokenOr AlexPosn                |
  TokenFrom AlexPosn              |
  TokenEquals AlexPosn            |
  TokenSelect AlexPosn            |
  TokenNot AlexPosn               |
  TokenAdd AlexPosn               |
  TokenDelete AlexPosn            |
  TokenChange AlexPosn            | 
  TokenRestrict AlexPosn          |
  TokenSort AlexPosn              |
  TokenGet AlexPosn               |
  TokenURIValue AlexPosn String   |
  TokenFile AlexPosn String       |
  TokenLBrack AlexPosn            |
  TokenRBrack AlexPosn            |
  TokenTrue AlexPosn String              |
  TokenFalse AlexPosn String
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
tokenPosn (TokenLess (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenGreater (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenPred (AlexPn _ x y)s) = show  x ++":"++show y
tokenPosn (TokenSub (AlexPn _ x y)s) = show  x ++":"++show y
tokenPosn (TokenObj (AlexPn _ x y)s) = show  x ++":"++show y
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
tokenPosn (TokenLessEq (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenGreaterEq (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenURIValue (AlexPn _ x y) s) = show  x ++":"++show y
tokenPosn (TokenFile (AlexPn _ x y) s) = show  x ++":"++show y
tokenPosn (TokenLBrack (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenRBrack (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenTrue (AlexPn _ x y)s) = show  x ++":"++show y
tokenPosn (TokenFalse (AlexPn _ x y)s) = show  x ++":"++show y
tokenPosn (TokenSelect (AlexPn _ x y)) = show  x ++":"++show y



-- main = do
--     file<- getArgs
--     contents <- readFile $ head file 
--     let list = alexScanTokens contents
--     print list
}