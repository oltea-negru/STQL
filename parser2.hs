{-# OPTIONS_GHC -w #-}
module LangParser where
import Lexer
import System.Environment
import System.IO
import Control.Monad
import Data.List
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
happyExpList = Happy_Data_Array.listArray (0,86) ([0,512,0,0,8,0,0,32,2048,256,22,0,512,0,8192,1024,512,0,0,0,0,0,28672,0,0,0,2,0,2048,0,8,0,0,0,1,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,24576,0,1920,0,0,32,0,32768,0,0,512,0,0,0,0,0,0,4,0,0,0,120,32,0,32768,0,0,512,0,2,0,2048,0,0,32,0,32768,0,0,0,7,0,7168,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseCalc","Exp","Seq","Cond","Field","Link","Lit","Number","File","Bool","'('","';'","')'","'<'","'>'","'<='","'>='","'='","','","int","lit","TRUE","FALSE","PRINT","WHERE","UNION","PRED","SUB","OBJ","AND","OR","FROM","NOT","ADD","DELETE","RESTRICT","GET","URI","file","%eof"]
        bit_start = st Prelude.* 42
        bit_end = (st Prelude.+ 1) Prelude.* 42
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..41]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (26) = happyShift action_4
action_0 (4) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (26) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (34) = happyShift action_12
action_2 _ = happyFail (happyExpListPerState 2)

action_3 (14) = happyShift action_7
action_3 (27) = happyShift action_8
action_3 (36) = happyShift action_9
action_3 (37) = happyShift action_10
action_3 (39) = happyShift action_11
action_3 (42) = happyAccept
action_3 (5) = happyGoto action_6
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (34) = happyShift action_5
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (28) = happyShift action_25
action_5 (41) = happyShift action_14
action_5 (11) = happyGoto action_13
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (14) = happyShift action_24
action_6 _ = happyFail (happyExpListPerState 6)

action_7 _ = happyReduce_3

action_8 (29) = happyShift action_21
action_8 (30) = happyShift action_22
action_8 (31) = happyShift action_23
action_8 (6) = happyGoto action_19
action_8 (7) = happyGoto action_20
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (40) = happyShift action_18
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (40) = happyShift action_17
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (22) = happyShift action_16
action_11 (10) = happyGoto action_15
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (41) = happyShift action_14
action_12 (11) = happyGoto action_13
action_12 _ = happyFail (happyExpListPerState 12)

action_13 _ = happyReduce_1

action_14 (41) = happyShift action_14
action_14 (11) = happyGoto action_36
action_14 _ = happyReduce_27

action_15 _ = happyReduce_6

action_16 _ = happyReduce_26

action_17 _ = happyReduce_8

action_18 _ = happyReduce_7

action_19 (32) = happyShift action_34
action_19 (33) = happyShift action_35
action_19 _ = happyReduce_5

action_20 (16) = happyShift action_30
action_20 (17) = happyShift action_31
action_20 (18) = happyShift action_32
action_20 (19) = happyShift action_33
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (20) = happyShift action_29
action_21 _ = happyReduce_22

action_22 (20) = happyShift action_28
action_22 _ = happyReduce_21

action_23 (20) = happyShift action_27
action_23 _ = happyReduce_23

action_24 _ = happyReduce_4

action_25 (41) = happyShift action_14
action_25 (11) = happyGoto action_26
action_25 _ = happyFail (happyExpListPerState 25)

action_26 _ = happyReduce_2

action_27 (22) = happyShift action_16
action_27 (23) = happyShift action_50
action_27 (24) = happyShift action_51
action_27 (25) = happyShift action_52
action_27 (40) = happyShift action_44
action_27 (8) = happyGoto action_46
action_27 (9) = happyGoto action_47
action_27 (10) = happyGoto action_48
action_27 (12) = happyGoto action_49
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (40) = happyShift action_44
action_28 (8) = happyGoto action_45
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (40) = happyShift action_44
action_29 (8) = happyGoto action_43
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (22) = happyShift action_16
action_30 (10) = happyGoto action_42
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (22) = happyShift action_16
action_31 (10) = happyGoto action_41
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (22) = happyShift action_16
action_32 (10) = happyGoto action_40
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (22) = happyShift action_16
action_33 (10) = happyGoto action_39
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (29) = happyShift action_21
action_34 (30) = happyShift action_22
action_34 (31) = happyShift action_23
action_34 (6) = happyGoto action_38
action_34 (7) = happyGoto action_20
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (29) = happyShift action_21
action_35 (30) = happyShift action_22
action_35 (31) = happyShift action_23
action_35 (6) = happyGoto action_37
action_35 (7) = happyGoto action_20
action_35 _ = happyFail (happyExpListPerState 35)

action_36 _ = happyReduce_28

action_37 _ = happyReduce_20

action_38 _ = happyReduce_19

action_39 _ = happyReduce_12

action_40 _ = happyReduce_11

action_41 _ = happyReduce_10

action_42 _ = happyReduce_9

action_43 _ = happyReduce_14

action_44 _ = happyReduce_24

action_45 _ = happyReduce_13

action_46 _ = happyReduce_15

action_47 _ = happyReduce_17

action_48 _ = happyReduce_18

action_49 _ = happyReduce_16

action_50 _ = happyReduce_25

action_51 _ = happyReduce_29

action_52 _ = happyReduce_30

happyReduce_1 = happySpecReduce_3  4 happyReduction_1
happyReduction_1 (HappyAbsSyn11  happy_var_3)
	_
	_
	 =  HappyAbsSyn4
		 (SimplePrint happy_var_3
	)
happyReduction_1 _ _ _  = notHappyAtAll 

happyReduce_2 = happyReduce 4 4 happyReduction_2
happyReduction_2 ((HappyAbsSyn11  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (UnionPrint happy_var_4
	) `HappyStk` happyRest

happyReduce_3 = happySpecReduce_2  4 happyReduction_3
happyReduction_3 _
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (End happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  4 happyReduction_4
happyReduction_4 _
	(HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Seq happy_var_1 happy_var_2
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  5 happyReduction_5
happyReduction_5 (HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (Where happy_var_2
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  5 happyReduction_6
happyReduction_6 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (Get happy_var_2
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_2  5 happyReduction_7
happyReduction_7 (HappyTerminal (TokenURIValue p happy_var_2))
	_
	 =  HappyAbsSyn5
		 (Add happy_var_2
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  5 happyReduction_8
happyReduction_8 (HappyTerminal (TokenURIValue p happy_var_2))
	_
	 =  HappyAbsSyn5
		 (Delete happy_var_2
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  6 happyReduction_9
happyReduction_9 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 (Less happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  6 happyReduction_10
happyReduction_10 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 (Greater happy_var_1 happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  6 happyReduction_11
happyReduction_11 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 (LessOr happy_var_1 happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  6 happyReduction_12
happyReduction_12 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 (GreaterOr happy_var_1 happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  6 happyReduction_13
happyReduction_13 (HappyAbsSyn8  happy_var_3)
	_
	(HappyTerminal (TokenSub p happy_var_1))
	 =  HappyAbsSyn6
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  6 happyReduction_14
happyReduction_14 (HappyAbsSyn8  happy_var_3)
	_
	(HappyTerminal (TokenPred p happy_var_1))
	 =  HappyAbsSyn6
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  6 happyReduction_15
happyReduction_15 (HappyAbsSyn8  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  6 happyReduction_16
happyReduction_16 (HappyAbsSyn12  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (EqStringBool happy_var_1 happy_var_3
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  6 happyReduction_17
happyReduction_17 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  6 happyReduction_18
happyReduction_18 (HappyAbsSyn10  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (EqStringInt happy_var_1 happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  6 happyReduction_19
happyReduction_19 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (And happy_var_1 happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  6 happyReduction_20
happyReduction_20 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Or happy_var_1 happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  7 happyReduction_21
happyReduction_21 (HappyTerminal (TokenSub p happy_var_1))
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  7 happyReduction_22
happyReduction_22 (HappyTerminal (TokenPred p happy_var_1))
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  7 happyReduction_23
happyReduction_23 (HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_1  8 happyReduction_24
happyReduction_24 (HappyTerminal (TokenURIValue p happy_var_1))
	 =  HappyAbsSyn8
		 (happy_var_1
	)
happyReduction_24 _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  9 happyReduction_25
happyReduction_25 (HappyTerminal (TokenLiteral p happy_var_1))
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  10 happyReduction_26
happyReduction_26 (HappyTerminal (TokenInt p happy_var_1))
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  11 happyReduction_27
happyReduction_27 (HappyTerminal (TokenFile p happy_var_1))
	 =  HappyAbsSyn11
		 (OneFile happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_2  11 happyReduction_28
happyReduction_28 (HappyAbsSyn11  happy_var_2)
	(HappyTerminal (TokenFile p happy_var_1))
	 =  HappyAbsSyn11
		 (MoreFiles  happy_var_1 happy_var_2
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  12 happyReduction_29
happyReduction_29 (HappyTerminal (TokenTrue p happy_var_1))
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  12 happyReduction_30
happyReduction_30 (HappyTerminal (TokenFalse p happy_var_1))
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 42 42 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TokenLBrack p -> cont 13;
	TokenSemiColon p -> cont 14;
	TokenRBrack p -> cont 15;
	TokenLess p -> cont 16;
	TokenGreater p -> cont 17;
	TokenLessEq p -> cont 18;
	TokenGreaterEq p -> cont 19;
	TokenEquals p -> cont 20;
	TokenComma p -> cont 21;
	TokenInt p happy_dollar_dollar -> cont 22;
	TokenLiteral p happy_dollar_dollar -> cont 23;
	TokenTrue p happy_dollar_dollar -> cont 24;
	TokenFalse p happy_dollar_dollar -> cont 25;
	TokenPrint p -> cont 26;
	TokenWhere p -> cont 27;
	TokenUnion p -> cont 28;
	TokenPred p happy_dollar_dollar -> cont 29;
	TokenSub p happy_dollar_dollar -> cont 30;
	TokenObj p happy_dollar_dollar -> cont 31;
	TokenAnd p -> cont 32;
	TokenOr p -> cont 33;
	TokenFrom p -> cont 34;
	TokenNot p -> cont 35;
	TokenAdd p -> cont 36;
	TokenDelete p -> cont 37;
	TokenRestrict p -> cont 38;
	TokenGet p -> cont 39;
	TokenURIValue p happy_dollar_dollar -> cont 40;
	TokenFile p happy_dollar_dollar -> cont 41;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 42 tk tks = happyError' (tks, explist)
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
parseCalc tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


data Expr=  Print Files Expr 
          | End Expr
          | Seq Expr Expr
          | SimplePrint Files
          | UnionPrint Files
          | Where Cond
          | Get Int
          | Add String 
          | Delete String 
         deriving (Show,Eq)

data Cond = Less String Int 
          | Greater String Int 
          | LessOr String Int 
          | GreaterOr String Int 
          | EqString String String
          | EqStringInt String Int
          | EqStringBool String Bool
          | And Cond Cond 
          | Or Cond Cond 
          deriving (Show, Eq)

data Files = OneFile String | MoreFiles String Files  deriving (Show,Eq)

accessFiles::Files->[String] -- helper for getFiles, dont use
accessFiles (OneFile a) =[a]
accessFiles (MoreFiles a b)=[a] ++ accessFiles b

getFiles::Expr->[String] -- returns list of all files mentioned in language
getFiles (Print a b)=accessFiles a
getFiles (SimplePrint a)=accessFiles a
getFiles (Where a)=[]
getFiles (Get a)=[]
getFiles (Add a)=[]
getFiles (Delete a)=[]
getFiles (UnionPrint a)=accessFiles a
getFiles (End a)=getFiles a
getFiles (Seq a b)=getFiles a++ getFiles b

unionFiles::[String]->IO () -- take the content of all files and                            
unionFiles []= return ()    -- writes them in "file.txt" (deletes duplicates xo)
unionFiles (x:xs) = do 
            a<-readFile x
            appendFile "file.txt" $ a ++ "\n"
            b<- readFile "file.txt"
            let c=lines b
            let d=nub c
            sequence (map (writeFile "file.txt") d )
            unionFiles xs

printContents::[String]->[Cond]->IO()
printContents file constraints = do 
                                      if(length file==1)
                                      -- if its only one file it will write its contents in single.txt
                                          then do 
                                          writeFile "file.txt" ""
                                          l<-readFile $ file!!0
                                          let line=lines l
                                          let triplet=splitTriplet (line!!0)
                                          let bool=evalString "SUB" (noBrackets(triplet !! 0)) (constraints!!0)
                                          print (noBrackets (triplet !! 1))
                                          print bool
                                       --   appendFile "file.txt" (correctOutput!!0)
                                      -- if there are multiple files it will write all of their contents in more.txt
                                      else do
                                          unionFiles file

evalInt::Int->Cond->Bool
evalInt s (Less a b)= s<b
evalInt s (Greater a b)=s>b
evalInt s (LessOr a b)=s<=b
evalInt s (GreaterOr a b)=s>=b
evalInt s (EqStringInt a b)=s==b
evalInt s (And a b)=evalInt s a && evalInt s b
evalInt s (Or a b)=evalInt s a || evalInt s b

evalString::String->String->Cond->Bool
evalString field s (EqString a b) = field==a && s==b
evalString field s (And (EqString a b) (EqString c d)) | field==a = s==b 
                                                       | field==c = s==d
                                                       | otherwise = False
evalString field s (And _ (EqString a b)) | field==a =s==b
                                          | otherwise = False 
evalString field s (And (EqString a b) _) | field==a =s==b
                                          | otherwise = False
evalString field s (Or (EqString a b) (EqString c d)) | field == a && field==b = s==b || s==d
                                                      | field == a = s==b
                                                      | field == b = s==d
                                                      | otherwise = False
evalString field s (Or _ (EqString a b))| field == a = s==b
                                        | otherwise = False
evalString field s (Or (EqString a b) _)| field == a = s==b
                                        | otherwise = False 
evalString field s (And a b)=evalString field s a && evalString field s b
evalString field s (Or a b)=evalString field s a || evalString field s b

evalBool::Bool->Cond->Bool
evalBool s (EqStringBool a b)=s==b
evalBool s (And a b)=evalBool s a && evalBool s b
evalBool s (Or a b)=evalBool s a || evalBool s b



makeInt::String->Int
makeInt a= read a

splitTriplet::String->[String]
splitTriplet triplet = words triplet

getFirst:: (String,String,String)->String
getFirst (a,b,c) = a

getSecond::  (String,String,String)->String
getSecond (a,b,c) = b

getThird::  (String,String,String)->String
getThird (a,b,c) = c

-- getConditions::Cond->[(String,String,String)]
-- getConditions (Less a b)=[(show a,"<",show b)]
-- getConditions (Greater a b)=[(show a,">",show b)]
-- getConditions (LessOr a b)=[(show a,"<=",show b)]
-- getConditions (GreaterOr a b)=[(show a,">=",show b)]
-- getConditions (EqString a b)=[(a,"=",b)]
-- getConditions (EqStringInt a b)=[(a,"=",show b)]
-- getConditions (EqStringBool a b)=[(a,"=",show b)]
-- getConditions (And a b)=getConditions a  ++getConditions b 
-- getConditions (Or a b)=getConditions a ++getConditions b 

findConditions::Expr->[Cond]
findConditions (SimplePrint a)=[]
findConditions (UnionPrint a)=[]
findConditions (Get a)=[]
findConditions (Add a)=[]
findConditions (Delete a)=[]
findConditions (Where a)= [a]
findConditions (Print a b)=findConditions b
findConditions (End a)=findConditions a
findConditions (Seq a b)=findConditions a++findConditions b

linkToString::String->String
linkToString s = noBrackets s

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

parseError :: [Token] -> a
parseError [] = error "error somewhere"
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

main = do
     contents <- readFile "language.txt"
     let tokens = alexScanTokens contents
     let result = parseCalc tokens
     let files = getFiles result
--solution problem 1      printContents files
     let constraints = findConditions result
     print constraints
     printContents files constraints
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
