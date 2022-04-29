module Main where

import Control.Monad ()
import Data.Char (toLower,toUpper)
import Data.Function (on)
import Data.List (intercalate, nub, sort, isPrefixOf,sortBy)
import Data.Typeable (typeOf)
import Lang (Cond (And, EqBool, EqInt, EqString, Greater, GreaterOr, Less, LessOr, NotEqBool, NotEqInt, NotEqString, Or), Expr ( Print, Tasks, Union), Files (MoreFiles, OneFile), Instr (Instruction, Instructions), Seq (Linking, Where), parseLang)
import Lexer
import Parser (Exp (End, Prefix, Seq, TheBase, Triplets), Link (Link, Notation, Short), Literal (Literal), Object (ObjectBool, ObjectInt, ObjectLink, ObjectString), ObjectList (MultipleObjects, SingleObject), Predicate (Predicate), PredicateList (MultiplePredicates, SinglePredicate), Subject (Subject), Triplet (Triplet), parseInput)
import System.Environment (getArgs)
import System.IO ()

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

-- gets base from file
getBase :: Exp -> String
getBase (TheBase (Link a)) = a
getBase (Triplets a) = ""
getBase (Prefix (Literal a) (Link b)) = ""
getBase (Prefix (Literal a) (Short b)) = ""
getBase (Prefix (Literal a) (Notation (Literal c) (Literal d))) = ""
getBase (End a) = getBase a
getBase (Seq a b) = (getBase a) ++ getBase b

-- gets a list of all prefixes
getPrefixes :: Exp -> String -> [(String, String)]
getPrefixes (Prefix (Literal a) (Link b)) base = [(a, b)]
getPrefixes (Prefix (Literal a) (Short b)) base = [(a, noRBracket base ++ noLBracket b)]
getPrefixes (TheBase (Link a)) base = []
getPrefixes (Triplets a) base = []
getPrefixes (End a) base = [] ++ getPrefixes a base
getPrefixes (Seq a b) base = (getPrefixes a base) ++ (getPrefixes b base)

-- returns a list of all triplets
getTriplets :: Exp -> [(Triplet)]
getTriplets (Prefix (Literal a) (Link b)) = []
getTriplets (Prefix (Literal a) (Short b)) = []
getTriplets (Prefix (Literal a) (Notation (Literal b) (Literal c))) = []
getTriplets (TheBase (Link a)) = []
getTriplets (Triplets a) = [a]
getTriplets (End a) = getTriplets a
getTriplets (Seq a b) = getTriplets a ++ getTriplets b

-- links all subjects with their predicate lists
getSubjects :: String -> [(String, String)] -> Triplet -> (String, PredicateList)
getSubjects base prefixes (Triplet s@(Subject (Link a)) b) = (fullSubject base prefixes s, b)
getSubjects base prefixes (Triplet s@(Subject (Notation (Literal a) (Literal x))) b) = ((fullSubject base prefixes s), b)
getSubjects base prefixes (Triplet s@(Subject (Short a)) b) = (fullSubject base prefixes s, b)

-- expands subject
fullSubject :: String -> [(String, String)] -> Subject -> String
fullSubject base prefixes (Subject (Link a)) = a
fullSubject base prefixes (Subject (Notation (Literal a) (Literal b))) = matchPrefix prefixes a ++ b ++ ">"
fullSubject base prefixes (Subject (Short a)) = noRBracket base ++ noLBracket a

-- links each predicate with its object list
getPredicateList :: String -> [(String, String)] -> PredicateList -> [(String, ObjectList)]
getPredicateList base prefixes (SinglePredicate (Predicate (Link a)) x) = [(a, x)]
getPredicateList base prefixes (SinglePredicate (Predicate (Notation (Literal a) (Literal b))) x) = [(matchPrefix prefixes a ++ b ++ ">", x)]
getPredicateList base prefixes (SinglePredicate (Predicate (Short a)) x) = [(noRBracket base ++ noLBracket a, x)]
getPredicateList base prefixes (MultiplePredicates a b) = getPredicateList base prefixes a ++ getPredicateList base prefixes b

