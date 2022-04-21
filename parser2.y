{
module LangParser where
import Lexer
import System.Environment
import System.IO
}

%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token 
  '('                  { TokenLBrack p}  
  ';'                  { TokenSemiColon p}  
  ')'                  { TokenRBrack p} 
  '<'                  { TokenLess p}
  '>'                  { TokenGreater p}
  '<='                 { TokenLessEq p}
  '>='                 { TokenGreaterEq p}
  '='                  { TokenEquals p }
  ','                  { TokenComma p}
  int                  { TokenInt p $$ }
  lit                  { TokenLiteral p $$} 
  TRUE                 { TokenTrue p $$}
  FALSE                { TokenFalse p $$}
  PRINT                { TokenPrint p}
  WHERE                { TokenWhere p}
  UNION                { TokenUnion p}
  PRED                 { TokenPred p $$}
  SUB                  { TokenSub p $$}
  OBJ                  { TokenObj p $$}
  AND                  { TokenAnd p}
  OR                   { TokenOr p}
  FROM                 { TokenFrom p}
  NOT                  { TokenNot p}
  ADD                  { TokenAdd p}
  DELETE               { TokenDelete p}
  RESTRICT             { TokenRestrict p}  
  SORT                 { TokenSort p}
  GET                  { TokenGet p}
  URI                  { TokenURIValue p $$}
  file                 { TokenFile p $$}
  SELECT               { TokenSelect p}

%right '<' '<=' '>=' '>'
%left AND OR '='
%%

Exp: PRINT FROM File Seq               { Print $3 $4}
     | PRINT FROM File                 { SimplePrint $3}
  
Seq: WHERE Cond                           { Where $2}  
   | GET Number                           { Get $2}
   | ADD URI                              { Add $2}
   | DELETE URI                           { Delete $2}
   

Cond: Number '<' Number                   { Less $1 $3 } 
    | Number '>' Number                   { Greater $1 $3 } 
    | Number '<=' Number                  { LessOr $1 $3 } 
    | Number '>=' Number                  { GreaterOr $1 $3 } 
    | Cond AND Cond                       { And $1 $3}
    | Cond OR Cond                        { Or $1 $3}
    | Equal                               { $1 } 

Equal: Number '=' Number                  { EqInt $1 $3}
     | SUB '=' Link                       {EqString $1 $3}
     | PRED '=' Link                      {EqString $1 $3}
     | OBJ '=' Link                       {EqString $1 $3}
     | OBJ '=' Bool                       {EqString $1 $3}
     | OBJ '=' Lit                        {EqString $1 $3}
     | OBJ '=' Number                     {EqStringInt $1 $3}

Link: URI {$1}
Lit: lit {$1}
Number: int {$1}

File:  UNION File File                { Union $2 $3} 
    |  file                           { File $1}

Bool: TRUE   { $1}
    | FALSE  { $1}   

{ 

data Expr=  Print File Expr 
          | SimplePrint File
          | Where Cond
          | Get Int
          | Add String 
          | Delete String 
         deriving (Show,Eq)

data Cond = Less Int Int 
          | Greater Int Int 
          | LessOr Int Int 
          | GreaterOr Int Int 
          | EqInt Int Int
          | EqString String String
          | EqStringInt String Int
          | EqStringBool String Bool
          | Not Cond 
          | And Cond Cond 
          | Or Cond Cond 
          deriving (Show, Eq)

data File = File String | Union File File  deriving (Show,Eq)

parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

-- main = do
--      contents <- readFile "test.ttl"
--      let tokens = alexScanTokens contents
--      let result = parseCalc tokens
--      print result

}