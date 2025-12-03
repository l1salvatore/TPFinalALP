{-# OPTIONS_GHC -w #-}
module Parser.Parser where
import AST
import Parser.Lexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14
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
	| HappyAbsSyn13 t13
	| HappyAbsSyn14 t14

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,94) ([49152,1,0,112,0,0,0,0,0,16,0,8,0,0,0,0,0,1792,0,0,0,0,0,256,0,128,0,56,0,0,272,0,0,0,0,0,0,4096,0,4110,0,0,0,0,2048,0,8192,0,0,8,0,12,0,0,64,0,8192,0,0,0,0,0,0,0,0,0,0,0,272,0,1024,0,0,16,0,0,0,8384,4,0,1280,0,0,0,0,0,0,0,0,33152,0,0,0,0,0,0,8384,4,16384,0,0,3,0,0,0,0,0,0,0,0,3072,0,0,280,0,8384,4,12288,264,0,2,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseEscapeRoom","GameDefinition","Definition","Type","Declarations","Declaration","Elements","Sentences","Sentence","Command","ShowMode","Condition","game","target","item","unlock","elements","onuse","if","show","locked","unlocked","is","and","or","'{'","'}'","'('","')'","':'","','","\"->\"","objectname","number","string","%eof"]
        bit_start = st Prelude.* 38
        bit_end = (st Prelude.+ 1) Prelude.* 38
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..37]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (15) = happyShift action_4
action_0 (16) = happyShift action_5
action_0 (17) = happyShift action_6
action_0 (4) = happyGoto action_7
action_0 (5) = happyGoto action_2
action_0 (6) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (15) = happyShift action_4
action_1 (16) = happyShift action_5
action_1 (17) = happyShift action_6
action_1 (5) = happyGoto action_2
action_1 (6) = happyGoto action_3
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (35) = happyShift action_10
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (28) = happyShift action_9
action_4 _ = happyFail (happyExpListPerState 4)

action_5 _ = happyReduce_5

action_6 _ = happyReduce_6

action_7 (15) = happyShift action_4
action_7 (16) = happyShift action_5
action_7 (17) = happyShift action_6
action_7 (38) = happyAccept
action_7 (5) = happyGoto action_8
action_7 (6) = happyGoto action_3
action_7 _ = happyFail (happyExpListPerState 7)

action_8 _ = happyReduce_2

action_9 (35) = happyShift action_13
action_9 (9) = happyGoto action_12
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (28) = happyShift action_11
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (18) = happyShift action_18
action_11 (19) = happyShift action_19
action_11 (20) = happyShift action_20
action_11 (7) = happyGoto action_16
action_11 (8) = happyGoto action_17
action_11 _ = happyFail (happyExpListPerState 11)

action_12 (29) = happyShift action_14
action_12 (33) = happyShift action_15
action_12 _ = happyFail (happyExpListPerState 12)

action_13 _ = happyReduce_12

action_14 _ = happyReduce_3

action_15 (35) = happyShift action_13
action_15 (9) = happyGoto action_26
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (18) = happyShift action_18
action_16 (19) = happyShift action_19
action_16 (20) = happyShift action_20
action_16 (29) = happyShift action_25
action_16 (8) = happyGoto action_24
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_7

action_18 (32) = happyShift action_23
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (28) = happyShift action_22
action_19 _ = happyFail (happyExpListPerState 19)

action_20 (28) = happyShift action_21
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (21) = happyShift action_32
action_21 (22) = happyShift action_33
action_21 (10) = happyGoto action_29
action_21 (11) = happyGoto action_30
action_21 (12) = happyGoto action_31
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (35) = happyShift action_13
action_22 (9) = happyGoto action_28
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (36) = happyShift action_27
action_23 _ = happyFail (happyExpListPerState 23)

action_24 _ = happyReduce_8

action_25 _ = happyReduce_4

action_26 _ = happyReduce_13

action_27 _ = happyReduce_9

action_28 (29) = happyShift action_44
action_28 (33) = happyShift action_15
action_28 _ = happyFail (happyExpListPerState 28)

action_29 (29) = happyShift action_43
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (33) = happyShift action_42
action_30 _ = happyReduce_14

action_31 _ = happyReduce_17

action_32 (23) = happyShift action_38
action_32 (24) = happyShift action_39
action_32 (30) = happyShift action_40
action_32 (35) = happyShift action_41
action_32 (14) = happyGoto action_37
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (35) = happyShift action_35
action_33 (37) = happyShift action_36
action_33 (13) = happyGoto action_34
action_33 _ = happyFail (happyExpListPerState 33)

action_34 _ = happyReduce_18

action_35 _ = happyReduce_19

action_36 _ = happyReduce_20

action_37 (26) = happyShift action_48
action_37 (27) = happyShift action_49
action_37 (34) = happyShift action_50
action_37 _ = happyFail (happyExpListPerState 37)

action_38 _ = happyReduce_21

action_39 _ = happyReduce_22

action_40 (23) = happyShift action_38
action_40 (24) = happyShift action_39
action_40 (30) = happyShift action_40
action_40 (35) = happyShift action_41
action_40 (14) = happyGoto action_47
action_40 _ = happyFail (happyExpListPerState 40)

action_41 (25) = happyShift action_46
action_41 _ = happyFail (happyExpListPerState 41)

action_42 (21) = happyShift action_32
action_42 (22) = happyShift action_33
action_42 (10) = happyGoto action_45
action_42 (11) = happyGoto action_30
action_42 (12) = happyGoto action_31
action_42 _ = happyFail (happyExpListPerState 42)

action_43 _ = happyReduce_11

action_44 _ = happyReduce_10

action_45 _ = happyReduce_15

