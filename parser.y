{ 
module Parser where 
import Lexer 
import Data.Typeable
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
    '"'      { TokenQuote p }
    int      { TokenInt p $$ }                        

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
        |   Predicate ObjList ';' PredList       { MultiplePredicates $1 $2 $4 }
Predicate:  Link                                 { Predicate $1 }
         |  Notation                             { Pred $1 }
         |  Short                                { P $1 }
       
ObjList:    ObjList ',' Object                   { MultipleObjects $1 $3 }
       |    Object                               { SingleObject $1 }
Object:     '"' Lit '"'                          { ObjectString $2 }
       |    int                                  { ObjectInt $1 }
       |    Link                                 { ObjectLink $1 }
       |    Short                                { ObjectShort $1 }

Link:       http                                 { Link $1 }
Short:      short                                { Short $1 }
Notation:   Lit ':' Lit                          { Notation $1 $3 }

Lit:        lit                                  { Literal $1 }

{
parseError :: [Token] -> a
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
                   | MultiplePredicates Predicate ObjectList PredicateList deriving (Show,Eq)

data Predicate = Predicate Link 
               | Pred Notation 
               | P Short deriving (Show,Eq)

data ObjectList = SingleObject Object  
                | MultipleObjects ObjectList Object    deriving (Show,Eq)

data Object = ObjectString Literal 
            | ObjectBool Bool 
            | ObjectInt Int
            | ObjectLink Link
            | ObjectShort Short deriving (Show,Eq)

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

matchPrefix::[(String,String)]->String->String
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




main = do
     contents <- readFile "test.ttl"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     let base = getBase result
     let prefixes=getPrefixes result base
     let triplets =getTriplets result
     let subjects = map (getSubjects base prefixes) triplets
     print result
     print "===================="
     print subjects
} 


