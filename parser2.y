{
    module LangParser where
    import Lexer
}

%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token  
  
  PRINT                                                   { \p s -> TokenPrint p}
  WHERE                                                   { \p s -> TokenWhere p}
  UNION                                                   { \p s -> TokenUnion p}
  \<                                                      { \p s -> TokenLessThan p}
  \>                                                      { \p s -> TokenGreaterThan p}
  PRED                                                    { \p s -> TokenPred p}
  SUB                                                     { \p s -> TokenSub p}
  OBJ                                                     { \p s -> TokenObj p}
  AND                                                     { \p s -> TokenAnd p}
  OR                                                      { \p s -> TokenOr p}
  FROM                                                    { \p s -> TokenFrom p}
  NOT                                                     { \p s -> TokenNot p}
  ADD                                                     { \p s -> TokenAdd p}
  DELETE                                                  { \p s -> TokenDelete p}
  CHANGE                                                  { \p s -> TokenChange p}
  RESTRICT                                                { \p s -> TokenRestrict p}  
  SORT                                                    { \p s -> TokenSort p}
  GET                                                     { \p s -> TokenGet p}
  \=                                                      { \p s -> TokenEquals p }


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
}