action_46 (23) = happyShift action_55
action_46 (24) = happyShift action_56
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (26) = happyShift action_48
action_47 (27) = happyShift action_49
action_47 (31) = happyShift action_54
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (23) = happyShift action_38
action_48 (24) = happyShift action_39
action_48 (30) = happyShift action_40
action_48 (35) = happyShift action_41
action_48 (14) = happyGoto action_53
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (23) = happyShift action_38
action_49 (24) = happyShift action_39
action_49 (30) = happyShift action_40
action_49 (35) = happyShift action_41
action_49 (14) = happyGoto action_52
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (22) = happyShift action_33
action_50 (12) = happyGoto action_51
action_50 _ = happyFail (happyExpListPerState 50)

action_51 _ = happyReduce_16

action_52 (26) = happyShift action_48
action_52 _ = happyReduce_26

action_53 _ = happyReduce_25

action_54 _ = happyReduce_27

action_55 _ = happyReduce_23

action_56 _ = happyReduce_24

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn4
		 ([happy_var_1]
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_2  4 happyReduction_2
happyReduction_2 (HappyAbsSyn5  happy_var_2)
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (happy_var_2 : happy_var_1
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happyReduce 4 5 happyReduction_3
happyReduction_3 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (Game happy_var_3
	) `HappyStk` happyRest

happyReduce_4 = happyReduce 5 5 happyReduction_4
happyReduction_4 (_ `HappyStk`
	(HappyAbsSyn7  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenIdent happy_var_2)) `HappyStk`
	(HappyAbsSyn6  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (ObjectDef happy_var_1 happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_5 = happySpecReduce_1  6 happyReduction_5
happyReduction_5 _
	 =  HappyAbsSyn6
		 (TTarget
	)

happyReduce_6 = happySpecReduce_1  6 happyReduction_6
happyReduction_6 _
	 =  HappyAbsSyn6
		 (TItem
	)

happyReduce_7 = happySpecReduce_1  7 happyReduction_7
happyReduction_7 (HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn7
		 ([happy_var_1]
	)
happyReduction_7 _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_2  7 happyReduction_8
happyReduction_8 (HappyAbsSyn8  happy_var_2)
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_2 : happy_var_1
	)
happyReduction_8 _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_3  8 happyReduction_9
happyReduction_9 (HappyTerminal (TokenNumber happy_var_3))
	_
	_
	 =  HappyAbsSyn8
		 (Unlock happy_var_3
	)
happyReduction_9 _ _ _  = notHappyAtAll 

happyReduce_10 = happyReduce 4 8 happyReduction_10
happyReduction_10 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (Elements happy_var_3
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 4 8 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (OnUse happy_var_3
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_1  9 happyReduction_12
happyReduction_12 (HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn9
		 ([happy_var_1]
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  9 happyReduction_13
happyReduction_13 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1 ++ happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  10 happyReduction_14
happyReduction_14 (HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 ([happy_var_1]
	)
happyReduction_14 _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  10 happyReduction_15
happyReduction_15 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn11  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1 : happy_var_3
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happyReduce 4 11 happyReduction_16
happyReduction_16 ((HappyAbsSyn12  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn14  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (IfCommand happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_17 = happySpecReduce_1  11 happyReduction_17
happyReduction_17 (HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn11
		 (Command happy_var_1
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_2  12 happyReduction_18
happyReduction_18 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (Show happy_var_2
	)
happyReduction_18 _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_1  13 happyReduction_19
happyReduction_19 (HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn13
		 (ShowObject happy_var_1
	)
happyReduction_19 _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  13 happyReduction_20
happyReduction_20 (HappyTerminal (TokenString happy_var_1))
	 =  HappyAbsSyn13
		 (ShowMessage happy_var_1
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  14 happyReduction_21
happyReduction_21 _
	 =  HappyAbsSyn14
		 (Locked
	)

happyReduce_22 = happySpecReduce_1  14 happyReduction_22
happyReduction_22 _
	 =  HappyAbsSyn14
		 (Unlocked
	)

happyReduce_23 = happySpecReduce_3  14 happyReduction_23
happyReduction_23 _
	_
	(HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn14
		 (ObjectLocked happy_var_1
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  14 happyReduction_24
happyReduction_24 _
	_
	(HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn14
		 (ObjectUnlocked happy_var_1
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  14 happyReduction_25
happyReduction_25 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (And happy_var_1 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  14 happyReduction_26
happyReduction_26 (HappyAbsSyn14  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn14
		 (Or happy_var_1 happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_3  14 happyReduction_27
happyReduction_27 _
	(HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn14
		 (happy_var_2
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 38 38 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TokenGame -> cont 15;
	TokenTarget -> cont 16;
	TokenItem -> cont 17;
	TokenUnlock -> cont 18;
	TokenElements -> cont 19;
	TokenOnUse -> cont 20;
	TokenIf -> cont 21;
	TokenShow -> cont 22;
	TokenLocked -> cont 23;
	TokenUnlocked -> cont 24;
	TokenIs -> cont 25;
	TokenAnd -> cont 26;
	TokenOr -> cont 27;
	TokenLBrace -> cont 28;
	TokenRBrace -> cont 29;
	TokenLPar -> cont 30;
	TokenRPar -> cont 31;
	TokenColon -> cont 32;
	TokenComma -> cont 33;
	TokenArrow -> cont 34;
	TokenIdent happy_dollar_dollar -> cont 35;
	TokenNumber happy_dollar_dollar -> cont 36;
	TokenString happy_dollar_dollar -> cont 37;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 38 tk tks = happyError' (tks, explist)
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
parseEscapeRoom tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> a
parseError _ = error "Parse error"
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
