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
import Data.Typeable (typeOf)
import Lang (Cond (And, EqBool, EqInt, EqString, Greater, GreaterOr, Less, LessOr, NotEqBool, NotEqInt, NotEqString, Or), Expr ( Print, Tasks, Union), Files (MoreFiles, OneFile), Instr (Instruction, Instructions), Seq (Linking, Where), parseLang)
import Lexer
import Parser (Exp (End, Prefix, Seq, TheBase, Triplets), Link (Link, Notation, Short), Literal (Literal), Object (ObjectBool, ObjectInt, ObjectLink, ObjectString), ObjectList (MultipleObjects, SingleObject), Predicate (Predicate), PredicateList (MultiplePredicates, SinglePredicate), Subject (Subject), Triplet (Triplet), parseInput)
import System.Environment ()
import System.IO ()

sortObjs :: Object -> Object -> Ordering --DEFINATELY 1000000% WORKS 
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
getFiles (Union a) = accessFiles a
getFiles (Print a) = accessFiles a
getFiles (Tasks a b) = getFiles a

evalInt :: Int -> Cond -> Bool --takes value it needs to match, and outputs if condition is matched by expression
evalInt s (Less a b) = s < b
evalInt s (Greater a b) = s > b
evalInt s (LessOr a b) = s <= b
evalInt s (GreaterOr a b) = s >= b
evalInt s (EqInt a b) = s == b
evalInt s (NotEqInt a b) = s /= b
evalInt s (And a b) = evalInt s a && evalInt s b
evalInt s (Or a b) = evalInt s a || evalInt s b
evalInt s _ = False

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
evalString field s _ = False

evalBool :: Bool -> Cond -> Bool --takes bool it needs to match, and outputs if condition is matched by expression
evalBool s (EqBool a b) = s == b
evalBool s (NotEqBool a b) = s /= b
evalBool s (And a b) = evalBool s a && evalBool s b
evalBool s (Or a b) = evalBool s a || evalBool s b
evalBool s _ = False

makeInt :: String -> Int --reads string to int
makeInt = read

splitTriplet :: String -> [String] --splits line into triplet
splitTriplet = words

getValue :: String -> [String] -> String --returns required part of triplet depending on field
getValue field triplet
  | field == "SUB" = head triplet
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

findConditions :: Seq -> [Cond]
findConditions (Linking a b c) = [] --returns conditions in query
findConditions (Where a) = [a]

getConditions :: Expr -> [Cond]
getConditions (Tasks a b) = findConditions b ++ getConditions a
getConditions (Print a) = []
getConditions (Union a) = []

findLinks::Seq->[(String,String,String)]
findLinks (Where a)=[]
findLinks (Linking a b c)=(a,b, head $ accessFiles c):[]

getLinks::Expr->[(String,String,String)]
getLinks (Tasks a b)=getLinks a++findLinks b
getLinks (Print a)=[]
getLinks (Union a)=[]

getInstructions :: Instr -> [Expr]
getInstructions (Instruction a) = a : []
getInstructions (Instructions a b) = [a] ++ getInstructions b

andOr :: Cond -> String
andOr (Or a b) = "or"
andOr (And a b) = "and"

executeConditions :: IO [String] -> Cond -> IO [[String]]
executeConditions file constraint = do
  line <- file
  let strings = map splitTriplet line
  let triplets = modifyTriplets strings
  let fields = nub (getFields constraint)
  if (length fields == 1)
    then do
      nee triplets (head fields) constraint
    else
      if (length fields == 2)
        then do
          let decision = andOr constraint
          if (decision == "and")
            then do
              options <- nee triplets (head fields) constraint
              nee options (fields !! 1) constraint
            else do
              options1 <- nee triplets (head fields) constraint
              options2 <- nee triplets (fields !! 1) constraint
              return (options1 ++ options2)
        else do
          print "no"
          return [[]]

executeLinking:: IO [String]->[(String,String,String)]->IO [[String]]
executeLinking file [(field,linkedField,linkedFile)]=do
  contents <- file
  -- let line=lines contents
  let strings = map splitTriplet contents
  let triplets = modifyTriplets strings
  contents2<- readFile (linkedFile)
  let line2=lines contents2
  let linkedStrings= map splitTriplet line2
  let linkedTriplets= modifyTriplets linkedStrings
  let listOfResults=mapM (anthi linkedTriplets linkedField field) triplets
  strip<-listOfResults
  return strip

anthi::[[String]]->String->String->[String]-> IO [String]
anthi [] a b c = return []
anthi (x:xs) linkedField field triplet= do
  let linkedValue=getValue linkedField x
  let value=getValue field triplet
  if(value==linkedValue)
    then do
      return triplet
    else do
      anthi xs linkedField field triplet

nee :: [[String]] -> String -> Cond -> IO [[String]] --returns triplet that match the given condition
nee [] field cond = return []
nee (x : xs) field cond = do
  let v = getValue field x
  if (head v /= '"' && head v /= 'h')
    then do
      if (head v == 'T' || head v == 'F')
        then do
          let value = read v :: Bool
          let bool = evalBool value cond
          if (bool)
            then do
              next <- nee xs field cond
              return ([x] ++ next)
            else do
              nee xs field cond
        else do
          let value = read v :: Int
          let bool = evalInt value cond
          if (bool)
            then do
              next <- nee xs field cond
              return ([x] ++ next)
            else do
              nee xs field cond
    else do
      let bool = evalString field v cond
      if (bool)
        then do
          next <- nee xs field cond
          return ([x] ++ next)
        else do
          nee xs field cond

evaluate ::[IO [FilePath]]->[[Cond]]->[[(String,String,String)]]->IO [[String]]
evaluate [] [] [] =return []
evaluate (files:fileList) (cond:condList) (link:linkList) = do
  if(cond/=[])
    then do 
      result<-executeConditions files (head cond)
      next<-evaluate fileList condList linkList
      return(result++next)
    else 
      do
        result<-executeLinking files link
        next<-evaluate fileList condList linkList
        return(result++next)



main = do
  contents <- readFile "language.txt"
  let tokens = alexScanTokens contents
  let result = parseLang tokens
  let instructionsList = getInstructions result --[Instructions]
  let conditions = map getConditions instructionsList --[[Cond]]
  let links=map getLinks instructionsList
  let files=map getFiles instructionsList -- [[String]]
  let parsedFiles= map parseFiles files --IO[String]
  results<- evaluate parsedFiles  conditions links
  let stuff=map unwords results
  print (typeOf stuff)
  mapM (putStrLn) stuff

parseFiles :: [FilePath] -> IO [String]
parseFiles [] = return []
parseFiles (x : xs) = do
  result <- parseTTL (readFile x)
  next <- parseFiles xs
  return (result ++ next)

unionFiles :: [String] -> [String] -- works
unionFiles [] = return ""
unionFiles (x : xs) = do
  bs <- unionFiles xs
  return (x ++ bs)

parseTTL :: IO String -> IO [String] -- works
parseTTL content = do
  input <- content
  let tokens = alexScanTokens input
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
  return strings