{
module LangParser where
import Lexer
import System.Environment
import System.IO
import Control.Monad
import Data.List
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
  GET                  { TokenGet p}
  URI                  { TokenURIValue p $$}
  file                 { TokenFile p $$}
 

%right '<' '<=' '>=' '>'
%left AND OR '='
%%

Exp: PRINT FROM File  { SimplePrint $3}
   | PRINT FROM UNION File { UnionPrint $4}
   | Exp ';'          { End $1}
   | Exp Seq ';'      { Seq $1 $2}       
  
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
     | OBJ '=' Bool                       {EqStringBool $1 $3}
     | OBJ '=' Lit                        {EqString $1 $3}
     | OBJ '=' Number                     {EqStringInt $1 $3}

Link: URI {$1}
Lit: lit {$1}
Number: int {$1}

File:   file                     { OneFile $1}
    |   file File                { MoreFiles  $1 $2} 

Bool: TRUE   { $1}
    | FALSE  { $1}   

{ 

data Expr=  Print Files Expr 
          | End Expr
          | Seq Expr Expr
          | SimplePrint Files
          | UnionPrint Files
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

data Files = OneFile String | MoreFiles String Files  deriving (Show,Eq)

accessFiles::Files->[String]
accessFiles (OneFile a) =[a]
accessFiles (MoreFiles a b)=[a] ++ accessFiles b

getFiles::Expr->[String]
getFiles (Print a b)=accessFiles a
getFiles (SimplePrint a)=accessFiles a
getFiles (Where a)=[]
getFiles (Get a)=[]
getFiles (Add a)=[]
getFiles (Delete a)=[]
getFiles (UnionPrint a)=accessFiles a
getFiles (End a)=getFiles a
getFiles (Seq a b)=getFiles a++ getFiles b

unionFiles::[String]->IO ()
unionFiles []= return ()
unionFiles (x:xs) = do 
            a<-readFile x
            appendFile "more.txt" "\n"
            appendFile "more.txt" a
            b<- readFile "more.txt"
            let c=lines b
            let d=nub c
            sequence (map (writeFile "more.txt") d )
            unionFiles xs

parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

printContents file = do 
                        if(length file==1)
                        -- if its only one file it will write its contents in single.txt
                            then do 
                            writeFile "one.txt" ""
                            l<-readFile $ file!!0
                            appendFile "one.txt" l
                        -- if there are multiple files it will write all of their contents in more.txt
                        else do
                            unionFiles file


main = do
     contents <- readFile "language.txt"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     let output = getFiles result
     printContents output

}