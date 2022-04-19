{
    module LangParser where
    import Lexer
}

%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token  
  Bool
  Int
  int
  true
  false
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


Expr: PRINT FROM Expr                {OutputAll $3}                                            
    | UNION FROM Expr Expr             {UnionFiles $4 $5}
    | PRINT FROM Expr WHERE Cond     {Filter $3 $5}
    | file                            {File $1}

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

data Expr= File String | UnionFiles Expr Expr | Filter Expr Comp | OutputAll Expr | deriving (Show,Eq)

data Cond= Comp TripType TripType deriving (Show,Eq)

data TripType = Subject | Predicate | Object |deriving (Show,Eq)
}