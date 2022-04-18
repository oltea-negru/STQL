{ 
module Parser where 
import Lexer 
}

%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token  
 base       { TokenBase p }
    lit        { TokenLiteral p $$ } 
    http       { TokenURI p $$ }
    '.'        { TokenDot p }
    '<'        { TokenLeftArrow p }
    '>'        { TokenRightArrow p }
    ','        { TokenComma p }
    ';'        { TokenSemiColon p }
 --   ':'        { TokenColon p }
 --   '/'        { TokenSlash p }
--    '"'        { TokenQuote p }
   
  --  prefix     { TokenPrefix p }
    

%%
Start: TripletList {$1}
     | Base TripletList { $2}

Base: base Link '.' {$2}

TripletList:     Triplet '.' TripletList          { MultipleTriplets $1 $3}
           |     Triplet '.'                      { SingleTriplet $1}
      
Triplet :        Subject PredList                 { Triplet $1 $2}

Subject:         Link                             { Subject $1}
       |         Short                            { Subject $1}

PredList:        Predicate ObjList                { SinglePredicate $1 $2}
        |        Predicate ObjList ';' PredList   { MultiplePredicates $1 $2 $4}
Predicate:       Link                             { Predicate $1}
         |       Short                            { Predicate $1}

ObjList:         ObjList ',' Object               { MultipleObjects $1 $3}
       |         Object                           { SingleObject $1}
Object:          lit                              { Object $1}
       |         Link                             { Object $1}
       |         Short                            { Object $1}

Link:            '<' http '>'                     { $2}
Short:           '<' lit  '>'                     { $2}

{ 
    
parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b


data Triplets = SingleTriplet Triplet | MultipleTriplets Triplet Triplets deriving Show     

data Triplet= Triplet Subject PredicateList deriving Show

data Subject = Subject String deriving Show

data PredicateList = SinglePredicate Predicate ObjectList | MultiplePredicates Predicate ObjectList  PredicateList deriving Show

data Predicate = Predicate String deriving Show

data ObjectList = SingleObject Object  |  MultipleObjects ObjectList Object    deriving Show
data Object = Object String deriving Show


main = do
     contents <- readFile "test.ttl"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     print result
} 