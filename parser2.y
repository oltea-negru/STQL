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
   

-- Cond: 
--      Number '<' Number                   { Less $1 $3 } 
--     | Number '>' Number                   { Greater $1 $3 } 
--     | Number '<=' Number                  { LessOr $1 $3 }       
--     | Number '>=' Number                  { GreaterOr $1 $3 } 
--     | Cond AND Cond                       { And $1 $3}
--     | Cond OR Cond                        { Or $1 $3}
--     | Equal                               { $1 } 

-- Equal: Number '=' Number                  { EqInt $1 $3}
--      | SUB '=' Link                       {EqString $1 $3}
--      | PRED '=' Link                      {EqString $1 $3}
--      | OBJ '=' Link                       {EqString $1 $3}
--      | OBJ '=' Bool                       {EqStringBool $1 $3}
--      | OBJ '=' Lit                        {EqString $1 $3}
--      | OBJ '=' Number                     {EqStringInt $1 $3}

Cond: Field '<' Number                   { Less $1 $3 } 
    | Field '>' Number                   { Greater $1 $3 } 
    | Field '<=' Number                  { LessOr $1 $3 }       
    | Field '>=' Number                  { GreaterOr $1 $3 } 
    | SUB '=' Link                       {EqString $1 $3}
    | PRED '=' Link                      {EqString $1 $3}
    | OBJ '=' Link                       {EqString $1 $3}
    | OBJ '=' Bool                       {EqStringBool $1 $3}
    | OBJ '=' Lit                        {EqString $1 $3}
    | OBJ '=' Number                     {EqStringInt $1 $3}
    | Cond AND Cond                       { And $1 $3}
    | Cond OR Cond                        { Or $1 $3}

Field: SUB {$1}
     | PRED {$1}
     | OBJ {$1}
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

data Cond = Less String Int 
          | Greater String Int 
          | LessOr String Int 
          | GreaterOr String Int 
          | EqString String String
          | EqStringInt String Int
          | EqStringBool String Bool
          | And Cond Cond 
          | Or Cond Cond 
          deriving (Show, Eq)

data Files = OneFile String | MoreFiles String Files  deriving (Show,Eq)

accessFiles::Files->[String] -- helper for getFiles, dont use
accessFiles (OneFile a) =[a]
accessFiles (MoreFiles a b)=[a] ++ accessFiles b

getFiles::Expr->[String] -- returns list of all files mentioned in language
getFiles (Print a b)=accessFiles a
getFiles (SimplePrint a)=accessFiles a
getFiles (Where a)=[]
getFiles (Get a)=[]
getFiles (Add a)=[]
getFiles (Delete a)=[]
getFiles (UnionPrint a)=accessFiles a
getFiles (End a)=getFiles a
getFiles (Seq a b)=getFiles a++ getFiles b

unionFiles::[String]->IO () -- take the content of all files and                            
unionFiles []= return ()    -- writes them in "file.txt" (deletes duplicates xo)
unionFiles (x:xs) = do 
            a<-readFile x
            appendFile "file.txt" $ a ++ "\n"
            b<- readFile "file.txt"
            let c=lines b
            let d=nub c
            sequence (map (writeFile "file.txt") d )
            unionFiles xs

printContents::[String]->[Cond]->IO()
printContents file constraints = do 
                                    if(length file==1)
                                    -- if its only one file it will write its contents in single.txt
                                        then do 
                                        writeFile "file.txt" ""
                                        l<-readFile $ file!!0
                                        let line=lines l
                                        let triplets=map splitTriplet line
                                        let constraint=constraints!!0
                                        let fields=nub (getFields constraint)
                                        if(length fields==1)
                                            then do 
                                                nee triplets (fields!!0) constraint
                                        else do return ()
                                     -- appendFile "file.txt" (correctOutput!!0)
                                    -- if there are multiple files it will write all of their contents in more.txt
                                    else do
                                        unionFiles file

nee::[[String]]->String->Cond->IO()
nee [] field cond = return ()
nee (x:xs) field cond = do
                    let value=getValue field x
                    let bool=evalString field value cond 
                    print value
                    if (bool==True)
                        then do
                             appendFile "file.txt" (unwords x)
                    else do print bool
                    nee xs field cond

evalInt::Int->Cond->Bool
evalInt s (Less a b)= s<b
evalInt s (Greater a b)=s>b
evalInt s (LessOr a b)=s<=b
evalInt s (GreaterOr a b)=s>=b
evalInt s (EqStringInt a b)=s==b
evalInt s (And a b)=evalInt s a && evalInt s b
evalInt s (Or a b)=evalInt s a || evalInt s b

evalString::String->String->Cond->Bool
evalString field s (EqString a b) = field==a && s==b
evalString field s (And (EqString a b) (EqString c d)) | field==a = s==b 
                                                       | field==c = s==d
                                                       | otherwise = False
evalString field s (And _ (EqString a b)) | field==a =s==b
                                          | otherwise = False 
evalString field s (And (EqString a b) _) | field==a =s==b
                                          | otherwise = False
evalString field s (Or (EqString a b) (EqString c d)) | field == a && field==b = s==b || s==d
                                                      | field == a = s==b
                                                      | field == b = s==d
                                                      | otherwise = False
evalString field s (Or _ (EqString a b))| field == a = s==b
                                        | otherwise = False
evalString field s (Or (EqString a b) _)| field == a = s==b
                                        | otherwise = False 
evalString field s (And a b)=evalString field s a && evalString field s b
evalString field s (Or a b)=evalString field s a || evalString field s b

evalBool::Bool->Cond->Bool
evalBool s (EqStringBool a b)=s==b
evalBool s (And a b)=evalBool s a && evalBool s b
evalBool s (Or a b)=evalBool s a || evalBool s b



makeInt::String->Int
makeInt a= read a

splitTriplet::String->[String]
splitTriplet triplet = words triplet

getValue:: String->[String]->String
getValue field triplet | field=="SUB" = triplet!!0
                       | field=="PRED"= triplet!!1
                       | otherwise = triplet !! 2


getFields::Cond->[String]
getFields (Less a b)=[a]
getFields (Greater a b)=[a]
getFields (LessOr a b)=[a]
getFields (GreaterOr a b)=[a]
getFields (EqString a b)=[a]
getFields (EqStringInt a b)=[a]
getFields (EqStringBool a b)=[a]
getFields (And a b)=getFields a  ++getFields b 
getFields (Or a b)=getFields a ++getFields b 

findConditions::Expr->[Cond]
findConditions (SimplePrint a)=[]
findConditions (UnionPrint a)=[]
findConditions (Get a)=[]
findConditions (Add a)=[]
findConditions (Delete a)=[]
findConditions (Where a)= [a]
findConditions (Print a b)=findConditions b
findConditions (End a)=findConditions a
findConditions (Seq a b)=findConditions a++findConditions b

parseError :: [Token] -> a
parseError [] = error "error somewhere"
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

main = do
     contents <- readFile "language.txt"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     let files = getFiles result
--solution problem 1      printContents files
     let constraints = findConditions result
     print constraints
     printContents files constraints
     

}