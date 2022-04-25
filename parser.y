{ 
module Parser where 
import Lexer 
import Data.Typeable
import Data.List
import Data.Function (on)
import Data.Char
}

%name parseInput 
%tokentype { Token } 
%error { parseError }
%token  
    prefix   { TokenPrefix p }
    base     { TokenBase p }
    lit      { TokenLiteral p $$ } 
    http     { TokenURI p $$ }
    short    { TokenShort p $$ }
    '.'      { TokenDot p }
    ','      { TokenComma p }
    ';'      { TokenSemiColon p }
    ':'      { TokenColon p }
    int      { TokenInt p $$ }  
    true     { TokenTrue p $$}
    false    { TokenFalse p $$}                      

%left '.' ',' ';'
%%
Start: Triplet                { Triplets $1 }
     | base Link              { TheBase $2 }
     | prefix Lit ':' Link   { Prefix $2 $4 }
     | Start '.' Start        { Seq $1 $3 }
     | Start '.'              { End $1 }

Triplet:    Subject PredList                     { Triplet $1 $2 }
Subject:    Link                                 { Subject $1 }

PredList:   Predicate ObjList                    { SinglePredicate $1 $2 }
        |   PredList ';' PredList                { MultiplePredicates $1 $3 }

Predicate:  Link                                 { Predicate $1 }
       
ObjList:    Object                               { SingleObject $1 }
       |    ObjList ',' ObjList                  { MultipleObjects $1 $3 }

Object:     Link                                 { ObjectLink $1 } 
       |    Lit                                  { ObjectString $1 }
       |    int                                  { ObjectInt $1 }
       |    true                                 { ObjectBool $1}
       |    false                                { ObjectBool $1}

Link:       http                                 { Link $1 }
     |      short                                { Short $1 }
     |      Lit ':' Lit                          { Notation $1 $3 }
Lit:        lit                                  { Literal $1 }

