{-# OPTIONS_GHC -w #-}
module Parser where 
import Lexer 
import Data.Typeable
import Data.List
import Data.Function (on)
import Data.Char
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.0

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12
	= HappyTerminal (Token)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10
	| HappyAbsSyn11 t11
	| HappyAbsSyn12 t12

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,65) ([61440,1,896,0,0,3584,0,0,0,2,0,0,0,0,0,4,256,0,14,0,0,512,31744,0,32,0,8,50048,1,0,8192,0,0,0,0,1024,0,0,0,0,0,1792,0,0,0,0,56,0,0,0,49152,225,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseInput","Start","Triplet","Subject","PredList","Predicate","ObjList","Object","Link","Lit","prefix","base","lit","http","short","'.'","','","';'","':'","int","true","false","%eof"]
        bit_start = st Prelude.* 25
        bit_end = (st Prelude.+ 1) Prelude.* 25
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..24]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (13) = happyShift action_10
action_0 (14) = happyShift action_11
action_0 (15) = happyShift action_6
action_0 (16) = happyShift action_7
action_0 (17) = happyShift action_8
action_0 (4) = happyGoto action_9
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 (11) = happyGoto action_4
action_0 (12) = happyGoto action_5
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (15) = happyShift action_6
action_1 (16) = happyShift action_7
action_1 (17) = happyShift action_8
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 (11) = happyGoto action_4
action_1 (12) = happyGoto action_5
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (15) = happyShift action_6
action_3 (16) = happyShift action_7
action_3 (17) = happyShift action_8
action_3 (7) = happyGoto action_16
action_3 (8) = happyGoto action_17
action_3 (11) = happyGoto action_18
action_3 (12) = happyGoto action_5
action_3 _ = happyFail (happyExpListPerState 3)

action_4 _ = happyReduce_7

action_5 (21) = happyShift action_15
action_5 _ = happyFail (happyExpListPerState 5)

action_6 _ = happyReduce_21

action_7 _ = happyReduce_18

action_8 _ = happyReduce_19

action_9 (18) = happyShift action_14
action_9 (25) = happyAccept
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (15) = happyShift action_6
action_10 (12) = happyGoto action_13
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (15) = happyShift action_6
action_11 (16) = happyShift action_7
action_11 (17) = happyShift action_8
action_11 (11) = happyGoto action_12
action_11 (12) = happyGoto action_5
action_11 _ = happyFail (happyExpListPerState 11)

action_12 _ = happyReduce_2

action_13 (21) = happyShift action_29
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (13) = happyShift action_10
action_14 (14) = happyShift action_11
action_14 (15) = happyShift action_6
action_14 (16) = happyShift action_7
action_14 (17) = happyShift action_8
action_14 (4) = happyGoto action_28
action_14 (5) = happyGoto action_2
action_14 (6) = happyGoto action_3
action_14 (11) = happyGoto action_4
action_14 (12) = happyGoto action_5
action_14 _ = happyReduce_5

action_15 (15) = happyShift action_6
action_15 (12) = happyGoto action_27
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (20) = happyShift action_26
action_16 _ = happyReduce_6

action_17 (15) = happyShift action_6
action_17 (16) = happyShift action_7
action_17 (17) = happyShift action_8
action_17 (22) = happyShift action_23
action_17 (23) = happyShift action_24
action_17 (24) = happyShift action_25
action_17 (9) = happyGoto action_19
action_17 (10) = happyGoto action_20
action_17 (11) = happyGoto action_21
action_17 (12) = happyGoto action_22
action_17 _ = happyFail (happyExpListPerState 17)

action_18 _ = happyReduce_10

action_19 (19) = happyShift action_32
action_19 _ = happyReduce_8

action_20 _ = happyReduce_11

action_21 _ = happyReduce_13

action_22 (21) = happyShift action_15
action_22 _ = happyReduce_14

action_23 _ = happyReduce_15

action_24 _ = happyReduce_16

action_25 _ = happyReduce_17

action_26 (15) = happyShift action_6
action_26 (16) = happyShift action_7
action_26 (17) = happyShift action_8
action_26 (7) = happyGoto action_31
action_26 (8) = happyGoto action_17
action_26 (11) = happyGoto action_18
action_26 (12) = happyGoto action_5
action_26 _ = happyFail (happyExpListPerState 26)

action_27 _ = happyReduce_20

action_28 _ = happyReduce_4

action_29 (15) = happyShift action_6
action_29 (16) = happyShift action_7
action_29 (17) = happyShift action_8
action_29 (11) = happyGoto action_30
action_29 (12) = happyGoto action_5
action_29 _ = happyFail (happyExpListPerState 29)

action_30 _ = happyReduce_3

action_31 _ = happyReduce_9

action_32 (15) = happyShift action_6
action_32 (16) = happyShift action_7
action_32 (17) = happyShift action_8
action_32 (22) = happyShift action_23
action_32 (23) = happyShift action_24
action_32 (24) = happyShift action_25
action_32 (9) = happyGoto action_33
action_32 (10) = happyGoto action_20
action_32 (11) = happyGoto action_21
action_32 (12) = happyGoto action_22
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_12

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 (Triplets happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_2  4 happyReduction_2
happyReduction_2 (HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn4
		 (TheBase happy_var_2
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happyReduce 4 4 happyReduction_3
happyReduction_3 ((HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Prefix happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_4 = happySpecReduce_3  4 happyReduction_4
happyReduction_4 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Seq happy_var_1 happy_var_3
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  4 happyReduction_5
happyReduction_5 _
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (End happy_var_1
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  5 happyReduction_6
happyReduction_6 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn5
		 (Triplet happy_var_1 happy_var_2
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_1  6 happyReduction_7
happyReduction_7 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn6
		 (Subject happy_var_1
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  7 happyReduction_8
happyReduction_8 (HappyAbsSyn9  happy_var_2)
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn7
		 (SinglePredicate happy_var_1 happy_var_2
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  7 happyReduction_9
happyReduction_9 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (MultiplePredicates happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_1  8 happyReduction_10
happyReduction_10 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn8
		 (Predicate happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  9 happyReduction_11
happyReduction_11 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (SingleObject happy_var_1
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  9 happyReduction_12
happyReduction_12 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (MultipleObjects happy_var_1 happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  10 happyReduction_13
happyReduction_13 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 (ObjectLink happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  10 happyReduction_14
happyReduction_14 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn10
		 (ObjectString happy_var_1
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_1  10 happyReduction_15
happyReduction_15 (HappyTerminal (TokenInt p happy_var_1))
	 =  HappyAbsSyn10
		 (ObjectInt happy_var_1
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_1  10 happyReduction_16
happyReduction_16 (HappyTerminal (TokenTrue p happy_var_1))
	 =  HappyAbsSyn10
		 (ObjectBool happy_var_1
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  10 happyReduction_17
happyReduction_17 (HappyTerminal (TokenFalse p happy_var_1))
	 =  HappyAbsSyn10
		 (ObjectBool happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_1  11 happyReduction_18
happyReduction_18 (HappyTerminal (TokenURI p happy_var_1))
	 =  HappyAbsSyn11
		 (Link happy_var_1
	)
happyReduction_18 _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  11 happyReduction_19
happyReduction_19 (HappyTerminal (TokenShort p happy_var_1))
	 =  HappyAbsSyn11
		 (Short happy_var_1
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  11 happyReduction_20
happyReduction_20 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 (Notation happy_var_1 happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  12 happyReduction_21
happyReduction_21 (HappyTerminal (TokenLiteral p happy_var_1))
	 =  HappyAbsSyn12
		 (Literal happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 25 25 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TokenPrefix p -> cont 13;
	TokenBase p -> cont 14;
	TokenLiteral p happy_dollar_dollar -> cont 15;
	TokenURI p happy_dollar_dollar -> cont 16;
	TokenShort p happy_dollar_dollar -> cont 17;
	TokenDot p -> cont 18;
	TokenComma p -> cont 19;
	TokenSemiColon p -> cont 20;
	TokenColon p -> cont 21;
	TokenInt p happy_dollar_dollar -> cont 22;
	TokenTrue p happy_dollar_dollar -> cont 23;
	TokenFalse p happy_dollar_dollar -> cont 24;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 25 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Prelude.Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Prelude.Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (Prelude.>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (Prelude.return)
happyThen1 m k tks = (Prelude.>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (Prelude.return) a
happyError' :: () => ([(Token)], [Prelude.String]) -> HappyIdentity a
happyError' = HappyIdentity Prelude.. (\(tokens, _) -> parseError tokens)
parseInput tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError [] = error "No Tokens"
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++ " " ++ show b

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

sortObjs (ObjectLink ob1) (ObjectLink ob2) = compare ob1 ob2
sortObjs (ObjectInt ob1) (ObjectInt ob2) = compare ob1 ob2
sortObjs (ObjectBool ob1) (ObjectBool ob2) = compare ob1 ob2
sortObjs (ObjectString ob1) (ObjectString ob2) = compare ob1 ob2
sortObjs (ObjectLink ob2) _ = LT
sortObjs (ObjectString ob1) _ = GT 
sortObjs (ObjectInt ob1) (ObjectBool ob2) = LT
sortObjs (ObjectInt ob1) (ObjectString ob2) = LT
sortObjs (ObjectBool ob1) (ObjectString ob2) = LT
sortObjs (ObjectBool ob1) _ = GT
sortObjs _ _ = GT


getBase :: Exp -> String
getBase (TheBase (Link a)) = a
getBase (Triplets a)=""
getBase (Prefix (Literal a) (Link b))=""
getBase (Prefix (Literal a) (Short b))=""
getBase (Prefix (Literal a) (Notation (Literal c)(Literal d)))=""
getBase (End a) = getBase a
getBase (Seq a b) = (getBase a) ++ (getBase b)

getPrefixes :: Exp->String -> [(String, String)]
getPrefixes (Prefix (Literal a) (Link b)) base =[(a,b)]
getPrefixes (Prefix (Literal a) (Short b)) base= [(a,noRBracket base ++ noLBracket b)]
getPrefixes (TheBase (Link a)) base = []
getPrefixes (Triplets a) base=[]
getPrefixes (End a) base =[]++getPrefixes a base
getPrefixes (Seq a b) base = (getPrefixes a base) ++ (getPrefixes b base)

getTriplets :: Exp -> [(Triplet)]
getTriplets (Prefix (Literal a) (Link b))=[]
getTriplets (Prefix (Literal a) (Short b))=[]
getTriplets (Prefix (Literal a) (Notation (Literal b)(Literal c)))=[]
getTriplets (TheBase (Link a)) = []
getTriplets (Triplets a)=[a]
getTriplets (End a) =getTriplets a
getTriplets (Seq a b)=getTriplets a ++ getTriplets b 

getSubjects::String->[(String,String)]->Triplet->(String,PredicateList)
getSubjects base prefixes (Triplet s@(Subject (Link a)) b)=(fullSubject base prefixes s,b)
getSubjects base prefixes (Triplet s@(Subject (Notation (Literal a) (Literal x))) b)=((fullSubject base prefixes s),b)
getSubjects base prefixes (Triplet s@(Subject (Short a)) b)=(fullSubject base prefixes s,b)

fullSubject::String-> [(String,String)]->Subject->String
fullSubject base prefixes (Subject (Link a))=a
fullSubject base prefixes (Subject (Notation (Literal a)(Literal b)))=matchPrefix prefixes a ++ b ++">"
fullSubject base prefixes (Subject (Short a)) = noRBracket base++noLBracket a 

getPredicateList::String->[(String,String)]->PredicateList->[(String,ObjectList)]
getPredicateList base prefixes (SinglePredicate (Predicate (Link a)) x)=[(a,x)]
getPredicateList base prefixes (SinglePredicate (Predicate (Notation (Literal a)(Literal b) ))x)=[(matchPrefix prefixes a ++ b++">",x)]
getPredicateList base prefixes (SinglePredicate (Predicate (Short a)) x)=[(noRBracket base ++ noLBracket a,x)]
getPredicateList base prefixes (MultiplePredicates a b)= getPredicateList base prefixes a ++ getPredicateList base prefixes b

getObjectList:: String-> [(String,String)] -> ObjectList -> [String]
getObjectList base prefixes (SingleObject (ObjectLink (Link a)))=[ a]
getObjectList base prefixes (SingleObject (ObjectLink (Short a)))=[(noRBracket base ++ noLBracket a)]
getObjectList base prefixes (SingleObject (ObjectLink (Notation (Literal a) (Literal b))))= [(matchPrefix prefixes a ++ b++">")]
getObjectList base prefixes (SingleObject (ObjectString (Literal a)) ) =[a] 
getObjectList base prefixes (SingleObject (ObjectBool a)) = [show a]
getObjectList base prefixes (SingleObject (ObjectInt a))=[show a]
getObjectList base prefixes (MultipleObjects a b)=getObjectList base prefixes a++getObjectList base prefixes b

getObjects:: String-> [(String,String)] -> ObjectList -> [Object]
getObjects base prefixes (SingleObject a)=[ a]
getObjects base prefixes (MultipleObjects a b)=getObjects base prefixes a++getObjects base prefixes b

matchPrefix::[(String,String)]->String->String
matchPrefix [] b=[]
matchPrefix (a:as) b | (fst a)==b = noRBracket (snd a)
                     | otherwise = matchPrefix as b

noBrackets::String->String
noBrackets as = noLBracket $ noRBracket as

noLBracket::String->String
noLBracket []=[]
noLBracket (a:as) | a=='<' =noLBracket as
                  | otherwise = a: noLBracket as

noRBracket::String->String
noRBracket []=[]
noRBracket (a:as) | a=='>' =noRBracket as
                  | otherwise = a: noRBracket as


makeFinalTriplet'':: ((String, String), String)-> (String, String, String)
makeFinalTriplet'' ((a,b),c)  =(a,b,c)
                         


makeTriplet::((String,String),Object)->(String, String, Object)
makeTriplet ((a,b),c) = (a,b,c)

getFirst:: (String,String,Object)->String
getFirst (a,b,c) = a

getSecond::  (String,String,Object)->String
getSecond (a,b,c) = b

getThird::  (String,String,Object)->Object
getThird (a,b,c) = c

getSubPred:: (String,String,Object)-> (String,String)
getSubPred (a,b,c) = (a,b)

obToString:: [(String,String)] -> String -> Object -> String
obToString prefixes base (ObjectLink (Link a))= a
obToString prefixes base (ObjectLink (Short a))= (noRBracket base ++ noLBracket a)
obToString prefixes base (ObjectLink (Notation (Literal a) (Literal b))) = (matchPrefix prefixes a ++ b++">")
obToString prefixes base (ObjectString (Literal a)) =a
obToString prefixes base (ObjectBool a) = show a
obToString prefixes base (ObjectInt a) =show a

obToStringHelper:: [(String,String)] -> String -> [Object] -> [String]
obToStringHelper prefixes base [] = []
obToStringHelper prefixes base (x:xs) = (obToString prefixes base x :obToStringHelper prefixes base xs)

-- main = do
--      contents <- readFile "bar.ttl"
--      let tokens = alexScanTokens contents
--      let result = parseCalc tokens
--      let base = getBase result
--      let prefixes =getPrefixes result base
--      let triplets =getTriplets result
--      let subjPredList = map (getSubjects base prefixes) triplets
--      let predObjList = [getPredicateList base prefixes (snd a)|a<-subjPredList]
--      let obList1 =  [[getObjects base prefixes (snd b)|b<-a]|a<-predObjList]
--      let subList = map fst subjPredList
--      let predList = map (map fst) predObjList
--      let obList2 = (concat obList1)
--      let list1=[(var,v)|(var,var2)<-zip subList predList, v<-var2]
--      let list2=[(var,v)|(var,var2)<-zip list1 obList2, v<-var2]
--      let subPredObTupleList= map makeTriplet list2
--      let sortedsubPredObTupleList = sort (subPredObTupleList) --string,string,ob
--      let final = zip (map getSubPred sortedsubPredObTupleList) (obToStringHelper prefixes base (map getThird sortedsubPredObTupleList))
--      --let final = zip (map getSubPred sortedsubPredObTupleList) (map (\a -> obToString (prefixes) (base)) (map getThird sortedsubPredObTupleList))
--      let strings = [ a++" "++b++" "++c++" ."| (a,b,c)<- map makeFinalTriplet'' final]
--      let output= intercalate "\n" strings
--      writeFile "output2.txt" output
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
