{
module Language where 
import Lexer 
import Data.Typeable
import Data.List
import Data.Function (on)
import Data.Char
import System.Environment
import System.IO
import Control.Monad
import Data.List
import Data.Typeable
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
   | Exp ';'          { End $1}
   | Exp Seq ';'      { Seq $1 $2}       
  
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
          | EqInt String Int
          | EqBool String Bool
          | NotEqString String String
          | NotEqInt String Int  
          | NotEqBool String Bool
          | And Cond Cond 
          | Or Cond Cond 
          deriving (Show, Eq)

data Files = OneFile String | MoreFiles String Files  deriving (Show,Eq)

noBrackets::String->String --remove brackets from URIs
noBrackets as = noLBracket $ noRBracket as

noLBracket::String->String
noLBracket []=[]
noLBracket (a:as) | a=='<' =noLBracket as
                  | otherwise = a: noLBracket as

noRBracket::String->String
noRBracket []=[]
noRBracket (a:as) | a=='>' =noRBracket as
                  | otherwise = a: noRBracket as

modifyTriplets::[[String]]->[[String]] --remove all brackets from triplet
modifyTriplets []=[]
modifyTriplets (x:xs)=(map noBrackets x):modifyTriplets xs

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
unionFiles []= do
                  a<-readFile "file.txt"
                  let b=lines a
                  let c=nub b
                  let d=unlines c
                  writeFile "output.txt" d
unionFiles (x:xs) = do 
            a<-readFile x
            appendFile "file.txt" $ a ++ "\n"
            unionFiles xs

printContents::[String]->[Cond]->IO()
printContents file constraints = do 
                                    if(length file==1)
                                    -- if its only one file it will write its contents in single.txt
                                        then do 
                                        writeFile "file.txt" ""
                                        -- fileContents<-readFile $ file!!0
                                        -- let line=lines fileContents
                                        -- let strings=map splitTriplet line
                                        -- let triplets=modifyTriplets strings
                                        -- let constraint=constraints!!0
                                        -- let fields=nub (getFields constraint)
                                        -- if(length fields==1)
                                        --     then do 
                                        --         nee triplets (fields!!0) constraint
                                        -- else do 
                                        --         if(length fields==2)
                                        --             then do 
                                        --                let options=anthi triplets (fields!!0) constraint
                                        --                let result=anthi options (fields!!1) constraint
                                        --                print result
                                        --         else do print "oops"    
                                     -- appendFile "file.txt" (correctOutput!!0)
                                    -- if there are multiple files it will write all of their contents in more.txt
                                    else do
                                        writeFile "file.txt" ""
                                        unionFiles file

-- nee::[[String]]->String->Cond->IO() --returns triplet that match the given condition
-- nee [] field cond = return ()
-- nee (x:xs) field cond = do
--                     let value=getValue field x
--                     if(value!!0/='"' && value!!0/='<')
--                     then do 
--                             let boolValue=read "True" :: Bool
--                             let intValue=read "1" :: Int
--                             let shit= read value
--                             print (typeOf shit)
--                             if ((typeOf shit)==(typeOf intValue))
--                             then do
--                                     print "s"
--                                     let bool=evalInt shit cond 
--                                     if (bool==True)
--                                         then do
--                                              print x
--                                     else do nee xs field cond
--                             else do 
--                                     if(typeOf shit==typeOf boolValue)
--                                         then do        
--                                             let bool2=evalBool shit cond
--                                             if (bool2==True)
--                                                 then do 
--                                                     print x
--                                             else do nee xs field cond
--                                     else do nee xs field cond
--                     else do
--                             let bool3=evalString field value cond
--                             if(bool3==True)
--                             then do
--                                 print xs
--                             else do
--                                 nee xs field cond


-- anthi::[[String]]->String->Cond->[[String]] --returns triplet that match thr given condition
-- anthi [] field cond = []
-- anthi (x:xs) field cond = do
--                             let value=getValue field x
--                             let bool=evalString field value cond 
--                             if (bool==True)
--                                 then do
--                                     x:anthi xs field cond
--                             else do anthi xs field cond

evalInt::Int ->Cond->Bool --takes value it needs to match, and outputs if condition is matched by expression
evalInt s (Less a b)= s<b
evalInt s (Greater a b)=s>b
evalInt s (LessOr a b)=s<=b
evalInt s (GreaterOr a b)=s>=b
evalInt s (EqInt a b)=s==b
evalInt s (NotEqInt a b)= s/=b
-- evalInt s (And (EqInt a b) (EqInt c d)) = s==b && s==d
-- evalInt s (And (NotEqInt a b) (NotEqInt c d)) = s/=b && s/=d     
-- evalInt s (And (NotEqInt a b) (EqInt c d)) =s/=b && s==d
-- evalInt s (And (EqInt a b) (NotEqInt c d))=s==b&&s==d
-- evalInt s (And _ (EqInt a b)) = s==b
-- evalInt s (And (NotEqInt a b) _ ) = s/=b
-- evalInt s (And _ (EqInt a b)) =  s==b
-- evalInt s (And (NotEqInt a b) _ ) = s/=b
-- evalInt s (Or (EqInt a b) (EqInt c d))  =s==b || s==d 
-- evalInt s (Or (NotEqInt a b) (NotEqInt c d)) = s/=b || s/=d 
-- evalInt s (Or (NotEqInt a b) (EqInt c d))   = s/=b || s==d 
-- evalInt s (Or (EqInt a b) (NotEqInt c d))    = s==b || s/=d 
-- evalInt s (Or _ (EqInt a b)) =  s==b
-- evalInt s (Or (NotEqInt a b) _ ) = s/=b
-- evalInt s (Or _ (EqInt a b)) =  s==b
-- evalInt s (Or (NotEqInt a b) _ ) =  s/=b
evalInt s (And a b)=evalInt s a && evalInt s b
evalInt s (Or a b)=evalInt s a || evalInt s b

evalString::String->String->Cond->Bool --takes SUB/PRED/OBJ, value it needs to match, and outputs if condition is matched by expression
evalString field s (NotEqString a b)= field==a && s/=b
evalString field s (EqString a b) = field==a && s==b
evalString field s (And (EqString a b) (EqString c d)) | field==a = s==b 
                                                       | field==c = s==d
                                                       | otherwise = False
evalString field s (And (NotEqString a b) (EqString c d)) | field==a = s/=b 
                                                       | field==c = s==d
                                                       | otherwise = False
evalString field s (And (EqString a b) (NotEqString c d)) | field==a = s==b 
                                                       | field==c = s/=d
                                                       | otherwise = False
evalString field s (And (NotEqString a b) (NotEqString c d)) | field==a = s/=b 
                                                       | field==c = s/=d
                                                       | otherwise = False
evalString field s (And _ (EqString a b)) = field==a && s==b 
evalString field s (And _ (NotEqString a b))  = field==a && s/=b
evalString field s (And (EqString a b) _)  = field==a && s==b
evalString field s (And (NotEqString a b) _)  = field==a && s/=b
evalString field s (Or (EqString a b) (EqString c d)) | field == a && field==c = s==b || s==d
                                                      | field == a = s==b
                                                      | field == c = s==d
                                                      | otherwise = False
evalString field s (Or (NotEqString a b) (NotEqString c d)) | field == a && field==c = s/=b || s/=d
                                                      | field == a = s/=b
                                                      | field == c = s/=d
                                                      | otherwise = False
evalString field s (Or (NotEqString a b) (EqString c d)) | field == a && field==c = s/=b || s==d
                                                      | field == a = s/=b
                                                      | field == c = s==d
                                                      | otherwise = False
evalString field s (Or (EqString a b) (NotEqString c d)) | field == a && field==c = s==b || s/=d
                                                      | field == a = s==b
                                                      | field == c = s/=d
                                                      | otherwise = False
evalString field s (Or _ (EqString a b)) = field==a && s==b
evalString field s (Or (EqString a b) _) = field==a && s==b
evalString field s (Or _ (NotEqString a b)) = field==a && s/=b
evalString field s (Or (NotEqString a b) _) = field==a && s/=b 
evalString field s (And a b)=evalString field s a && evalString field s b
evalString field s (Or a b)=evalString field s a || evalString field s b

evalBool::Bool->Cond->Bool  --takes bool it needs to match, and outputs if condition is matched by expression
evalBool s (EqBool a b) =  s==b
evalBool s (NotEqBool a b) = s/=b
-- evalBool s (And (EqBool a b) (EqBool c d)) = s==b && s==d
-- evalBool s (And (NotEqBool a b) (NotEqBool c d)) = s/=b && s/=d     
-- evalBool s (And (NotEqBool a b) (EqBool c d)) =s/=b && s==d
-- evalBool s (And (EqBool a b) (NotEqBool c d))=s==b&&s==d
-- evalBool s (And _ (EqBool a b)) = s==b
-- evalBool s (And (NotEqBool a b) _ ) = s/=b
-- evalBool s (And _ (EqBool a b)) =  s==b
-- evalBool s (And (NotEqBool a b) _ ) = s/=b
-- evalBool s (Or (EqBool a b) (EqBool c d))  =s==b || s==d 
-- evalBool s (Or (NotEqBool a b) (NotEqBool c d)) = s/=b || s/=d 
-- evalBool s (Or (NotEqBool a b) (EqBool c d))   = s/=b || s==d 
-- evalBool s (Or (EqBool a b) (NotEqBool c d))    = s==b || s/=d 
-- evalBool s (Or _ (EqBool a b)) =  s==b
-- evalBool s (Or (NotEqBool a b) _ ) = s/=b
-- evalBool s (Or _ (EqBool a b)) =  s==b
-- evalBool s (Or (NotEqBool a b) _ ) =  s/=b
evalBool s (And a b)=evalBool s a && evalBool s b
evalBool s (Or a b)=evalBool s a || evalBool s b


makeInt::String->Int --reads string to int
makeInt a= read a

splitTriplet::String->[String] --splits line into triplet
splitTriplet triplet = words triplet

getValue:: String->[String]->String --returns required part of triplet depending on field 
getValue field triplet | field=="SUB" = triplet!!0
                       | field=="PRED"= triplet!!1
                       | otherwise = triplet !! 2

getFields::Cond->[String] --returns field in condition
getFields (Less a b)=[a]
getFields (Greater a b)=[a]
getFields (LessOr a b)=[a]
getFields (GreaterOr a b)=[a]
getFields (NotEqBool a b)=[a]
getFields (NotEqInt a b)=[a]
getFields (NotEqString a b)=[a]
getFields (EqString a b)=[a]
getFields (EqInt a b)=[a] 
getFields (EqBool a b)=[a]
getFields (And a b)=getFields a  ++getFields b 
getFields (Or a b)=getFields a ++getFields b 

findConditions::Expr->[Cond] --returns conditions in query
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

match::[String]->[String]->[(Bool,String)]
match [] [] = []
match (a:as) (b:bs) | a==b =match as bs
                    | otherwise = (False,a):match as bs

-- main = do
--      contents <- readFile "language.txt"
--      let tokens = alexScanTokens contents
--      let result = parseCalc tokens
--      let files = getFiles result
--      let constraints = findConditions result
--     --  print constraints
--     --  printContents files constraints
--      a <- readFile "output.txt"
--      let c = lines a
--      b <- readFile "file.txt"
--      let d=lines b
--      print $ match c d
}