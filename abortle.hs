{-# HLINT ignore "Redundant bracket" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use foldr" #-}
{-# HLINT ignore "Use map" #-}

module Abortle where

import Control.Monad ()
import Data.Char ()
import Data.Function (on)
import Data.List (intercalate, nub, sort)
import Data.Typeable ()
import Lang (Cond (And, EqBool, EqInt, EqString, Greater, GreaterOr, Less, LessOr, NotEqBool, NotEqInt, NotEqString, Or), Expr (Add, Delete, Finish, Get, Path, Print, SimplePrint, UnionPrint, Where), Files (MoreFiles, OneFile), parseLang)
import Lexer
import Parser (Exp (End, Prefix, Seq, TheBase, Triplets), Link (Link, Notation, Short), Literal (Literal), Object (ObjectBool, ObjectInt, ObjectLink, ObjectString), ObjectList (MultipleObjects, SingleObject), Predicate (Predicate), PredicateList (MultiplePredicates, SinglePredicate), Subject (Subject), Triplet (Triplet), parseInput)
import System.Environment ()
import System.IO ()

sortObjs (ObjectLink ob1) (ObjectLink ob2) = compare ob1 ob2
sortObjs (ObjectInt ob1) (ObjectInt ob2) = compare ob1 ob2
sortObjs (ObjectBool ob1) (ObjectBool ob2) = compare ob1 ob2
sortObjs (ObjectString ob1) (ObjectString ob2) = compare ob1 ob2
sortObjs (ObjectLink ob2) _ = LT
sortObjs (ObjectString ob1) _ = GT
sortObjs (ObjectInt ob1) (ObjectBool ob2) = LT
sortObjs (ObjectInt ob1) (ObjectString ob2) = LT
sortObjs (ObjectBool ob1) (ObjectString ob2) = LT
sortObjs (ObjectBool ob1) _ = GT
sortObjs _ _ = GT

getBase :: Exp -> String
getBase (TheBase (Link a)) = a
getBase (Triplets a) = ""
getBase (Prefix (Literal a) (Link b)) = ""
getBase (Prefix (Literal a) (Short b)) = ""
getBase (Prefix (Literal a) (Notation (Literal c) (Literal d))) = ""
getBase (End a) = getBase a
getBase (Seq a b) = (getBase a) ++ getBase b

getPrefixes :: Exp -> String -> [(String, String)]
getPrefixes (Prefix (Literal a) (Link b)) base = [(a, b)]
getPrefixes (Prefix (Literal a) (Short b)) base = [(a, noRBracket base ++ noLBracket b)]
getPrefixes (TheBase (Link a)) base = []
getPrefixes (Triplets a) base = []
getPrefixes (End a) base = [] ++ getPrefixes a base
getPrefixes (Seq a b) base = (getPrefixes a base) ++ (getPrefixes b base)

getTriplets :: Exp -> [(Triplet)]
getTriplets (Prefix (Literal a) (Link b)) = []
getTriplets (Prefix (Literal a) (Short b)) = []
getTriplets (Prefix (Literal a) (Notation (Literal b) (Literal c))) = []
getTriplets (TheBase (Link a)) = []
getTriplets (Triplets a) = [a]
getTriplets (End a) = getTriplets a
getTriplets (Seq a b) = getTriplets a ++ getTriplets b

getSubjects :: String -> [(String, String)] -> Triplet -> (String, PredicateList)
getSubjects base prefixes (Triplet s@(Subject (Link a)) b) = (fullSubject base prefixes s, b)
getSubjects base prefixes (Triplet s@(Subject (Notation (Literal a) (Literal x))) b) = ((fullSubject base prefixes s), b)
getSubjects base prefixes (Triplet s@(Subject (Short a)) b) = (fullSubject base prefixes s, b)

fullSubject :: String -> [(String, String)] -> Subject -> String
fullSubject base prefixes (Subject (Link a)) = a
fullSubject base prefixes (Subject (Notation (Literal a) (Literal b))) = matchPrefix prefixes a ++ b ++ ">"
fullSubject base prefixes (Subject (Short a)) = noRBracket base ++ noLBracket a

getPredicateList :: String -> [(String, String)] -> PredicateList -> [(String, ObjectList)]
getPredicateList base prefixes (SinglePredicate (Predicate (Link a)) x) = [(a, x)]
getPredicateList base prefixes (SinglePredicate (Predicate (Notation (Literal a) (Literal b))) x) = [(matchPrefix prefixes a ++ b ++ ">", x)]
getPredicateList base prefixes (SinglePredicate (Predicate (Short a)) x) = [(noRBracket base ++ noLBracket a, x)]
getPredicateList base prefixes (MultiplePredicates a b) = getPredicateList base prefixes a ++ getPredicateList base prefixes b

getObjectList :: String -> [(String, String)] -> ObjectList -> [String]
getObjectList base prefixes (SingleObject (ObjectLink (Link a))) = [a]
getObjectList base prefixes (SingleObject (ObjectLink (Short a))) = [(noRBracket base ++ noLBracket a)]
getObjectList base prefixes (SingleObject (ObjectLink (Notation (Literal a) (Literal b)))) = [(matchPrefix prefixes a ++ b ++ ">")]
getObjectList base prefixes (SingleObject (ObjectString (Literal a))) = [a]
getObjectList base prefixes (SingleObject (ObjectBool a)) = [show a]
getObjectList base prefixes (SingleObject (ObjectInt a)) = [show a]
getObjectList base prefixes (MultipleObjects a b) = getObjectList base prefixes a ++ getObjectList base prefixes b

getObjects :: String -> [(String, String)] -> ObjectList -> [Object]
getObjects base prefixes (SingleObject a) = [a]
getObjects base prefixes (MultipleObjects a b) = getObjects base prefixes a ++ getObjects base prefixes b

matchPrefix :: [(String, String)] -> String -> String
matchPrefix [] b = []
matchPrefix (a : as) b
  | (fst a) == b = noRBracket (snd a)
  | otherwise = matchPrefix as b

noBrackets :: String -> String
noBrackets as = noLBracket $ noRBracket as

noLBracket :: String -> String
noLBracket [] = []
noLBracket (a : as)
  | a == '<' = noLBracket as
  | otherwise = a : noLBracket as

noRBracket :: String -> String
noRBracket [] = []
noRBracket (a : as)
  | a == '>' = noRBracket as
  | otherwise = a : noRBracket as

makeFinalTriplet'' :: ((String, String), String) -> (String, String, String)
makeFinalTriplet'' ((a, b), c) = (a, b, c)

makeTriplet :: ((String, String), Object) -> (String, String, Object)
makeTriplet ((a, b), c) = (a, b, c)

getFirst :: (String, String, Object) -> String
getFirst (a, b, c) = a

getSecond :: (String, String, Object) -> String
getSecond (a, b, c) = b

getThird :: (String, String, Object) -> Object
getThird (a, b, c) = c

getSubPred :: (String, String, Object) -> (String, String)
getSubPred (a, b, c) = (a, b)

obToString :: [(String, String)] -> String -> Object -> String
obToString prefixes base (ObjectLink (Link a)) = a
obToString prefixes base (ObjectLink (Short a)) = (noRBracket base ++ noLBracket a)
obToString prefixes base (ObjectLink (Notation (Literal a) (Literal b))) = (matchPrefix prefixes a ++ b ++ ">")
obToString prefixes base (ObjectString (Literal a)) = a
obToString prefixes base (ObjectBool a) = show a
obToString prefixes base (ObjectInt a) = show a

obToStringHelper :: [(String, String)] -> String -> [Object] -> [String]
obToStringHelper prefixes base [] = []
obToStringHelper prefixes base (x : xs) = (obToString prefixes base x : obToStringHelper prefixes base xs)

modifyTriplets :: [[String]] -> [[String]] --remove all brackets from triplet
modifyTriplets [] = []
modifyTriplets (x : xs) = (map noBrackets x) : modifyTriplets xs

accessFiles :: Files -> [String] -- helper for getFiles, dont use
accessFiles (OneFile a) = [a]
accessFiles (MoreFiles a b) = a : accessFiles b

getFiles :: Expr -> [String] -- returns list of all files mentioned in language
getFiles (Print a b) = accessFiles a
getFiles (SimplePrint a) = accessFiles a
getFiles (Where a) = []
getFiles (Get a) = []
getFiles (Add a) = []
getFiles (Delete a) = []
getFiles (UnionPrint a) = accessFiles a
getFiles (Finish a) = getFiles a
getFiles (Path a b) = getFiles a ++ getFiles b

unionFiles :: [String] -> IO () -- take the content of all files and
unionFiles [] = do
  a <- readFile "file.txt"
  let b = lines a
  let c = nub b
  let d = unlines c
  writeFile "output.txt" d
unionFiles (x : xs) = do
  a <- readFile x
  appendFile "file.txt" $ a ++ "\n"
  unionFiles xs

printContents :: [String] -> [Cond] -> IO ()
printContents file constraints = do
  if (length file == 1)
    then -- if its only one file it will write its contents in single.txt
    do
      writeFile "file.txt" ""
    else -- fileContents<-readFile $ file!!0
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
    do
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

evalInt :: Int -> Cond -> Bool --takes value it needs to match, and outputs if condition is matched by expression
evalInt s (Less a b) = s < b
evalInt s (Greater a b) = s > b
evalInt s (LessOr a b) = s <= b
evalInt s (GreaterOr a b) = s >= b
evalInt s (EqInt a b) = s == b
evalInt s (NotEqInt a b) = s /= b
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
evalInt s (And a b) = evalInt s a && evalInt s b
evalInt s (Or a b) = evalInt s a || evalInt s b

evalString :: String -> String -> Cond -> Bool --takes SUB/PRED/OBJ, value it needs to match, and outputs if condition is matched by expression
evalString field s (NotEqString a b) = field == a && s /= b
evalString field s (EqString a b) = field == a && s == b
evalString field s (And (EqString a b) (EqString c d))
  | field == a = s == b
  | field == c = s == d
  | otherwise = False
evalString field s (And (NotEqString a b) (EqString c d))
  | field == a = s /= b
  | field == c = s == d
  | otherwise = False
evalString field s (And (EqString a b) (NotEqString c d))
  | field == a = s == b
  | field == c = s /= d
  | otherwise = False
evalString field s (And (NotEqString a b) (NotEqString c d))
  | field == a = s /= b
  | field == c = s /= d
  | otherwise = False
evalString field s (And _ (EqString a b)) = field == a && s == b
evalString field s (And _ (NotEqString a b)) = field == a && s /= b
evalString field s (And (EqString a b) _) = field == a && s == b
evalString field s (And (NotEqString a b) _) = field == a && s /= b
evalString field s (Or (EqString a b) (EqString c d))
  | field == a && field == c = s == b || s == d
  | field == a = s == b
  | field == c = s == d
  | otherwise = False
evalString field s (Or (NotEqString a b) (NotEqString c d))
  | field == a && field == c = s /= b || s /= d
  | field == a = s /= b
  | field == c = s /= d
  | otherwise = False
evalString field s (Or (NotEqString a b) (EqString c d))
  | field == a && field == c = s /= b || s == d
  | field == a = s /= b
  | field == c = s == d
  | otherwise = False
evalString field s (Or (EqString a b) (NotEqString c d))
  | field == a && field == c = s == b || s /= d
  | field == a = s == b
  | field == c = s /= d
  | otherwise = False
evalString field s (Or _ (EqString a b)) = field == a && s == b
evalString field s (Or (EqString a b) _) = field == a && s == b
evalString field s (Or _ (NotEqString a b)) = field == a && s /= b
evalString field s (Or (NotEqString a b) _) = field == a && s /= b
evalString field s (And a b) = evalString field s a && evalString field s b
evalString field s (Or a b) = evalString field s a || evalString field s b

evalBool :: Bool -> Cond -> Bool --takes bool it needs to match, and outputs if condition is matched by expression
evalBool s (EqBool a b) = s == b
evalBool s (NotEqBool a b) = s /= b
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
evalBool s (And a b) = evalBool s a && evalBool s b
evalBool s (Or a b) = evalBool s a || evalBool s b

makeInt :: String -> Int --reads string to int
makeInt a = read a

splitTriplet :: String -> [String] --splits line into triplet
splitTriplet triplet = words triplet

getValue :: String -> [String] -> String --returns required part of triplet depending on field
getValue field triplet
  | field == "SUB" = triplet !! 0
  | field == "PRED" = triplet !! 1
  | otherwise = triplet !! 2

getFields :: Cond -> [String] --returns field in condition
getFields (Less a b) = [a]
getFields (Greater a b) = [a]
getFields (LessOr a b) = [a]
getFields (GreaterOr a b) = [a]
getFields (NotEqBool a b) = [a]
getFields (NotEqInt a b) = [a]
getFields (NotEqString a b) = [a]
getFields (EqString a b) = [a]
getFields (EqInt a b) = [a]
getFields (EqBool a b) = [a]
getFields (And a b) = getFields a ++ getFields b
getFields (Or a b) = getFields a ++ getFields b

findConditions :: Expr -> [Cond] --returns conditions in query
findConditions (SimplePrint a) = []
findConditions (UnionPrint a) = []
findConditions (Get a) = []
findConditions (Add a) = []
findConditions (Delete a) = []
findConditions (Where a) = [a]
findConditions (Print a b) = findConditions b
findConditions (Finish a) = findConditions a
findConditions (Path a b) = findConditions a ++ findConditions b

main = do
  contents <- readFile "language.txt"
  let tokens = alexScanTokens contents
  let result = parseLang tokens
  let files = getFiles result
  let constraints = findConditions result
  mapM parseTTL files

-- takes ttl and returns expanded triplets

parseTTL file = do
  contents <- readFile file
  let tokens = alexScanTokens contents
  let result = parseInput tokens
  let base = getBase result
  let prefixes = getPrefixes result base
  let triplets = getTriplets result
  let subjPredList = map (getSubjects base prefixes) triplets
  let predObjList = [getPredicateList base prefixes (snd a) | a <- subjPredList]
  let obList1 = [[getObjects base prefixes (snd b) | b <- a] | a <- predObjList]
  let subList = map fst subjPredList
  let predList = map (map fst) predObjList
  let obList2 = (concat obList1)
  let list1 = [(var, v) | (var, var2) <- zip subList predList, v <- var2]
  let list2 = [(var, v) | (var, var2) <- zip list1 obList2, v <- var2]
  let subPredObTupleList = map makeTriplet list2
  let sortedsubPredObTupleList = sort (subPredObTupleList) --string,string,ob
  let final = zip (map getSubPred sortedsubPredObTupleList) (obToStringHelper prefixes base (map getThird sortedsubPredObTupleList))
  let strings = [a ++ " " ++ b ++ " " ++ c ++ " ." | (a, b, c) <- map makeFinalTriplet'' final]
  mapM print strings

--let output = intercalate "\n" strings

-- mapM print output