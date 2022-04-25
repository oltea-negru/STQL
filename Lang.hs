{-# OPTIONS_GHC -w #-}
module Lang where 
import Lexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.0

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11
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

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,94) ([0,512,0,0,4,0,0,8,128,24608,1,0,32,0,256,16,4,0,0,0,0,0,112,0,0,128,0,0,1,256,0,0,0,8,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,0,3072,0,192,0,32768,1,0,1008,0,0,0,0,0,32768,0,0,0,32768,0,0,256,0,0,2,0,1024,0,0,120,16,61440,8192,0,0,64,0,32768,0,0,256,0,0,2,0,7,0,3584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseLang","Exp","Seq","Cond","Uri","Lit","Number","File","Bool","'('","';'","')'","'<'","'>'","'<='","'>='","'='","NOT","','","int","lit","TRUE","FALSE","PRINT","WHERE","UNION","PRED","SUB","OBJ","AND","OR","FROM","ADD","DELETE","RESTRICT","GET","URI","file","%eof"]
        bit_start = st Prelude.* 41
        bit_end = (st Prelude.+ 1) Prelude.* 41
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..40]
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

action_3 (13) = happyShift action_7
action_3 (27) = happyShift action_8
action_3 (35) = happyShift action_9
action_3 (36) = happyShift action_10
action_3 (38) = happyShift action_11
action_3 (41) = happyAccept
action_3 (5) = happyGoto action_6
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (34) = happyShift action_5
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (28) = happyShift action_24
action_5 (40) = happyShift action_14
action_5 (10) = happyGoto action_13
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (13) = happyShift action_23
action_6 _ = happyFail (happyExpListPerState 6)

action_7 _ = happyReduce_3

action_8 (29) = happyShift action_20
action_8 (30) = happyShift action_21
action_8 (31) = happyShift action_22
action_8 (6) = happyGoto action_19
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (39) = happyShift action_18
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (39) = happyShift action_17
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (22) = happyShift action_16
action_11 (9) = happyGoto action_15
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (40) = happyShift action_14
action_12 (10) = happyGoto action_13
action_12 _ = happyFail (happyExpListPerState 12)

action_13 _ = happyReduce_1

action_14 (40) = happyShift action_14
action_14 (10) = happyGoto action_38
action_14 _ = happyReduce_30

action_15 _ = happyReduce_6

action_16 _ = happyReduce_29

action_17 _ = happyReduce_8

action_18 _ = happyReduce_7

action_19 (32) = happyShift action_36
action_19 (33) = happyShift action_37
action_19 _ = happyReduce_5

action_20 (19) = happyShift action_34
action_20 (20) = happyShift action_35
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (19) = happyShift action_32
action_21 (20) = happyShift action_33
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (15) = happyShift action_26
action_22 (16) = happyShift action_27
action_22 (17) = happyShift action_28
action_22 (18) = happyShift action_29
action_22 (19) = happyShift action_30
action_22 (20) = happyShift action_31
action_22 _ = happyFail (happyExpListPerState 22)

action_23 _ = happyReduce_4

action_24 (40) = happyShift action_14
action_24 (10) = happyGoto action_25
action_24 _ = happyFail (happyExpListPerState 24)

action_25 _ = happyReduce_2

action_26 (22) = happyShift action_16
action_26 (9) = happyGoto action_60
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (22) = happyShift action_16
action_27 (9) = happyGoto action_59
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (22) = happyShift action_16
action_28 (9) = happyGoto action_58
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (22) = happyShift action_16
action_29 (9) = happyGoto action_57
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (22) = happyShift action_16
action_30 (23) = happyShift action_50
action_30 (24) = happyShift action_51
action_30 (25) = happyShift action_52
action_30 (39) = happyShift action_42
action_30 (7) = happyGoto action_53
action_30 (8) = happyGoto action_54
action_30 (9) = happyGoto action_55
action_30 (11) = happyGoto action_56
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (22) = happyShift action_16
action_31 (23) = happyShift action_50
action_31 (24) = happyShift action_51
action_31 (25) = happyShift action_52
action_31 (39) = happyShift action_42
action_31 (7) = happyGoto action_46
action_31 (8) = happyGoto action_47
action_31 (9) = happyGoto action_48
action_31 (11) = happyGoto action_49
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (39) = happyShift action_42
action_32 (7) = happyGoto action_45
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (39) = happyShift action_42
action_33 (7) = happyGoto action_44
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (39) = happyShift action_42
action_34 (7) = happyGoto action_43
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (39) = happyShift action_42
action_35 (7) = happyGoto action_41
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (29) = happyShift action_20
action_36 (30) = happyShift action_21
action_36 (31) = happyShift action_22
action_36 (6) = happyGoto action_40
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (29) = happyShift action_20
action_37 (30) = happyShift action_21
action_37 (31) = happyShift action_22
action_37 (6) = happyGoto action_39
action_37 _ = happyFail (happyExpListPerState 37)

action_38 _ = happyReduce_31

action_39 _ = happyReduce_26

action_40 _ = happyReduce_25

action_41 _ = happyReduce_20

action_42 _ = happyReduce_27

action_43 _ = happyReduce_10

action_44 _ = happyReduce_19

action_45 _ = happyReduce_9

action_46 _ = happyReduce_21

action_47 _ = happyReduce_22

action_48 _ = happyReduce_23

action_49 _ = happyReduce_24

action_50 _ = happyReduce_28

action_51 _ = happyReduce_32

action_52 _ = happyReduce_33

action_53 _ = happyReduce_11

action_54 _ = happyReduce_17

action_55 _ = happyReduce_18

action_56 _ = happyReduce_16

action_57 _ = happyReduce_14

action_58 _ = happyReduce_13

action_59 _ = happyReduce_12

action_60 _ = happyReduce_15

happyReduce_1 = happySpecReduce_3  4 happyReduction_1
happyReduction_1 (HappyAbsSyn10  happy_var_3)
	_
	_
	 =  HappyAbsSyn4
		 (SimplePrint happy_var_3
	)
happyReduction_1 _ _ _  = notHappyAtAll 

happyReduce_2 = happyReduce 4 4 happyReduction_2
happyReduction_2 ((HappyAbsSyn10  happy_var_4) `HappyStk`
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
		 (Finish happy_var_1
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  4 happyReduction_4
happyReduction_4 _
	(HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (Path happy_var_1 happy_var_2
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
happyReduction_6 (HappyAbsSyn9  happy_var_2)
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
happyReduction_9 (HappyAbsSyn7  happy_var_3)
	_
	(HappyTerminal (TokenSub p happy_var_1))
	 =  HappyAbsSyn6
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  6 happyReduction_10
happyReduction_10 (HappyAbsSyn7  happy_var_3)
	_
	(HappyTerminal (TokenPred p happy_var_1))
	 =  HappyAbsSyn6
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  6 happyReduction_11
happyReduction_11 (HappyAbsSyn7  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  6 happyReduction_12
happyReduction_12 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (Greater happy_var_1 happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  6 happyReduction_13
happyReduction_13 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (LessOr happy_var_1 happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  6 happyReduction_14
happyReduction_14 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (GreaterOr happy_var_1 happy_var_3
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  6 happyReduction_15
happyReduction_15 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (Less happy_var_1 happy_var_3
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  6 happyReduction_16
happyReduction_16 (HappyAbsSyn11  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (EqBool happy_var_1 happy_var_3
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  6 happyReduction_17
happyReduction_17 (HappyAbsSyn8  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  6 happyReduction_18
happyReduction_18 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (EqInt happy_var_1 happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  6 happyReduction_19
happyReduction_19 (HappyAbsSyn7  happy_var_3)
	_
	(HappyTerminal (TokenSub p happy_var_1))
	 =  HappyAbsSyn6
		 (NotEqString happy_var_1 happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  6 happyReduction_20
happyReduction_20 (HappyAbsSyn7  happy_var_3)
	_
	(HappyTerminal (TokenPred p happy_var_1))
	 =  HappyAbsSyn6
		 (NotEqString happy_var_1 happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  6 happyReduction_21
happyReduction_21 (HappyAbsSyn7  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (NotEqString happy_var_1 happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  6 happyReduction_22
happyReduction_22 (HappyAbsSyn8  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (NotEqString happy_var_1 happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  6 happyReduction_23
happyReduction_23 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (NotEqInt happy_var_1 happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  6 happyReduction_24
happyReduction_24 (HappyAbsSyn11  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn6
		 (NotEqBool happy_var_1 happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  6 happyReduction_25
happyReduction_25 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (And happy_var_1 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  6 happyReduction_26
happyReduction_26 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Or happy_var_1 happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  7 happyReduction_27
happyReduction_27 (HappyTerminal (TokenURIValue p happy_var_1))
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  8 happyReduction_28
happyReduction_28 (HappyTerminal (TokenLiteral p happy_var_1))
	 =  HappyAbsSyn8
		 (happy_var_1
	)
happyReduction_28 _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  9 happyReduction_29
happyReduction_29 (HappyTerminal (TokenInt p happy_var_1))
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  10 happyReduction_30
happyReduction_30 (HappyTerminal (TokenFile p happy_var_1))
	 =  HappyAbsSyn10
		 (OneFile happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_2  10 happyReduction_31
happyReduction_31 (HappyAbsSyn10  happy_var_2)
	(HappyTerminal (TokenFile p happy_var_1))
	 =  HappyAbsSyn10
		 (MoreFiles  happy_var_1 happy_var_2
	)
happyReduction_31 _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  11 happyReduction_32
happyReduction_32 (HappyTerminal (TokenTrue p happy_var_1))
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  11 happyReduction_33
happyReduction_33 (HappyTerminal (TokenFalse p happy_var_1))
	 =  HappyAbsSyn11
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 41 41 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TokenLBrack p -> cont 12;
	TokenSemiColon p -> cont 13;
	TokenRBrack p -> cont 14;
	TokenLess p -> cont 15;
	TokenGreater p -> cont 16;
	TokenLessEq p -> cont 17;
	TokenGreaterEq p -> cont 18;
	TokenEquals p -> cont 19;
	TokenNot p -> cont 20;
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
	TokenAdd p -> cont 35;
	TokenDelete p -> cont 36;
	TokenRestrict p -> cont 37;
	TokenGet p -> cont 38;
	TokenURIValue p happy_dollar_dollar -> cont 39;
	TokenFile p happy_dollar_dollar -> cont 40;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 41 tk tks = happyError' (tks, explist)
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
parseLang tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError [] = error "No Tokens"
parseError (b : bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++ " " ++ show b

data Expr=  Print Files Expr 
          | Finish Expr
          | Path Expr Expr
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
          | EqInt String Int
          | EqBool String Bool
          | NotEqString String String
          | NotEqInt String Int  
          | NotEqBool String Bool
          | And Cond Cond 
          | Or Cond Cond 
          deriving (Show, Eq)

data Files = OneFile String | MoreFiles String Files  deriving (Show,Eq)
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
