{ 
module Parser where 
import Lexer 
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
   
%left '.' ',' ';'
%%
Start: Triplet           { StartTriplets $1}
     | Base              { StartBase $1}
     | ShortTriplet       { StartShort $1}
     | Start '.' Start        { Continue $1 $3}
     | Start '.'              { End $1}

-- TripletList: Triplet                                   { SingleTriplet $1}     
--         --    | Triplet TripletList                      { MultipleTriplets $1 $3}
            

-- ShortTripletList: ShortTriplet                         { ShortSingleTriplet $1}
--                -- | ShortTriplet '.' ShortTripletList       { ShortMultipleTriplets $1 $3}

Triplet : Sub PredList                                    { Triplet $1 $2}

ShortTriplet : ShortSub PredList                          { ShortTriplet $1 $2}

Sub:             Link                                     { Subject $1}
ShortSub:        Short                                    { Subject $1}
        
PredList:        Predicate ObjList                        { SinglePredicate $1 $2}
        |        Predicate ObjList ';' PredList           { MultiplePredicates $1 $2 $4}
Predicate:       Link                                     { Predicate $1}
        
ObjList:         ObjList ',' Object                       { MultipleObjects $1 $3}
       |         Object                                   { SingleObject $1}
Object:          lit                                      { Object $1}
       |         Link                                     { Object $1}
       |         Short                                    { Object $1}

Base: base Link                                        {Base $2}
Link: http                      { $1}
Short:    short                      { $1}

{ 
    
parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

data Exp = StartBase Base
         | StartTriplets Triplet 
         | StartShort ShortTriplet
         | Continue Exp Exp
         | End Exp deriving Show

data Base = Base String deriving Show

data Triplet= Triplet Subject PredicateList deriving Show

data ShortTriplet= ShortTriplet Subject PredicateList deriving Show

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