{
parseError :: [Token] -> a
parseError [] = error "No Tokens"
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++ " " ++ show b

data Exp = TheBase Link
         | Prefix Literal Link
         | Triplets Triplet 
         | Seq Exp Exp
         | End Exp deriving (Show,Eq)

data Triplet = Triplet Subject PredicateList deriving (Show,Eq)

data Subject = Subject Link  deriving (Show,Eq)

data PredicateList = SinglePredicate Predicate ObjectList 
                   | MultiplePredicates PredicateList PredicateList deriving (Show,Eq)

data Predicate = Predicate Link  deriving (Show,Eq)

data ObjectList = SingleObject Object  
                | MultipleObjects ObjectList ObjectList    deriving (Show,Eq)

data Object = ObjectLink Link
              | ObjectInt Int
              | ObjectBool Bool 
              | ObjectString Literal   deriving (Show,Eq,Ord)

data Link = Link String | Short String | Notation Literal Literal deriving (Show, Eq,Ord)
data Literal = Literal String deriving (Show, Eq,Ord)

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
getBase (Triplets a)=""
getBase (Prefix (Literal a) (Link b))=""
getBase (Prefix (Literal a) (Short b))=""
getBase (Prefix (Literal a) (Notation (Literal c)(Literal d)))=""
getBase (End a) = getBase a
getBase (Seq a b) = (getBase a) ++ (getBase b)

getPrefixes :: Exp->String -> [(String, String)]
getPrefixes (Prefix (Literal a) (Link b)) base =[(a,b)]
getPrefixes (Prefix (Literal a) (Short b)) base= [(a,noRBracket base ++ noLBracket b)]
getPrefixes (TheBase (Link a)) base = []
getPrefixes (Triplets a) base=[]
getPrefixes (End a) base =[]++getPrefixes a base
getPrefixes (Seq a b) base = (getPrefixes a base) ++ (getPrefixes b base)

getTriplets :: Exp -> [(Triplet)]
getTriplets (Prefix (Literal a) (Link b))=[]
getTriplets (Prefix (Literal a) (Short b))=[]
getTriplets (Prefix (Literal a) (Notation (Literal b)(Literal c)))=[]
getTriplets (TheBase (Link a)) = []
getTriplets (Triplets a)=[a]
getTriplets (End a) =getTriplets a
getTriplets (Seq a b)=getTriplets a ++ getTriplets b 

getSubjects::String->[(String,String)]->Triplet->(String,PredicateList)
getSubjects base prefixes (Triplet s@(Subject (Link a)) b)=(fullSubject base prefixes s,b)
getSubjects base prefixes (Triplet s@(Subject (Notation (Literal a) (Literal x))) b)=((fullSubject base prefixes s),b)
getSubjects base prefixes (Triplet s@(Subject (Short a)) b)=(fullSubject base prefixes s,b)

fullSubject::String-> [(String,String)]->Subject->String
fullSubject base prefixes (Subject (Link a))=a
fullSubject base prefixes (Subject (Notation (Literal a)(Literal b)))=matchPrefix prefixes a ++ b ++">"
fullSubject base prefixes (Subject (Short a)) = noRBracket base++noLBracket a 

getPredicateList::String->[(String,String)]->PredicateList->[(String,ObjectList)]
getPredicateList base prefixes (SinglePredicate (Predicate (Link a)) x)=[(a,x)]
getPredicateList base prefixes (SinglePredicate (Predicate (Notation (Literal a)(Literal b) ))x)=[(matchPrefix prefixes a ++ b++">",x)]
getPredicateList base prefixes (SinglePredicate (Predicate (Short a)) x)=[(noRBracket base ++ noLBracket a,x)]
getPredicateList base prefixes (MultiplePredicates a b)= getPredicateList base prefixes a ++ getPredicateList base prefixes b

getObjectList:: String-> [(String,String)] -> ObjectList -> [String]
getObjectList base prefixes (SingleObject (ObjectLink (Link a)))=[ a]
getObjectList base prefixes (SingleObject (ObjectLink (Short a)))=[(noRBracket base ++ noLBracket a)]
getObjectList base prefixes (SingleObject (ObjectLink (Notation (Literal a) (Literal b))))= [(matchPrefix prefixes a ++ b++">")]
getObjectList base prefixes (SingleObject (ObjectString (Literal a)) ) =[a] 
getObjectList base prefixes (SingleObject (ObjectBool a)) = [show a]
getObjectList base prefixes (SingleObject (ObjectInt a))=[show a]
getObjectList base prefixes (MultipleObjects a b)=getObjectList base prefixes a++getObjectList base prefixes b

getObjects:: String-> [(String,String)] -> ObjectList -> [Object]
getObjects base prefixes (SingleObject a)=[ a]
getObjects base prefixes (MultipleObjects a b)=getObjects base prefixes a++getObjects base prefixes b

matchPrefix::[(String,String)]->String->String
matchPrefix [] b=[]
matchPrefix (a:as) b | (fst a)==b = noRBracket (snd a)
                     | otherwise = matchPrefix as b

noBrackets::String->String
noBrackets as = noLBracket $ noRBracket as

noLBracket::String->String
noLBracket []=[]
noLBracket (a:as) | a=='<' =noLBracket as
                  | otherwise = a: noLBracket as

noRBracket::String->String
noRBracket []=[]
noRBracket (a:as) | a=='>' =noRBracket as
                  | otherwise = a: noRBracket as


makeFinalTriplet'':: ((String, String), String)-> (String, String, String)
makeFinalTriplet'' ((a,b),c)  =(a,b,c)
                         


makeTriplet::((String,String),Object)->(String, String, Object)
makeTriplet ((a,b),c) = (a,b,c)

getFirst:: (String,String,Object)->String
getFirst (a,b,c) = a

getSecond::  (String,String,Object)->String
getSecond (a,b,c) = b

getThird::  (String,String,Object)->Object
getThird (a,b,c) = c

getSubPred:: (String,String,Object)-> (String,String)
getSubPred (a,b,c) = (a,b)

obToString:: [(String,String)] -> String -> Object -> String
obToString prefixes base (ObjectLink (Link a))= a
obToString prefixes base (ObjectLink (Short a))= (noRBracket base ++ noLBracket a)
obToString prefixes base (ObjectLink (Notation (Literal a) (Literal b))) = (matchPrefix prefixes a ++ b++">")
obToString prefixes base (ObjectString (Literal a)) =a
obToString prefixes base (ObjectBool a) = show a
obToString prefixes base (ObjectInt a) =show a

obToStringHelper:: [(String,String)] -> String -> [Object] -> [String]
obToStringHelper prefixes base [] = []
obToStringHelper prefixes base (x:xs) = (obToString prefixes base x :obToStringHelper prefixes base xs)

-- main = do
--      contents <- readFile "bar.ttl"
--      let tokens = alexScanTokens contents
--      let result = parseCalc tokens
--      let base = getBase result
--      let prefixes =getPrefixes result base
--      let triplets =getTriplets result
--      let subjPredList = map (getSubjects base prefixes) triplets
--      let predObjList = [getPredicateList base prefixes (snd a)|a<-subjPredList]
--      let obList1 =  [[getObjects base prefixes (snd b)|b<-a]|a<-predObjList]
--      let subList = map fst subjPredList
--      let predList = map (map fst) predObjList
--      let obList2 = (concat obList1)
--      let list1=[(var,v)|(var,var2)<-zip subList predList, v<-var2]
--      let list2=[(var,v)|(var,var2)<-zip list1 obList2, v<-var2]
--      let subPredObTupleList= map makeTriplet list2
--      let sortedsubPredObTupleList = sort (subPredObTupleList) --string,string,ob
--      let final = zip (map getSubPred sortedsubPredObTupleList) (obToStringHelper prefixes base (map getThird sortedsubPredObTupleList))
--      --let final = zip (map getSubPred sortedsubPredObTupleList) (map (\a -> obToString (prefixes) (base)) (map getThird sortedsubPredObTupleList))
--      let strings = [ a++" "++b++" "++c++" ."| (a,b,c)<- map makeFinalTriplet'' final]
--      let output= intercalate "\n" strings
--      writeFile "output2.txt" output 
} 


