{
module LangParser where
import Lexer
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
  PRED                 { TokenPred p}
  SUB                  { TokenSub p}
  OBJ                  { TokenObj p}
  AND                  { TokenAnd p}
  OR                   { TokenOr p}
  FROM                 { TokenFrom p}
  NOT                  { TokenNot p}
  ADD                  { TokenAdd p}
  DELETE               { TokenDelete p}
  CHANGE               { TokenChange p}
  RESTRICT             { TokenRestrict p}  
  SORT                 { TokenSort p}
  GET                  { TokenGet p}
  URI                  { TokenURIValue p $$}
  file                 { TokenFile p $$}
  SELECT               { TokenSelect p}

%right '<' '<=' '>=' '>'
%left AND OR '='
%%

Start: PRINT FROM File Seq ';'            { Print $3 $4}
     | PRINT FROM File ';'                { SimplePrint $3}
  
Seq: WHERE Cond                           { Where $2}  

Cond: Number '<' Number                   { Less $1 $3 } 
    | Number '>' Number                   { Greater $1 $3 } 
    | Number '<=' Number                  { LessOr $1 $3 } 
    | Number '>=' Number                  { GreaterOr $1 $3 } 
    | Cond AND Cond                       { And $1 $3}
    | Cond OR Cond                        { Or $1 $3}
    | Equal                               { $1 } 

Equal: 
    --  Field '=' URI                      { Equal $1 $3}
    --  | URI '=' Field                      { Equal $1 $3}
    --  | OBJ '=' lit                     { Equal $1 $3}
    --  | lit '=' OBJ                     { Equal $1 $3}
      Number '=' Number                  { Equal $1 $3}
    --  | Field '=' Field                    { Equal $1 $3}
    --  | Field '=' OBJ                      { Equal $1 $3}
    --  | OBJ '=' Field                      { Equal $1 $3}

Field: SUB                                { $1 }                     
    | PRED                                { $1 }

Number: int {$1}

File: file                           { File $1}
    | UNION File File                { Union $2 $3}

Type: int                            { IntType $1}     
    | Bool                           { BoolType $1}
    | file                           { File $1}

Bool: TRUE   { $1}
    | FALSE  { $1}

--  Expr:   
--     |      --  '(' Expr ')'                   { $2 }         
--     -- | NOT Cond                       { Not $2} 
--     -- | ADD URI file                       { Add $2}  
--     -- | DELETE URI file                    { Delete $2}
--     -- | CHANGE URI file                    { Change $2} 
--     -- | RESTRICT '(' Number ',' Number ')'   { Restrict ($3, $5)}   
--     -- | GET Number                         { Get $2}   
--   --  | Type                               {$1}
    

{ 

data Expr=  Print String Expr 
          | SimplePrint String
          | Union String String 
          | Where Cond
          | And Cond Cond 
          | Not Cond 
          | Or Cond Cond
          | Get Int
          | Add String 
          | Delete String 
          | Change String
          | Restrict (Int, Int)
          | BoolType Bool 
          | IntType Int
          | File String

         deriving (Show,Eq)

data Cond = Less Int Int | Greater Int Int | LessOr Int Int | GreaterOr Int Int | Equal Int Int deriving (Show, Eq)

-- data File =File String deriving (Show,Eq)


parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

main = do
     contents <- readFile "test.ttl"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     print result

}