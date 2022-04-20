
{- data Triplets = SingleTriplet Triplet | MultipleTriplets Triplet Triplets deriving Show     

data Triplet= Triplet Subject PredicateList deriving Show

data Subject = Subject String deriving Show

data PredicateList = SinglePredicate Predicate ObjectList | MultiplePredicates Predicate ObjectList  PredicateList deriving Show

data Predicate = Predicate String deriving Show

data ObjectList = SingleObject Object  |  MultipleObjects ObjectList Object    deriving Show
data Object = Object String deriving Show
-}


--Evaluate comparisons 

--lookup function

--update function

--