-- expands each object list
getObjectList :: String -> [(String, String)] -> ObjectList -> [String]
getObjectList base prefixes (SingleObject (ObjectLink (Link a))) = [a]
getObjectList base prefixes (SingleObject (ObjectLink (Short a))) = [(noRBracket base ++ noLBracket a)]
getObjectList base prefixes (SingleObject (ObjectLink (Notation (Literal a) (Literal b)))) = [(matchPrefix prefixes a ++ b ++ ">")]
getObjectList base prefixes (SingleObject (ObjectString (Literal a))) = [a]
getObjectList base prefixes (SingleObject (ObjectBool a)) = [show a]
getObjectList base prefixes (SingleObject (ObjectInt a)) = [show a]
getObjectList base prefixes (MultipleObjects a b) = getObjectList base prefixes a ++ getObjectList base prefixes b

-- gets all objects
getObjects :: String -> [(String, String)] -> ObjectList -> [Object]
getObjects base prefixes (SingleObject a) = [a]
getObjects base prefixes (MultipleObjects a b) = getObjects base prefixes a ++ getObjects base prefixes b

-- returns subject from tuple
getFirst :: (String, String, Object) -> String
getFirst (a, b, c) = a

-- returns predicate from tuple
getSecond :: (String, String, Object) -> String
getSecond (a, b, c) = b

-- returns object from tuple
getThird :: (String, String, Object) -> Object
getThird (a, b, c) = c

-- expands using prefixes
matchPrefix :: [(String, String)] -> String -> String
matchPrefix [] b = []
matchPrefix (a : as) b
  | (fst a) == b = noRBracket (snd a)
  | otherwise = matchPrefix as b

-- adds brackets to links and a new line at the end
addBrackets ::String ->String
addBrackets x| isPrefixOf "http:" x = "<"++x++">"
             | x=="."=x++"\n"
             | otherwise = x 

-- removes brackets
noBrackets :: String -> String
noBrackets as = noLBracket $ noRBracket as

-- removes the left bracket
noLBracket :: String -> String
noLBracket [] = []
noLBracket (a : as)
  | a == '<' = noLBracket as
  | otherwise = a : noLBracket as

-- removes the right bracket
noRBracket :: String -> String
noRBracket [] = []
noRBracket (a : as)
  | a == '>' = noRBracket as
  | otherwise = a : noRBracket as

-- returns a triplet as a tuple of 3
makeFinalTriplet:: ((String, String), String)-> (String, String, String)
makeFinalTriplet ((a,b),c)  = (a,b, c)

-- matches object with its predicate and subject
makeTriplet :: ((String, String), Object) -> (String, String, Object)
makeTriplet ((a, b), c) = (a, b, c)

-- returns a pair of the subject with its predicate
getSubPred :: (String, String, Object) -> (String, String)
getSubPred (a, b, c) = (a, b)

-- removes brackets from a list of triplets
remBrack :: [[String]] -> [[String]] --remove all brackets from triplet
remBrack [] = []
remBrack (x : xs) = (map noBrackets x) : remBrack xs

-- returns all files from AST
accessFiles :: Files -> [String] -- helper for getFiles
accessFiles (OneFile a) = [a]
accessFiles (MoreFiles a b) = a : accessFiles b

-- gets all the files from expression
getFiles :: Expr -> [String] -- returns list of all files mentioned in language
getFiles (Union a) = accessFiles a
getFiles (Print a) = accessFiles a
getFiles (Tasks a b) = getFiles a

