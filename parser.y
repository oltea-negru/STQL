{ 
module Parser where 
import Lexer 
}

%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token  
    http       { TokenURI p $$ }
    '.'        { TokenDot p }
    '<'        { TokenLeftArrow p }
    '>'        { TokenRightArrow p }
  --  ','        { TokenComma p }
  --  ';'        { TokenSemicolon p }
 --   ':'        { TokenColon p }
 --   '/'        { TokenSlash p }
--    '"'        { TokenQuote p }
 --   base       { TokenBase p }
 --   prefix     { TokenPrefix p }
    lit        { TokenLiteral p $$ }

%%

Triplet :        Sub PredList '.'       { Triplet $1 $2}
Sub:             '<' http '>'           { Subject $2}
PredList:        Pred Obj               { PredicateList $1 $2}
Pred:            '<' http '>'           { Predicate $2}
Obj:             lit                    { Object $1}
  --  |             lit ',' lit            { ObjectList $1 $3}

{ 
    
parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b


data Triplet= Triplet Subject PredicateList deriving Show

data Subject = Subject String deriving Show

data PredicateList = PredicateList Predicate Object deriving Show

data Predicate = Predicate String deriving Show

-- data ObjectList = ObjectList Object String  Object   deriving Show
data Object = Object String deriving Show


main = do
     contents <- readFile "test.ttl"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     print result
} 