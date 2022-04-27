{
module Parser where
import Lexer
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
     | prefix Lit ':' Link    { Prefix $2 $4 }
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
parseError [] = error ""
parseError (b : bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++ " " ++ show b
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
} 