-- decides whether or not an int condition is being respected
evalInt :: Int -> Cond -> Bool 
evalInt s (Less a b) = s < b
evalInt s (Greater a b) = s > b
evalInt s (LessOr a b) = s <= b
evalInt s (GreaterOr a b) = s >= b
evalInt s (EqInt a b) = s == b
evalInt s (NotEqInt a b) = s /= b
evalInt s (And (Less a b) (Less c d)) = s<b && s<d
evalInt s (And (Less a b) (LessOr c d))  =s<b&&s<=d
evalInt s (And (Less a b) (Greater c d))  = s<b && s>d
evalInt s (And (Less a b) (GreaterOr c d)) =s<b&&s>=d
evalInt s (And (Less a b) (EqInt c d))  =s<b&&s==d
evalInt s (And (Less a b) (NotEqInt c d)) =s<=b&&s/=d
evalInt s (And (LessOr a b) (Less c d))= s<=b && s<d
evalInt s (And (LessOr a b) (LessOr c d))=s<=b&&s<=d
evalInt s (And (LessOr a b) (Greater c d))= s<=b && s>d
evalInt s (And (LessOr a b) (GreaterOr c d))=s<=b&&s>=d
evalInt s (And (LessOr a b) (EqInt c d))=s<=b&&s==d
evalInt s (And (LessOr a b) (NotEqInt c d))=s<=b&&s/=d
evalInt s (And (GreaterOr a b) (Less c d))= s>=b && s<d
evalInt s (And (GreaterOr a b) (LessOr c d))=s>=b&&s<=d
evalInt s (And (GreaterOr a b) (Greater c d))= s>=b && s>d
evalInt s (And (GreaterOr a b) (GreaterOr c d))=s>=b&&s>=d
evalInt s (And (GreaterOr a b) (EqInt c d))=s>=b&&s==d
evalInt s (And (GreaterOr a b) (NotEqInt c d))=s>=b&&s/=d
evalInt s (And (Greater a b) (Less c d))= s>b && s<d
evalInt s (And (Greater a b) (LessOr c d))=s>b&&s<=d
evalInt s (And (Greater a b) (Greater c d))= s>b && s>d
evalInt s (And (Greater a b) (GreaterOr c d))=s>b&&s>=d
evalInt s (And (Greater a b) (EqInt c d))=s>b&&s==d
evalInt s (And (Greater a b) (NotEqInt c d))=s>b&&s/=d
evalInt s (And (EqInt a b) (Less c d))= s==b && s<d
evalInt s (And (EqInt a b) (LessOr c d))=s==b&&s<=d
evalInt s (And (EqInt a b) (Greater c d))= s==b && s>d
evalInt s (And (EqInt a b) (GreaterOr c d))=s==b&&s>=d
evalInt s (And (EqInt a b) (EqInt c d))=s==b&&s==d
evalInt s (And (EqInt a b) (NotEqInt c d))=s==b&&s/=d
evalInt s (And (NotEqInt a b) (Less c d))= s/=b && s<d
evalInt s (And (NotEqInt a b) (LessOr c d))=s/=b&&s<=d
evalInt s (And (NotEqInt a b) (Greater c d))= s/=b && s>d
evalInt s (And (NotEqInt a b) (GreaterOr c d))=s/=b&&s>=d
evalInt s (And (NotEqInt a b) (EqInt c d))=s/=b&&s==d
evalInt s (And (NotEqInt a b) (NotEqInt c d))=s/=b&&s/=d
evalInt s (Or (Less a b) (Less c d))= s<b || s<d
evalInt s (Or (Less a b) (LessOr c d))=s<b||s<=d
evalInt s (Or (Less a b) (Greater c d))= s<b || s>d
evalInt s (Or (Less a b) (GreaterOr c d))=s<b||s>=d
evalInt s (Or (Less a b) (EqInt c d))=s<b||s==d
evalInt s (Or (Less a b) (NotEqInt c d))=s<b||s/=d
evalInt s (Or (LessOr a b) (Less c d))= s<=b || s<d
evalInt s (Or (LessOr a b) (LessOr c d))=s<=b||s<=d
evalInt s (Or (LessOr a b) (Greater c d))= s<=b || s>d
evalInt s (Or (LessOr a b) (GreaterOr c d))=s<=b||s>=d
evalInt s (Or (LessOr a b) (EqInt c d))=s<=b||s==d
evalInt s (Or (LessOr a b) (NotEqInt c d))=s<=b||s/=d
evalInt s (Or (GreaterOr a b) (Less c d))= s>=b || s<d
evalInt s (Or (GreaterOr a b) (LessOr c d))=s>=b||s<=d
evalInt s (Or (GreaterOr a b) (Greater c d))= s>=b || s>d
evalInt s (Or (GreaterOr a b) (GreaterOr c d))=s>=b||s>=d
evalInt s (Or (GreaterOr a b) (EqInt c d))=s>=b||s==d
evalInt s (Or (GreaterOr a b) (NotEqInt c d))=s>=b||s/=d
evalInt s (Or (Greater a b) (Less c d))= s>b || s<d
evalInt s (Or (Greater a b) (LessOr c d))=s>b||s<=d
evalInt s (Or (Greater a b) (Greater c d))= s>b || s>d
evalInt s (Or (Greater a b) (GreaterOr c d))=s>b||s>=d
evalInt s (Or (Greater a b) (EqInt c d))=s>b||s==d
evalInt s (Or (Greater a b) (NotEqInt c d))=s>b||s/=d
evalInt s (Or (EqInt a b) (Less c d))= s==b || s<d
evalInt s (Or (EqInt a b) (LessOr c d))=s==b||s<=d
evalInt s (Or (EqInt a b) (Greater c d))= s==b || s>d
evalInt s (Or (EqInt a b) (GreaterOr c d))=s==b||s>=d
evalInt s (Or (EqInt a b) (EqInt c d))=s==b||s==d
evalInt s (Or (EqInt a b) (NotEqInt c d))=s==b||s/=d
evalInt s (Or (NotEqInt a b) (Less c d))= s/=b || s<d
evalInt s (Or (NotEqInt a b) (LessOr c d))=s/=b||s<=d
evalInt s (Or (NotEqInt a b) (Greater c d))= s/=b || s>d
evalInt s (Or (NotEqInt a b) (GreaterOr c d))=s/=b||s>=d
evalInt s (Or (NotEqInt a b) (EqInt c d))=s/=b||s==d
evalInt s (Or (NotEqInt a b) (NotEqInt c d))=s/=b||s/=d
evalInt s (And (Less a b) _)= s<b
evalInt s (And (LessOr a b) _)=s<=b
evalInt s (And (Greater a b) _)= s>b 
evalInt s (And (GreaterOr a b) _)=s>=b
evalInt s (And (EqInt a b) _)=s==b
evalInt s (And (NotEqInt a b) _)=s/=b
evalInt s (Or (Less a b) _)= s<b 
evalInt s (Or (LessOr a b) _)=s<=b
evalInt s (Or (Greater a b) _)= s>b
evalInt s (Or (GreaterOr a b) _)=s>=b
evalInt s (Or (EqInt a b) _)=s==b
evalInt s (Or (NotEqInt a b)_)=s/=b
evalInt s (And _ (Less a b))= s<b
evalInt s (And _ (LessOr a b))=s<=b
evalInt s (And _ (Greater a b))= s>b 
evalInt s (And _ (GreaterOr a b))=s>=b
evalInt s (And _ (EqInt a b))=s==b
evalInt s (And _ (NotEqInt a b))=s/=b
evalInt s (Or _ (Less a b))= s<b 
evalInt s (Or _ (LessOr a b))=s<=b
evalInt s (Or _ (Greater a b))= s>b
evalInt s (Or _ (GreaterOr a b))=s>=b
evalInt s (Or _ (EqInt a b))=s==b
evalInt s (Or _ (NotEqInt a b))=s/=b
evalInt s (And a b) = evalInt s a && evalInt s b
evalInt s (Or a b) = evalInt s a || evalInt s b
evalInt s _ =False


