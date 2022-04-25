{
module Lang where 
import Lexer
}

%name parseLang 
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
  NOT                  { TokenNot p}
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
  ADD                  { TokenAdd p}
  DELETE               { TokenDelete p}
  RESTRICT             { TokenRestrict p}  
  GET                  { TokenGet p}
  URI                  { TokenURIValue p $$}
  file                 { TokenFile p $$}
 

%right '<' '<=' '>=' '>'
%left AND OR '=' NOT
%%

Exp: PRINT FROM File  { SimplePrint $3}
   | PRINT FROM UNION File { UnionPrint $4}
   | Exp ';'          { Finish $1}
   | Exp Seq ';'      { Path $1 $2}       
  
Seq: WHERE Cond                           { Where $2}  
   | GET Number                           { Get $2}
   | ADD URI                              { Add $2}
   | DELETE URI                           { Delete $2}

Cond: SUB '=' Uri                     { EqString $1 $3}
    | PRED '=' Uri                    { EqString $1 $3}
    | OBJ '=' Uri                     { EqString $1 $3}
    | OBJ '>' Number                   { Greater $1 $3 } 
    | OBJ '<=' Number                  { LessOr $1 $3 }       
    | OBJ '>=' Number                  { GreaterOr $1 $3 } 
    | OBJ '<' Number                   { Less $1 $3 } 
    | OBJ '=' Bool                     { EqBool $1 $3}
    | OBJ '=' Lit                      { EqString $1 $3}
    | OBJ '=' Number                   { EqInt $1 $3}
    | SUB NOT Uri                     { NotEqString $1 $3}
    | PRED NOT Uri                    { NotEqString $1 $3}
    | OBJ NOT Uri                     { NotEqString $1 $3}
    | OBJ NOT Lit                      { NotEqString $1 $3}
    | OBJ NOT Number                   { NotEqInt $1 $3}
    | OBJ NOT Bool                     { NotEqBool $1 $3}
    | Cond AND Cond                    { And $1 $3}
    | Cond OR Cond                     { Or $1 $3}

Uri: URI {$1}
Lit: lit {$1}
Number: int {$1}

File:   file                     { OneFile $1}
    |   file File                { MoreFiles  $1 $2} 

Bool: TRUE   { $1}
    | FALSE  { $1}   

{ 
parseError :: [Token] -> a
parseError [] = error "No Tokens"
parseError (b : bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++ " " ++ show b

data Expr=  Print Files Expr 
          | Finish Expr
          | Path Expr Expr
          | SimplePrint Files
          | UnionPrint Files
          | Where Cond
          | Get Int
          | Add String 
          | Delete String 
         deriving (Show,Eq)

data Cond = Less String Int 
          | Greater String Int 
          | LessOr String Int 
          | GreaterOr String Int 
          | EqString String String
          | EqInt String Int
          | EqBool String Bool
          | NotEqString String String
          | NotEqInt String Int  
          | NotEqBool String Bool
          | And Cond Cond 
          | Or Cond Cond 
          deriving (Show, Eq)

data Files = OneFile String | MoreFiles String Files  deriving (Show,Eq)
}