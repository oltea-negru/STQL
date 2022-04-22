{ 
module Parser where 
import Lexer 
import Data.Typeable
import Data.List
<<<<<<< HEAD
import Data.Function (on)
=======
>>>>>>> f0b0a7c53bd711685b96a4dcfdd3f4a085196f21
import Data.Char
}

%name parseCalc 
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
     | prefix Lit ':' Link    { PrefixURI $2 $4 }
     | prefix Lit ':' Short   { Prefix $2 $4 }
     | Start '.' Start        { Seq $1 $3 }
     | Start '.'              { End $1 }

Triplet:    Subject PredList                     { Triplet $1 $2 }
Subject:    Link                                 { Subject $1 }
       |    Notation                             { Sub $1 }
       |    Short                                { S $1}

PredList:   Predicate ObjList                    { SinglePredicate $1 $2 }
        |   PredList ';' PredList                { MultiplePredicates $1 $3 }

Predicate:  Link                                 { Predicate $1 }
         |  Notation                             { Pred $1 }
         |  Short                                { P $1 }
       
ObjList:    Object                               { SingleObject $1 }
       |    ObjList ',' ObjList                  { MultipleObjects $1 $3 }

Object:     Link                                 { ObjectLink $1 } 
       |    Lit                                  { ObjectString $1 }
       |    int                                  { ObjectInt $1 }
       |    Short                                { ObjectShort $1 }
       |    Notation                             { ObjectNotation $1}
       |    true                                 { ObjectBool $1}
       |    false                                { ObjectBool $1}

Link:       http                                 { Link $1 }
Short:      short                                { Short $1 }
Notation:   Lit ':' Lit                          { Notation $1 $3 }
Lit:        lit                                  { Literal $1 }

