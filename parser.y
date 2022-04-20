{ 
module Parser where 
import Lexer 
import LangParser
}

%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token  
 prefix     { TokenPrefix p }
    base       { TokenBase p }
    lit        { TokenLiteral p $$ } 
    http       { TokenURI p $$ }
    short      { TokenShort p $$}
    '.'        { TokenDot p }
    ','        { TokenComma p }
    ';'        { TokenSemiColon p }
    ':'        { TokenColon p }
    '"'        { TokenQuote p }
    int        {TokenInt p }                        

%left '.' ',' ';'
%%
Start: Triplet                { Triplets $1}
     | base http              { TheBase $2}
     | prefix Lit ':' Link    { Prefix $2 $4}
     | Start '.' Start        { Seq $1 $3}
     | Start '.'              { End $1}

Triplet:    Subject PredList                          { Triplet $1 $2 }

Subject:    Link                                      { Subject $1 }
       |    Lit ':' Lit                               { Sub $1 $3 }
   
PredList:   Predicate ObjList                         { SinglePredicate $1 $2 }
        |   Predicate ObjList ';' PredList            { MultiplePredicates $1 $2 $4}

Predicate:  Link                                      { Predicate $1 }
         |  Lit ':' Lit                               { Pred $1 $3 }
        
ObjList:    ObjList ',' Object                        { MultipleObjects $1 $3 }
       |    Object                                    { SingleObject $1 }
Object:     '"' Lit '"'                               { Object String $2 }
       |     int                                      { Object Int $1}
       |    Link                                      { Object $1 }

Link:       http                                      { $1 }
    |       short                                     { $1 }

Lit:        lit                                       { $1 }

{
parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++ " " ++ show b

data Exp = TheBase String
         | Prefix String String
         | Triplets Triplet 
         | Seq Exp Exp
         | End Exp deriving (Show,Eq)

data Triplet= Triplet Subject PredicateList deriving (Show,Eq)

data ShortTriplet= ShortTriplet Subject PredicateList deriving (Show,Eq)

data Subject = Subject String | Sub String String deriving (Show,Eq)

data PredicateList = SinglePredicate Predicate ObjectList 
                   | MultiplePredicates Predicate ObjectList  PredicateList deriving (Show,Eq)
data Predicate = Predicate String | Pred String String deriving (Show,Eq)

data ObjectList = SingleObject Object  |  MultipleObjects ObjectList Object    deriving (Show,Eq)

data Object = Object String | Object Bool |Object Int deriving (Show,Eq)


main = do
     contents <- readFile "test.ttl"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     print result
} 