-- decides whether or not a string condition is being respected
evalString :: String -> String -> Cond -> Bool 
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
evalString field s (And _ (EqString a b)) = field == a && s == b
evalString field s (And _ (NotEqString a b)) = field == a && s /= b
evalString field s (And (EqString a b) _) = field == a && s == b
evalString field s (And (NotEqString a b) _) = field == a && s /= b
evalString field s (Or _ (EqString a b)) = field == a && s == b
evalString field s (Or (EqString a b) _) = field == a && s == b
evalString field s (Or _ (NotEqString a b)) = field == a && s /= b
evalString field s (Or (NotEqString a b) _) = field == a && s /= b
evalString field s (And a b) = evalString field s a && evalString field s b
evalString field s (Or a b) = evalString field s a || evalString field s b
evalString field s _ =False

-- decides whether or not a bool condition is being respected
evalBool :: Bool -> Cond -> Bool --takes bool it needs to match, and outputs if condition is matched by expression
evalBool s (EqBool a b) = s == b
evalBool s (NotEqBool a b) = s /= b
evalBool s (And (EqBool a b) (EqBool c d)) = False
evalBool s (And (EqBool a b) (NotEqBool c d)) = False
evalBool s (And (NotEqBool a b) (NotEqBool c d)) = False
evalBool s (And (NotEqBool a b) (EqBool c d)) = False
evalBool s (Or (EqBool a b) (EqBool c d)) = False
evalBool s (Or (EqBool a b) (NotEqBool c d)) = False
evalBool s (Or (NotEqBool a b) (NotEqBool c d)) = False
evalBool s (Or (NotEqBool a b) (EqBool c d)) = False
evalBool s (And (EqBool a b) _) = evalBool s (EqBool a b) 
evalBool s (Or (EqBool a b) _) = evalBool s (EqBool a b)
evalBool s (And (NotEqBool a b) _) = evalBool s (NotEqBool a b) 
evalBool s (Or (NotEqBool a b) _) = evalBool s (NotEqBool a b)
evalBool s (And _ (NotEqBool a b) ) = evalBool s (NotEqBool a b) 
evalBool s (Or _ (NotEqBool a b)) = evalBool s (NotEqBool a b) 
evalBool s (And _ (EqBool a b) ) = evalBool s (EqBool a b) 
evalBool s (Or _ (EqBool a b)) = evalBool s (EqBool a b) 
evalBool s (And a b) = evalBool s a && evalBool s b
evalBool s (Or a b) = evalBool s a || evalBool s b
evalBool s _ =False

