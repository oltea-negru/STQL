

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