{-# OPTIONS_GHC -w #-}
module LangParser where
import Lexer
import System.Environment
import System.IO
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
happyExpList = Happy_Data_Array.listArray (0,91) ([0,512,0,0,32,0,0,512,0,0,0,0,0,2,0,128,32,0,8,2,16384,2432,0,2048,512,0,0,0,0,38916,0,0,0,0,28704,0,0,0,16,0,0,1,512,0,0,2048,512,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,384,0,0,0,32768,15,0,32768,0,0,2048,0,0,128,0,0,480,256,0,0,16,0,0,1,512,0,0,32,0,0,2,0,8192,0,0,512,0,0,28704,0,0,1794,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseCalc","Exp","Seq","Cond","Equal","Link","Lit","Number","File","Bool","'('","';'","')'","'<'","'>'","'<='","'>='","'='","','","int","lit","TRUE","FALSE","PRINT","WHERE","UNION","PRED","SUB","OBJ","AND","OR","FROM","NOT","ADD","DELETE","RESTRICT","SORT","GET","URI","file","SELECT","%eof"]
        bit_start = st Prelude.* 44
        bit_end = (st Prelude.+ 1) Prelude.* 44
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..43]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (26) = happyShift action_4
action_0 (4) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (26) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (34) = happyShift action_6
action_2 _ = happyFail (happyExpListPerState 2)

action_3 (44) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (34) = happyShift action_5
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (28) = happyShift action_8
action_5 (42) = happyShift action_9
action_5 (11) = happyGoto action_10
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (28) = happyShift action_8
action_6 (42) = happyShift action_9
action_6 (11) = happyGoto action_7
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (27) = happyShift action_12
action_7 (36) = happyShift action_13
action_7 (37) = happyShift action_14
action_7 (40) = happyShift action_15
action_7 (5) = happyGoto action_11
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (28) = happyShift action_8
action_8 (42) = happyShift action_9
action_8 (11) = happyGoto action_16
action_8 _ = happyFail (happyExpListPerState 8)

action_9 _ = happyReduce_25

action_10 (27) = happyShift action_12
action_10 (36) = happyShift action_13
action_10 (37) = happyShift action_14
action_10 (40) = happyShift action_15
action_10 (5) = happyGoto action_11
action_10 _ = happyReduce_2

action_11 _ = happyReduce_1

action_12 (22) = happyShift action_19
action_12 (29) = happyShift action_25
action_12 (30) = happyShift action_26
action_12 (31) = happyShift action_27
action_12 (6) = happyGoto action_22
action_12 (7) = happyGoto action_23
action_12 (10) = happyGoto action_24
action_12 _ = happyFail (happyExpListPerState 12)

action_13 (41) = happyShift action_21
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (41) = happyShift action_20
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (22) = happyShift action_19
action_15 (10) = happyGoto action_18
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (28) = happyShift action_8
action_16 (42) = happyShift action_9
action_16 (11) = happyGoto action_17
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_24

action_18 _ = happyReduce_4

action_19 _ = happyReduce_23

action_20 _ = happyReduce_6

action_21 _ = happyReduce_5

action_22 (32) = happyShift action_36
action_22 (33) = happyShift action_37
action_22 _ = happyReduce_3

action_23 _ = happyReduce_13

action_24 (16) = happyShift action_31
action_24 (17) = happyShift action_32
action_24 (18) = happyShift action_33
action_24 (19) = happyShift action_34
action_24 (20) = happyShift action_35
action_24 _ = happyFail (happyExpListPerState 24)

action_25 (20) = happyShift action_30
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (20) = happyShift action_29
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (20) = happyShift action_28
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (22) = happyShift action_19
action_28 (23) = happyShift action_52
action_28 (24) = happyShift action_53
action_28 (25) = happyShift action_54
action_28 (41) = happyShift action_46
action_28 (8) = happyGoto action_48
action_28 (9) = happyGoto action_49
action_28 (10) = happyGoto action_50
action_28 (12) = happyGoto action_51
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (41) = happyShift action_46
action_29 (8) = happyGoto action_47
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (41) = happyShift action_46
action_30 (8) = happyGoto action_45
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (22) = happyShift action_19
action_31 (10) = happyGoto action_44
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (22) = happyShift action_19
action_32 (10) = happyGoto action_43
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (22) = happyShift action_19
action_33 (10) = happyGoto action_42
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (22) = happyShift action_19
action_34 (10) = happyGoto action_41
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (22) = happyShift action_19
action_35 (10) = happyGoto action_40
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (22) = happyShift action_19
action_36 (29) = happyShift action_25
action_36 (30) = happyShift action_26
action_36 (31) = happyShift action_27
action_36 (6) = happyGoto action_39
action_36 (7) = happyGoto action_23
action_36 (10) = happyGoto action_24
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (22) = happyShift action_19
action_37 (29) = happyShift action_25
action_37 (30) = happyShift action_26
action_37 (31) = happyShift action_27
action_37 (6) = happyGoto action_38
action_37 (7) = happyGoto action_23
action_37 (10) = happyGoto action_24
action_37 _ = happyFail (happyExpListPerState 37)

action_38 _ = happyReduce_12

action_39 _ = happyReduce_11

action_40 _ = happyReduce_14

action_41 _ = happyReduce_10

action_42 _ = happyReduce_9

action_43 _ = happyReduce_8

action_44 _ = happyReduce_7

action_45 _ = happyReduce_16

action_46 _ = happyReduce_21

action_47 _ = happyReduce_15

action_48 _ = happyReduce_17

action_49 _ = happyReduce_19

action_50 _ = happyReduce_20

action_51 _ = happyReduce_18

action_52 _ = happyReduce_22

action_53 _ = happyReduce_26

action_54 _ = happyReduce_27

happyReduce_1 = happyReduce 4 4 happyReduction_1
happyReduction_1 ((HappyAbsSyn5  happy_var_4) `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Print happy_var_3 happy_var_4
	) `HappyStk` happyRest

happyReduce_2 = happySpecReduce_3  4 happyReduction_2
happyReduction_2 (HappyAbsSyn11  happy_var_3)
	_
	_
	 =  HappyAbsSyn4
		 (SimplePrint happy_var_3
	)
happyReduction_2 _ _ _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (Where happy_var_2
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_2  5 happyReduction_4
happyReduction_4 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (Get happy_var_2
	)
happyReduction_4 _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_2  5 happyReduction_5
happyReduction_5 (HappyTerminal (TokenURIValue p happy_var_2))
	_
	 =  HappyAbsSyn5
		 (Add happy_var_2
	)
happyReduction_5 _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  5 happyReduction_6
happyReduction_6 (HappyTerminal (TokenURIValue p happy_var_2))
	_
	 =  HappyAbsSyn5
		 (Delete happy_var_2
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  6 happyReduction_7
happyReduction_7 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn6
		 (Less happy_var_1 happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  6 happyReduction_8
happyReduction_8 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn6
		 (Greater happy_var_1 happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  6 happyReduction_9
happyReduction_9 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn6
		 (LessOr happy_var_1 happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happySpecReduce_3  6 happyReduction_10
happyReduction_10 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn6
		 (GreaterOr happy_var_1 happy_var_3
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  6 happyReduction_11
happyReduction_11 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (And happy_var_1 happy_var_3
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_3  6 happyReduction_12
happyReduction_12 (HappyAbsSyn6  happy_var_3)
	_
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (Or happy_var_1 happy_var_3
	)
happyReduction_12 _ _ _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  6 happyReduction_13
happyReduction_13 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  7 happyReduction_14
happyReduction_14 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn7
		 (EqInt happy_var_1 happy_var_3
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  7 happyReduction_15
happyReduction_15 (HappyAbsSyn8  happy_var_3)
	_
	(HappyTerminal (TokenSub p happy_var_1))
	 =  HappyAbsSyn7
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  7 happyReduction_16
happyReduction_16 (HappyAbsSyn8  happy_var_3)
	_
	(HappyTerminal (TokenPred p happy_var_1))
	 =  HappyAbsSyn7
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  7 happyReduction_17
happyReduction_17 (HappyAbsSyn8  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn7
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  7 happyReduction_18
happyReduction_18 (HappyAbsSyn12  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn7
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  7 happyReduction_19
happyReduction_19 (HappyAbsSyn9  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn7
		 (EqString happy_var_1 happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  7 happyReduction_20
happyReduction_20 (HappyAbsSyn10  happy_var_3)
	_
	(HappyTerminal (TokenObj p happy_var_1))
	 =  HappyAbsSyn7
		 (EqStringInt happy_var_1 happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  8 happyReduction_21
happyReduction_21 (HappyTerminal (TokenURIValue p happy_var_1))
	 =  HappyAbsSyn8
		 (happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  9 happyReduction_22
happyReduction_22 (HappyTerminal (TokenLiteral p happy_var_1))
	 =  HappyAbsSyn9
		 (happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_1  10 happyReduction_23
happyReduction_23 (HappyTerminal (TokenInt p happy_var_1))
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_23 _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  11 happyReduction_24
happyReduction_24 (HappyAbsSyn11  happy_var_3)
	(HappyAbsSyn11  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (Union happy_var_2 happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_1  11 happyReduction_25
happyReduction_25 (HappyTerminal (TokenFile p happy_var_1))
	 =  HappyAbsSyn11
		 (File happy_var_1
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_1  12 happyReduction_26
happyReduction_26 (HappyTerminal (TokenTrue p happy_var_1))
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_1  12 happyReduction_27
happyReduction_27 (HappyTerminal (TokenFalse p happy_var_1))
	 =  HappyAbsSyn12
		 (happy_var_1
	)
happyReduction_27 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 44 44 notHappyAtAll (HappyState action) sts stk []

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
	TokenSort p -> cont 39;
	TokenGet p -> cont 40;
	TokenURIValue p happy_dollar_dollar -> cont 41;
	TokenFile p happy_dollar_dollar -> cont 42;
	TokenSelect p -> cont 43;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 44 tk tks = happyError' (tks, explist)
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


data Expr=  Print File Expr 
          | SimplePrint File
          | Where Cond
          | Get Int
          | Add String 
          | Delete String 
         deriving (Show,Eq)

data Cond = Less Int Int 
          | Greater Int Int 
          | LessOr Int Int 
          | GreaterOr Int Int 
          | EqInt Int Int
          | EqString String String
          | EqStringInt String Int
          | EqStringBool String Bool
          | Not Cond 
          | And Cond Cond 
          | Or Cond Cond 
          deriving (Show, Eq)

data File = File String | Union File File  deriving (Show,Eq)

parseError :: [Token] -> a
parseError (b:bs) = error $ "Incorrect syntax -----> " ++ tokenPosn b ++" "++ show b

-- main = do
--      contents <- readFile "test.ttl"
--      let tokens = alexScanTokens contents
--      let result = parseCalc tokens
--      print result
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
