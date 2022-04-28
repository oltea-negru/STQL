{ 
module Lexer where 
}

%wrapper "posn"   
$letters = [a-zA-Z] 
$number = [0-9]
$mix =[0-9a-zA-Z\#]

tokens :-
$white+                                                                   ; 
  \#.*                                                                    ; 
  \/\*(\n|.*)*\*\/                                                         ;
"<""http://www"\.$mix+\.$mix+(\/$mix+)*(\/\#$mix+)?\/?">"  { \p s -> TokenURI p s}
  "http://www"\.$mix+\.$mix+(\/$mix+)*(\/\#$mix+)?\/?    { \p s -> TokenURIValue p s}
  $mix+".ttl"                                        { \p s -> TokenFile p s} 
  "<"$mix+\/?($mix+\/?)*">"                             { \p s -> TokenShort p s}
  "@base"                                                    { \p s -> TokenBase p } 
  "@prefix"                                                  { \p s -> TokenPrefix p } 
  "true"                                                     { \p s -> TokenTrue p (read "True")}
  "false"                                                    { \p s -> TokenFalse p (read "False")}
  PRINT                                                      { \p s -> TokenPrint p}
  WHERE                                                      { \p s -> TokenWhere p}
  UNION                                                      { \p s -> TokenUnion p}
  PRED                                                       { \p s -> TokenPred p s}
  SUB                                                        { \p s -> TokenSub p s}
  OBJ                                                        { \p s -> TokenObj p s}
  AND                                                        { \p s -> TokenAnd p}
  OR                                                         { \p s -> TokenOr p}
  FROM                                                       { \p s -> TokenFrom p}
  ADD                                                        { \p s -> TokenAdd p}
  DELETE                                                     { \p s -> TokenDelete p}
  RESTRICT                                                   { \p s -> TokenRestrict p}  
  GET                                                        { \p s -> TokenGet p}
  THEN                                                       { \p s -> TokenThen p}
  LINK                                                       { \p s -> TokenLink p}
  IN                                                         { \p s -> TokenIn p}
  \-?$number+                                                { \p s -> TokenInt p (read s) }
  \+?$number+                                                { \p s -> TokenInt p (read (drop 1 s)) }
  \"$mix+\"                                                  { \p s -> TokenLiteral p s }
  $mix+                                                      { \p s -> TokenLiteral p s }
  \(                                                         { \p s -> TokenLBrack p}
  \)                                                         { \p s -> TokenRBrack p}
  \.                                                         { \p s -> TokenDot p }
  \,                                                         { \p s -> TokenComma p }    
  \;                                                         { \p s -> TokenSemiColon p }
  \:                                                         { \p s -> TokenColon p }
  \"                                                         { \p s -> TokenQuote p }
  \<                                                         { \p s -> TokenLess p}
  \>                                                         { \p s -> TokenGreater p}
  \<\=                                                       { \p s -> TokenLessEq p}
  \>\=                                                       { \p s -> TokenGreaterEq p}
  \=                                                         { \p s -> TokenEquals p }
  \!\=                                                       { \p s -> TokenNot p}

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
  TokenIn AlexPosn                |
  TokenEquals AlexPosn            |
  TokenNot AlexPosn               |
  TokenAdd AlexPosn               |
  TokenThen AlexPosn              |
  TokenDelete AlexPosn            |
  TokenChange AlexPosn            | 
  TokenRestrict AlexPosn          |
  TokenGet AlexPosn               |
  TokenURIValue AlexPosn String   |
  TokenFile AlexPosn String       |
  TokenLBrack AlexPosn            |
  TokenRBrack AlexPosn            |
  TokenLink   AlexPosn            |
  TokenTrue AlexPosn Bool         |
  TokenFalse AlexPosn Bool
  deriving (Eq, Show)

tokenPosn :: Token -> String
tokenPosn (TokenShort (AlexPn _ x y)a) = show  x ++":"++show y
tokenPosn (TokenBase (AlexPn _ x y)) =show x++":"++ show y 
tokenPosn (TokenPrefix (AlexPn _ x y) ) = show  x ++":"++show y
tokenPosn (TokenLiteral (AlexPn _ x y) a) = show  x ++":"++show y
tokenPosn (TokenColon (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenQuote (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenThen (AlexPn _ x y))=show x ++ ":" ++ show y
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
tokenPosn (TokenGet (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenLessEq (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenGreaterEq (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenURIValue (AlexPn _ x y) s) = show  x ++":"++show y
tokenPosn (TokenFile (AlexPn _ x y) s) = show  x ++":"++show y
tokenPosn (TokenLBrack (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenRBrack (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenTrue (AlexPn _ x y)s) = show  x ++":"++show y
tokenPosn (TokenFalse (AlexPn _ x y)s) = show  x ++":"++show y
tokenPosn (TokenDot (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenIn (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenLink (AlexPn _ x y)) = show  x ++":"++show y
tokenPosn (TokenSemiColon (AlexPn _ x y))= show  x ++":"++show y
tokenPosn a =show a
}