-- split line into triplet
splitTriplet :: String -> [String] 
splitTriplet = words

-- returns required part of triplet depending on field
getValue :: String -> [String] -> String 
getValue field triplet
  | field == "SUB" = triplet !!0
  | field == "PRED" = triplet !! 1
  | otherwise = triplet !! 2

-- returns field in condition
getFields :: Cond -> [String] 
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

-- returns all conditions from the query
findConditions :: Seq -> [Cond]
findConditions (Linking a b c) = [] 
findConditions (Where a) = [a]

-- looks for the conditions in the language
getConditions :: Expr -> [Cond]
getConditions (Tasks a b) = findConditions b ++ getConditions a
getConditions (Print a) = []
getConditions (Union a) = []

-- returns all the linking conditions in the query
findLinks::Seq->[(String,String,String)]
findLinks (Where a)=[]
findLinks (Linking a b c)=(a,b, head $ accessFiles c):[]

-- looks for the linking conditions in the tree
getLinks::Expr->[(String,String,String)]
getLinks (Tasks a b)=getLinks a++findLinks b
getLinks (Print a)=[]
getLinks (Union a)=[]

-- returns a list of instructins to follow
getInstructions :: Instr -> [Expr]
getInstructions (Instruction a) = a : []
getInstructions (Instructions a b) = [a] ++ getInstructions b

-- adds a new line after each triplet
newLine::[String]->[String]
newLine [] = []
newLine (x:xs) | x=="."=(x++"\n"):newLine xs
               | otherwise = x: newLine xs

-- transforms "True" to "true"
lowerBools::[String]->[String]
lowerBools []=[]
lowerBools (x:xs) | x=="False" || x=="True" =map toLower x :lowerBools xs
                  | otherwise =x: lowerBools xs

-- makes first letter of word uppercase
upFirst::String->String
upFirst s = toUpper (head s) : drop 1 s

-- facilitates conditions with 2 fields
andOr :: Cond -> String
andOr (Or a b) = "or"
andOr (And a b) = "and"

-- executes all instructions with conditions
executeConditions :: IO [String] -> Cond -> IO [[String]]
executeConditions file constraint = do
  line <- file
  let strings = map splitTriplet line
  let triplets = remBrack strings
  let fields = nub (getFields constraint)
  if (length fields == 1)
    then do
      conditionTo triplets (head fields) constraint
    else
      if (length fields == 2)
        then do
          let decision = andOr constraint
          if (decision == "and")
            then do
              options <- conditionTo triplets (head fields) constraint
              result <-conditionTo options (fields !! 1) constraint
              return result
            else do
              options1 <- conditionTo triplets (head fields) constraint
              options2 <- conditionTo triplets (fields !! 1) constraint
              return (options1 ++ options2)
        else do
          return []

-- executes all instructions involving linking
executeLinking:: IO [String]->(String,String,String)->IO [[String]]
executeLinking file (field,linkedField,linkedFile)=do
  contents <- file
  let strings = map splitTriplet contents
  let triplets = remBrack strings
  let parsedFile = parseFiles (linkedFile:[])
  result<-parsedFile
  let linkedStrings= map splitTriplet result
  let linkedTriplets= remBrack linkedStrings
  let listOfResults=mapM (linkingTo linkedTriplets linkedField field) triplets
  strip<-listOfResults
  let output=map(map addBrackets) (filter (\e->e/=[]) strip)
  return (output)

-- helper function for executeLinking where it executes triplet by triplet
linkingTo::[[String]]->String->String->[String]-> IO [String] -- returns triplet that match the given linking
linkingTo [] a b c = return []
linkingTo (x:xs) linkedField field triplet= do
  let linkedValue=getValue linkedField x
  let value=getValue field triplet
  if(value==linkedValue)
    then do
      return triplet
    else do
      linkingTo xs linkedField field triplet