{
parseError :: [Token] -> a
parseError [] = error "No Tokens"
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++ " " ++ show b

data Exp = TheBase Link
         | PrefixURI Literal Link
         | Prefix Literal Short
         | Triplets Triplet 
         | Seq Exp Exp
         | End Exp deriving (Show,Eq)

data Triplet = Triplet Subject PredicateList deriving (Show,Eq)

data Subject = Subject Link 
             | Sub Notation 
             | S Short deriving (Show,Eq)

data PredicateList = SinglePredicate Predicate ObjectList 
                   | MultiplePredicates PredicateList PredicateList deriving (Show,Eq)

data Predicate = Predicate Link 
               | Pred Notation 
               | P Short deriving (Show,Eq)

data ObjectList = SingleObject Object  
                | MultipleObjects ObjectList ObjectList    deriving (Show,Eq)

data Object = ObjectLink Link
              | ObjectShort Short 
              | ObjectNotation Notation
              | ObjectInt Int
              | ObjectBool Bool 
              | ObjectString Literal   deriving (Show,Eq)

data Link = Link String deriving (Show, Eq)
data Short = Short String deriving (Show, Eq)
data Notation = Notation Literal Literal deriving (Show, Eq)
data Literal = Literal String deriving (Show, Eq)

getBase :: Exp -> String
getBase (TheBase (Link a)) = a
getBase (Triplets a)=""
getBase (PrefixURI (Literal a) (Link b))=""
getBase (Prefix (Literal a) (Short b))=""
getBase (End a) = getBase a
getBase (Seq a b) = (getBase a) ++ (getBase b)

getPrefixes :: Exp->String -> [(String, String)]
getPrefixes (PrefixURI (Literal a) (Link b)) base =[(a,b)]
getPrefixes (Prefix (Literal a) (Short b)) base= [(a,noRBracket base ++ noLBracket b)]
getPrefixes (TheBase (Link a)) base = []
getPrefixes (Triplets a) base=[]
getPrefixes (End a) base =[]++getPrefixes a base
getPrefixes (Seq a b) base = (getPrefixes a base) ++ (getPrefixes b base)

getTriplets :: Exp -> [(Triplet)]
getTriplets (PrefixURI (Literal a) (Link b))=[]
getTriplets (Prefix (Literal a) (Short b))=[]
getTriplets (TheBase (Link a)) = []
getTriplets (Triplets a)=[a]
getTriplets (End a) =getTriplets a
getTriplets (Seq a b)=getTriplets a ++ getTriplets b 

getSubjects::String->[(String,String)]->Triplet->(String,PredicateList)
getSubjects base prefixes (Triplet s@(Subject (Link a)) b)=(fullSubject base prefixes s,b)
getSubjects base prefixes (Triplet s@(Sub (Notation (Literal a) (Literal x))) b)=((fullSubject base prefixes s),b)
getSubjects base prefixes (Triplet s@(S (Short a)) b)=(fullSubject base prefixes s,b)

fullSubject::String-> [(String,String)]->Subject->String
fullSubject base prefixes (Subject (Link a))=a
fullSubject base prefixes (Sub (Notation (Literal a)(Literal b)))=matchPrefix prefixes a ++ b ++">"
fullSubject base prefixes (S (Short a)) = noRBracket base++noLBracket a 

getPredicateList::String->[(String,String)]->PredicateList->[(String,ObjectList)]
getPredicateList base prefixes (SinglePredicate (Predicate (Link a)) x)=[(a,x)]
getPredicateList base prefixes (SinglePredicate (Pred (Notation (Literal a)(Literal b) ))x)=[(matchPrefix prefixes a ++ b++">",x)]
getPredicateList base prefixes (SinglePredicate (P (Short a)) x)=[(noRBracket base ++ noLBracket a,x)]
getPredicateList base prefixes (MultiplePredicates a b)= getPredicateList base prefixes a ++ getPredicateList base prefixes b

getObjectList:: String-> [(String,String)] -> ObjectList -> [String]
getObjectList base prefixes (SingleObject (ObjectLink (Link a)))=[ a]
getObjectList base prefixes (SingleObject (ObjectString (Literal a)) ) =[a] 
getObjectList base prefixes (SingleObject (ObjectBool a)) = [show a]
getObjectList base prefixes (SingleObject (ObjectInt a))=[show a]
getObjectList base prefixes (SingleObject (ObjectShort (Short a)))=[(noRBracket base ++ noLBracket a)]
getObjectList base prefixes (SingleObject (ObjectNotation (Notation (Literal a) (Literal b))))= [(matchPrefix prefixes a ++ b++">")]
getObjectList base prefixes (MultipleObjects a b)=getObjectList base prefixes a++getObjectList base prefixes b

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

<<<<<<< HEAD
makeTriplet::((String,String),String)->(String, String, String)
makeTriplet ((a,b),c) | c=="True" || c== "False" = (a,b, map toLower c)
                | otherwise = (a,b,c)

getFirst:: (String,String,String)->String
getFirst (a,b,c) = a

getSecond::  (String,String,String)->String
getSecond (a,b,c) = b

getThird::  (String,String,String)->String
getThird (a,b,c) = c

-- sortObjects::([S])

=======
stuff::((String,String),String)->String
stuff((a,b),c) | (c == "True") || (c=="False") = a++" "++b++" "++ (map toLower c)++" ."
               | otherwise = a++" "++b++" "++c++" ."
>>>>>>> f0b0a7c53bd711685b96a4dcfdd3f4a085196f21

main = do
     contents <- readFile "test.ttl"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     let base = getBase result
     let prefixes=getPrefixes result base
     let triplets =getTriplets result
     let subjects = map (getSubjects base prefixes) triplets
     let predicates = [getPredicateList base prefixes (snd a)|a<-subjects]
     let objects = [[getObjectList base prefixes (snd b)|b<-a]|a<-predicates]
     let xs = map fst subjects
     let ys = map (map fst) predicates
     let zs = concat objects
     let list1=[(var,v)|(var,var2)<-zip xs ys, v<-var2]
     let list2=[(var,v)|(var,var2)<-zip list1 zs, v<-var2]
     let list3= map makeTriplet list2
     let final = nub $ sort list3
     let strings = [ a++" "++b++" "++c++" ."|(a,b,c)<-final]
     let output= intercalate "\n" strings
     writeFile "out.txt" output
} 


