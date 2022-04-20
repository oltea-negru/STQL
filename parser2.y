{
    module LangParser where
    import Lexer
    import Parser
}

%name parseCalc 
%tokentype { Token } 
%error { parseError }
%token 
  '('                  {TokenRBrack p}    
  ')'                  {TokenLBrack p} 
  '<'                  { TokenLessThan p}
  '>'                  { TokenGreaterThan p}
  '<='                 { TokenLessEq p}
  '>='                 { TokenGreaterEq p}
  BOOL                 { TokenBoolType p } 
  INT                  { TokenIntType p } 
  int                  { TokenInt p s } 
  TRUE                 { TokenTrue p }
  FALSE                { TokenFalse p }
  PRINT                { TokenPrint p}
  WHERE                { TokenWhere p}
  UNION                { TokenUnion p}
  PRED                 { TokenPred p}
  SUB                  { TokenSub p}
  OBJ                  { TokenObj p}
  AND                  { TokenAnd p}
  OR                   { TokenOr p}
  FROM                 { TokenFrom p}
  NOT                  { TokenNot p}
  ADD                  { TokenAdd p}
  DELETE               { TokenDelete p}
  CHANGE               { TokenChange p}
  RESTRICT             { TokenRestrict p}  
  SORT                 { TokenSort p}
  GET                  { TokenGet p}
  '='                   { TokenEquals p }

--main query expressions
Expr: PRINT FROM Expr                {Print $3}         
    | UNION FROM Expr Expr           {Union $3 $4}
    | PRINT FROM Expr WHERE Cond     {Filter $3 $5}
    | file                           {File $1}
    | '(' Expr ')'                   { $2 }
    | Expr '<' Expr                  { Comp $1 $3 } 
    | Expr '>' Expr                  { Comp $1 $3 } 
    | Expr '=<' Expr                 { Comp $1 $3 } 
    | Expr '>=' Expr                 { Comp $1 $3 } 
    | Expr '=' Expr                  { Comp $1 $3 } 
    | Cond AND Cond                  {And $1 $3}
    | Cond OR Cond                   {Or $1 $3}
    | NOT Cond                       {Not $2}
    | ADD Triplet                    {Add $2}  
    | DELETE Triplet                 {Delete $2}
    | CHANGE Triplet                 {Change $2}
    | RESTRICT '(' int ',' int ')'   {Restrict $3 $5}   
    | SORT                           {$1}    
    | GET int                        {Get $2}   
    | int                            {IntType $1}     
    | TRUE                            {BoolType $1} 
    | FALSE                           {BoolType $1}§

--filtering conditions
Cond: Expr '<' Expr                   { Comp $1 $3 } 
    | Expr '>' Expr                   { Comp $1 $3 } 
    | Expr '=<' Expr                  { Comp $1 $3 } 
    | Expr '>=' Expr                  { Comp $1 $3 } 
    | Expr '=' Expr                   { Comp $1 $3 } 

--object types (REMOVE????????)
ObType: Bool                          {BoolType}
      | Int                           {IntType}
      | Lit --add literal type

{ 

data Expr= Print Expr | File String | Union Expr Expr | Filter Expr Comp | OutputAll Expr | Comp Expr Expr | And Cond Cond | Not Cond |Or Cond |
Add Triplet | Delete Triplet |Change Triplet | Restrict (Int,Int) | Get IntType deriving (Show,Eq)

data Type = BoolType | IntType | StringType deriving (Show,Eq)


parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b


}