-- helper function for executeConditions where it executes triplet by triplet
conditionTo :: [[String]] -> String -> Cond -> IO [[String]] -- returns triplet that match the given condition
conditionTo [] field cond = return []
conditionTo (x : xs) field cond = do
  let v = getValue field x
  if (head v /= '"' && head v /= 'h')
    then do
      if (v=="True" || v=="False")
        then do
          let reading=upFirst v
          let value = read reading :: Bool
          let bool = evalBool value cond
          if (bool)
            then do
              next <- conditionTo xs field cond
              return ([x] ++ next)
            else do
              conditionTo xs field cond
        else do
          let value = read v :: Int
          let bool = evalInt value cond
          if (bool)
            then do
              next <- conditionTo xs field cond
              return ([x] ++ next)
            else do
              conditionTo xs field cond
    else do
      let bool = evalString field v cond
      if (bool)
        then do
          next <- conditionTo xs field cond
          return ([x] ++ next)
        else do
          conditionTo xs field cond

-- evaluates what to do with the input concerning the conditions and linkings
evaluate ::[IO [FilePath]]->[[Cond]]->[[(String,String,String)]]->IO [[String]]
evaluate [] [] [] =return []
evaluate (files:fileList) (cond:condList) (link:linkList) = do
  if(cond==[]&&link==[])
    then do 
      output<-files
      let line=map words output
      let result=map newLine (line)
      next<-evaluate fileList condList linkList
      return(result++next)
      else do
  if(cond/=[])
    then do 
      result<-executeConditions files (head cond)
      let output=map(map addBrackets)result
      next<-evaluate fileList condList linkList
      return(output++next)
    else 
      do
        result<-executeLinking files (head link)
        next<-evaluate fileList condList linkList
        return(result++next)

-- main function which outputs desired result
main:: IO [[()]]
main = do
  file<-getArgs
  contents <- readFile $ head file
  let tokens = alexScanTokens contents
  let result = parseLang tokens
  let instructionsList = getInstructions result --[Instructions]
  let conditions = map getConditions instructionsList --[[Cond]]
  let links=map getLinks instructionsList
  let files=map getFiles instructionsList -- [[String]]
  let parsedFiles= map parseFiles files --IO[String]
  results<- evaluate parsedFiles  conditions links --[[String]]
  let sorted = map merge (finalSort(map splitToTriples results))
  let final = map lowerBools (map newLine sorted)
  let output=  (nub final)
  mapM (mapM putStr) output

-- parsed an unions a list of files
parseFiles :: [FilePath] -> IO [String]
parseFiles [] = return []
parseFiles (x : xs) = do
  result <- parseTTL (readFile x)
  next <- parseFiles xs
  return (result ++ next)

-- expands turtle triplets
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
  let final = zip (map getSubPred sortedsubPredObTupleList) (obToStringHelper prefixes base (map (getThird) sortedsubPredObTupleList))
  let strings = [a ++ " " ++ b ++ " " ++ c ++ " .\n" | (a, b, c) <- map makeFinalTriplet final]
  return strings


splitToTriples :: [String] -> (String,String,String)
splitToTriples x = (head x,x!!1,x!!2)


merge ::  (String,String,String)-> [String]
merge (a,b,c) = (a:b:c:["."])


--get type of object
getType :: String -> String
getType s
  | (head s == '\"') = "String"
  | (head s == 'T') || (head s == 'F') = "Bool"
  | head s == '<' = "Link"
  | otherwise = "Int"

sortSubs :: (String, String, String) -> (String,String, String) -> Ordering
sortSubs (a, b, c) (d, e, f)| a==d = sortPreds (a, b, c) (d, e, f)
                            |otherwise = compare a d
                            
sortPreds :: (String, String, String) -> (String,String, String) -> Ordering
sortPreds (a, b, c) (d, e, f)| b==e = sortObjs (a, b, c) (d, e, f)
                             |otherwise = compare a d

sortObjs :: (String, String, String) -> (String, String, String) -> Ordering
sortObjs (a, b, s1) (d, e, s2)
  | (getType s1 == "Link" && getType s2 == "Link") = compare s1 s2
  | (getType s1 == "Int" && getType s2 == "Int") = compare (read s1 :: Int) (read s2 :: Int)
  | (getType s1 == "String" && getType s2 == "String") = compare s1 s2
  | (getType s1 == "Bool" && getType s2 == "Bool") = compare (read s1 :: Bool) (read s2 :: Bool)
  | (getType s1 == "Link") = GT
  | (getType s2 == "Link") = LT
  | (getType s1 == "String") = LT
  | (getType s2 == "String") = GT
  | (getType s1 == "Int" && getType s2 == "Bool") = GT
  | (getType s1 == "Bool" && getType s2 == "Int") = LT
  | otherwise = LT

--sorts final triple
finalSort :: [(String, String, String)] -> [(String, String, String)] 
finalSort xs = sortBy sortSubs xs
