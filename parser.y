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
    "^^" $alpha [$alpha $digit \_ \’]*                       {  TokenComment p}                            
  OUTPUT       {TokenOutput p}
  IN           { TokenIn p}
  WHERE        {  TokenWhere p}
  LINK         {  TokenLink p}
  LESSTHAN     {  TokenLessThan p}
  GREATERTHAN  {  TokenGreaterThan p}
  PRED         {  TokenPred p}
  SUB          {  TokenSub p}
  OBJ          {  TokenObj p}
  AND          {  TokenAnd p}
  OR           {  TokenOr p}
  FROM         {  TokenFrom p}
  "="           {  TokenEquals p }
  file          {TokenFile p}
 --   ':'        { TokenColon p }
 --   '/'        { TokenSlash p }
--    '"'        { TokenQuote p }
   
  --  prefix     { TokenPrefix p }
    

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
Object:     '"' Lit '"'                               { Object $2 }
       |    Link                                      { Object $1 }

Link:       http                                      { $1 }
    |       short                                     { $1 }

Lit:        lit                                       { $1 }


Expr: OUTPUT FROM Expr                {OutputAll $3}        --fix                                      
    | LINK FROM Expr Expr             {LinkFiles $4 $5}
    | OUTPUT FROM Expr WHERE Cond     {Filter $3 $5}
    | file                            {File $1}

--change triptype to int???
Cond: Expr LESSTHAN Expr                  {Comp $1 $3}
    | Expr GREATERTHAN Expr               {Comp $1 $3}
    | Expr '=' Expr                       {Comp $1 $3}

Type: Bool
    | Int 
    |


{ 
    
parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

--type Environment = [ (String,Expr) ]

data Expr= File String | LinkFiles Expr Expr | Filter Expr Comp | OutputAll Expr deriving (Show,Eq)

data Cond= Comp TripType TripType deriving (Show,Eq)

data TripType = Subject | Predicate | Object |deriving (Show,Eq)

parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

data Exp = TheBase String
         | Prefix String String
         | Triplets Triplet 
         | Seq Exp Exp
         | End Exp deriving Show

data Triplet= Triplet Subject PredicateList deriving Show

data ShortTriplet= ShortTriplet Subject PredicateList deriving Show

data Subject = Subject String | Sub String String deriving Show

data PredicateList = SinglePredicate Predicate ObjectList 
                   | MultiplePredicates Predicate ObjectList  PredicateList deriving Show
data Predicate = Predicate String | Pred String String deriving Show

data ObjectList = SingleObject Object  |  MultipleObjects ObjectList Object    deriving Show

data Object = Object String deriving Show --add bool and int

main = do
     contents <- readFile "test.ttl"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     print result
} 


