{-# OPTIONS_GHC -w #-}
module Parser where
import AST
import Lexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25 t26
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
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19
	| HappyAbsSyn20 t20
	| HappyAbsSyn21 t21
	| HappyAbsSyn22 t22
	| HappyAbsSyn23 t23
	| HappyAbsSyn24 t24
	| HappyAbsSyn25 t25
	| HappyAbsSyn26 t26

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,208) ([0,7168,0,0,0,224,0,0,0,0,0,0,0,128,0,0,0,0,8,0,0,16384,0,28672,0,0,0,0,0,0,0,16384,0,0,0,512,0,0,30720,0,0,0,960,1,0,0,0,0,0,0,2048,0,0,0,64,0,0,0,2,0,0,4096,0,0,3840,0,0,0,120,0,0,49152,259,0,0,7680,8,0,0,32768,0,0,0,1024,0,0,0,32,0,0,0,1,0,0,0,0,0,0,0,0,0,24576,40968,6,0,0,2048,0,0,0,32,0,0,0,1,0,0,0,0,0,0,0,0,0,16,0,0,0,8,0,0,2048,0,0,0,32,0,0,0,16,0,0,0,1,0,0,64,0,0,0,32,0,0,0,512,0,0,128,0,0,0,16896,0,0,0,0,0,0,4096,4,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,6144,43010,1,0,4288,3392,0,0,128,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,32768,128,0,0,0,32,0,49152,16400,13,0,34304,27136,0,0,1072,848,0,0,0,26,0,0,53248,0,0,0,0,0,0,0,0,0,0,16384,0,0,0,0,0,0,0,104,0,0,16384,0,0,0,0,0,0,0,32,0,0,32768,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,0,0,0,0,2048,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,8192,0,0,0,0,0,0,0,16,0,0,0,2,0,0,0,32,0,0,0,0,0,0,2048,0,0,4,0,0,0,4096,0,0,0,8192,0,0,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,16384,1,8,0,0,0,0,0,0,0,0,0,8192,0,0,0,32768,6,0,0,13312,0,0,8704,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseEscapeRoom","GameDefinitions","Definition","Declarations","Declaration","UnlockConditions","Actions","Action","ActionReturnType","Command","Elements","Element","Assignments","Assignment","Exp","SimpleExp","ComparisonExp","BoolExp","AndExp","NotExp","AtomicBool","Chained","ChainedBase","Args","game","target","object","unlock","elements","init","actions","return","as","show","true","false","'{'","'}'","'['","']'","'('","')'","':'","','","'='","'.'","\"==\"","\"->\"","\"&&\"","\"||\"","\"!\"","\"!=\"","ident","type","number","string","%eof"]
        bit_start = st Prelude.* 59
        bit_end = (st Prelude.+ 1) Prelude.* 59
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..58]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (27) = happyShift action_3
action_0 (28) = happyShift action_4
action_0 (29) = happyShift action_5
action_0 (4) = happyGoto action_6
action_0 (5) = happyGoto action_2
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (27) = happyShift action_3
action_1 (28) = happyShift action_4
action_1 (29) = happyShift action_5
action_1 (5) = happyGoto action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (39) = happyShift action_10
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (56) = happyShift action_9
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (56) = happyShift action_8
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (27) = happyShift action_3
action_6 (28) = happyShift action_4
action_6 (29) = happyShift action_5
action_6 (59) = happyAccept
action_6 (5) = happyGoto action_7
action_6 _ = happyFail (happyExpListPerState 6)

action_7 _ = happyReduce_2

action_8 (39) = happyShift action_18
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (39) = happyShift action_17
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (30) = happyShift action_13
action_10 (31) = happyShift action_14
action_10 (32) = happyShift action_15
action_10 (33) = happyShift action_16
action_10 (6) = happyGoto action_11
action_10 (7) = happyGoto action_12
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (30) = happyShift action_13
action_11 (31) = happyShift action_14
action_11 (32) = happyShift action_15
action_11 (33) = happyShift action_16
action_11 (40) = happyShift action_26
action_11 (7) = happyGoto action_25
action_11 _ = happyFail (happyExpListPerState 11)

action_12 _ = happyReduce_6

action_13 (45) = happyShift action_24
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (45) = happyShift action_23
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (45) = happyShift action_22
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (45) = happyShift action_21
action_16 _ = happyFail (happyExpListPerState 16)

action_17 (30) = happyShift action_13
action_17 (31) = happyShift action_14
action_17 (32) = happyShift action_15
action_17 (33) = happyShift action_16
action_17 (6) = happyGoto action_20
action_17 (7) = happyGoto action_12
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (30) = happyShift action_13
action_18 (31) = happyShift action_14
action_18 (32) = happyShift action_15
action_18 (33) = happyShift action_16
action_18 (6) = happyGoto action_19
action_18 (7) = happyGoto action_12
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (30) = happyShift action_13
action_19 (31) = happyShift action_14
action_19 (32) = happyShift action_15
action_19 (33) = happyShift action_16
action_19 (40) = happyShift action_32
action_19 (7) = happyGoto action_25
action_19 _ = happyFail (happyExpListPerState 19)

action_20 (30) = happyShift action_13
action_20 (31) = happyShift action_14
action_20 (32) = happyShift action_15
action_20 (33) = happyShift action_16
action_20 (40) = happyShift action_31
action_20 (7) = happyGoto action_25
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (41) = happyShift action_30
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (41) = happyShift action_29
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (41) = happyShift action_28
action_23 _ = happyFail (happyExpListPerState 23)

action_24 (41) = happyShift action_27
action_24 _ = happyFail (happyExpListPerState 24)

action_25 _ = happyReduce_7

action_26 _ = happyReduce_3

action_27 (37) = happyShift action_51
action_27 (38) = happyShift action_52
action_27 (43) = happyShift action_53
action_27 (53) = happyShift action_54
action_27 (55) = happyShift action_55
action_27 (57) = happyShift action_56
action_27 (58) = happyShift action_57
action_27 (8) = happyGoto action_42
action_27 (18) = happyGoto action_43
action_27 (19) = happyGoto action_44
action_27 (20) = happyGoto action_45
action_27 (21) = happyGoto action_46
action_27 (22) = happyGoto action_47
action_27 (23) = happyGoto action_48
action_27 (24) = happyGoto action_49
action_27 (25) = happyGoto action_50
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (56) = happyShift action_41
action_28 (13) = happyGoto action_39
action_28 (14) = happyGoto action_40
action_28 _ = happyReduce_24

action_29 (55) = happyShift action_38
action_29 (15) = happyGoto action_36
action_29 (16) = happyGoto action_37
action_29 _ = happyReduce_28

action_30 (55) = happyShift action_35
action_30 (9) = happyGoto action_33
action_30 (10) = happyGoto action_34
action_30 _ = happyReduce_14

action_31 _ = happyReduce_4

action_32 _ = happyReduce_5

action_33 (42) = happyShift action_76
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (46) = happyShift action_75
action_34 _ = happyReduce_15

action_35 (43) = happyShift action_74
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (42) = happyShift action_73
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (46) = happyShift action_72
action_37 _ = happyReduce_29

action_38 (47) = happyShift action_71
action_38 _ = happyFail (happyExpListPerState 38)

action_39 (42) = happyShift action_70
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (46) = happyShift action_69
action_40 _ = happyReduce_25

action_41 (55) = happyShift action_68
action_41 _ = happyFail (happyExpListPerState 41)

action_42 (42) = happyShift action_67
action_42 _ = happyFail (happyExpListPerState 42)

action_43 (49) = happyShift action_65
action_43 (54) = happyShift action_66
action_43 _ = happyFail (happyExpListPerState 43)

action_44 _ = happyReduce_47

action_45 (46) = happyShift action_63
action_45 (52) = happyShift action_64
action_45 _ = happyReduce_12

action_46 (51) = happyShift action_62
action_46 _ = happyReduce_39

action_47 _ = happyReduce_41

action_48 _ = happyReduce_43

action_49 _ = happyReduce_34

action_50 (48) = happyShift action_61
action_50 _ = happyReduce_49

action_51 _ = happyReduce_45

action_52 _ = happyReduce_46

action_53 (37) = happyShift action_51
action_53 (38) = happyShift action_52
action_53 (43) = happyShift action_53
action_53 (53) = happyShift action_54
action_53 (55) = happyShift action_55
action_53 (57) = happyShift action_56
action_53 (58) = happyShift action_57
action_53 (18) = happyGoto action_43
action_53 (19) = happyGoto action_44
action_53 (20) = happyGoto action_60
action_53 (21) = happyGoto action_46
action_53 (22) = happyGoto action_47
action_53 (23) = happyGoto action_48
action_53 (24) = happyGoto action_49
action_53 (25) = happyGoto action_50
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (37) = happyShift action_51
action_54 (38) = happyShift action_52
action_54 (43) = happyShift action_53
action_54 (53) = happyShift action_54
action_54 (55) = happyShift action_55
action_54 (57) = happyShift action_56
action_54 (58) = happyShift action_57
action_54 (18) = happyGoto action_43
action_54 (19) = happyGoto action_44
action_54 (22) = happyGoto action_59
action_54 (23) = happyGoto action_48
action_54 (24) = happyGoto action_49
action_54 (25) = happyGoto action_50
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (43) = happyShift action_58
action_55 _ = happyReduce_50

action_56 _ = happyReduce_35

action_57 _ = happyReduce_36

action_58 (55) = happyShift action_92
action_58 (26) = happyGoto action_91
action_58 _ = happyReduce_54

action_59 _ = happyReduce_44

action_60 (44) = happyShift action_90
action_60 (52) = happyShift action_64
action_60 _ = happyFail (happyExpListPerState 60)

action_61 (55) = happyShift action_89
action_61 _ = happyFail (happyExpListPerState 61)

action_62 (37) = happyShift action_51
action_62 (38) = happyShift action_52
action_62 (43) = happyShift action_53
action_62 (53) = happyShift action_54
action_62 (55) = happyShift action_55
action_62 (57) = happyShift action_56
action_62 (58) = happyShift action_57
action_62 (18) = happyGoto action_43
action_62 (19) = happyGoto action_44
action_62 (22) = happyGoto action_88
action_62 (23) = happyGoto action_48
action_62 (24) = happyGoto action_49
action_62 (25) = happyGoto action_50
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (37) = happyShift action_51
action_63 (38) = happyShift action_52
action_63 (43) = happyShift action_53
action_63 (53) = happyShift action_54
action_63 (55) = happyShift action_55
action_63 (57) = happyShift action_56
action_63 (58) = happyShift action_57
action_63 (8) = happyGoto action_87
action_63 (18) = happyGoto action_43
action_63 (19) = happyGoto action_44
action_63 (20) = happyGoto action_45
action_63 (21) = happyGoto action_46
action_63 (22) = happyGoto action_47
action_63 (23) = happyGoto action_48
action_63 (24) = happyGoto action_49
action_63 (25) = happyGoto action_50
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (37) = happyShift action_51
action_64 (38) = happyShift action_52
action_64 (43) = happyShift action_53
action_64 (53) = happyShift action_54
action_64 (55) = happyShift action_55
action_64 (57) = happyShift action_56
action_64 (58) = happyShift action_57
action_64 (18) = happyGoto action_43
action_64 (19) = happyGoto action_44
action_64 (21) = happyGoto action_86
action_64 (22) = happyGoto action_47
action_64 (23) = happyGoto action_48
action_64 (24) = happyGoto action_49
action_64 (25) = happyGoto action_50
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (55) = happyShift action_55
action_65 (57) = happyShift action_56
action_65 (58) = happyShift action_57
action_65 (18) = happyGoto action_85
action_65 (24) = happyGoto action_49
action_65 (25) = happyGoto action_50
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (55) = happyShift action_55
action_66 (57) = happyShift action_56
action_66 (58) = happyShift action_57
action_66 (18) = happyGoto action_84
action_66 (24) = happyGoto action_49
action_66 (25) = happyGoto action_50
action_66 _ = happyFail (happyExpListPerState 66)

action_67 _ = happyReduce_11

action_68 _ = happyReduce_27

action_69 (56) = happyShift action_41
action_69 (13) = happyGoto action_83
action_69 (14) = happyGoto action_40
action_69 _ = happyReduce_24

action_70 _ = happyReduce_8

action_71 (55) = happyShift action_55
action_71 (57) = happyShift action_56
action_71 (58) = happyShift action_57
action_71 (17) = happyGoto action_80
action_71 (18) = happyGoto action_81
action_71 (19) = happyGoto action_82
action_71 (24) = happyGoto action_49
action_71 (25) = happyGoto action_50
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (55) = happyShift action_38
action_72 (15) = happyGoto action_79
action_72 (16) = happyGoto action_37
action_72 _ = happyReduce_28

action_73 _ = happyReduce_9

action_74 (56) = happyShift action_41
action_74 (13) = happyGoto action_78
action_74 (14) = happyGoto action_40
action_74 _ = happyReduce_24

action_75 (55) = happyShift action_35
action_75 (9) = happyGoto action_77
action_75 (10) = happyGoto action_34
action_75 _ = happyReduce_14

action_76 _ = happyReduce_10

action_77 _ = happyReduce_16

action_78 (44) = happyShift action_96
action_78 _ = happyFail (happyExpListPerState 78)

action_79 _ = happyReduce_30

action_80 _ = happyReduce_31

action_81 (49) = happyShift action_65
action_81 (54) = happyShift action_66
action_81 _ = happyReduce_32

action_82 _ = happyReduce_33

action_83 _ = happyReduce_26

action_84 _ = happyReduce_38

action_85 _ = happyReduce_37

action_86 (51) = happyShift action_62
action_86 _ = happyReduce_40

action_87 _ = happyReduce_13

action_88 _ = happyReduce_42

action_89 (43) = happyShift action_95
action_89 _ = happyReduce_52

action_90 _ = happyReduce_48

action_91 (44) = happyShift action_94
action_91 _ = happyFail (happyExpListPerState 91)

action_92 (46) = happyShift action_93
action_92 _ = happyReduce_55

action_93 (55) = happyShift action_92
action_93 (26) = happyGoto action_100
action_93 _ = happyReduce_54

action_94 _ = happyReduce_51

action_95 (55) = happyShift action_92
action_95 (26) = happyGoto action_99
action_95 _ = happyReduce_54

action_96 (35) = happyShift action_98
action_96 (11) = happyGoto action_97
action_96 _ = happyReduce_18

action_97 (50) = happyShift action_103
action_97 _ = happyFail (happyExpListPerState 97)

action_98 (56) = happyShift action_102
action_98 _ = happyFail (happyExpListPerState 98)

action_99 (44) = happyShift action_101
action_99 _ = happyFail (happyExpListPerState 99)

action_100 _ = happyReduce_56

action_101 _ = happyReduce_53

action_102 _ = happyReduce_19

action_103 (34) = happyShift action_107
action_103 (36) = happyShift action_108
action_103 (55) = happyShift action_109
action_103 (12) = happyGoto action_104
action_103 (16) = happyGoto action_105
action_103 (25) = happyGoto action_106
action_103 _ = happyFail (happyExpListPerState 103)

action_104 _ = happyReduce_17

action_105 _ = happyReduce_20

action_106 (48) = happyShift action_61
action_106 _ = happyReduce_21

action_107 (55) = happyShift action_55
action_107 (57) = happyShift action_56
action_107 (58) = happyShift action_57
action_107 (17) = happyGoto action_111
action_107 (18) = happyGoto action_81
action_107 (19) = happyGoto action_82
action_107 (24) = happyGoto action_49
action_107 (25) = happyGoto action_50
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (55) = happyShift action_55
action_108 (57) = happyShift action_56
action_108 (58) = happyShift action_57
action_108 (17) = happyGoto action_110
action_108 (18) = happyGoto action_81
action_108 (19) = happyGoto action_82
action_108 (24) = happyGoto action_49
action_108 (25) = happyGoto action_50
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (43) = happyShift action_58
action_109 (47) = happyShift action_71
action_109 _ = happyReduce_50

action_110 _ = happyReduce_23

action_111 _ = happyReduce_22

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
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happyReduce 4 5 happyReduction_3
happyReduction_3 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (Game happy_var_3
	) `HappyStk` happyRest

happyReduce_4 = happyReduce 5 5 happyReduction_4
happyReduction_4 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenType happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (Target happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_5 = happyReduce 5 5 happyReduction_5
happyReduction_5 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenType happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn5
		 (Object happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_6 = happySpecReduce_1  6 happyReduction_6
happyReduction_6 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn6
		 ([happy_var_1]
	)
happyReduction_6 _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_2  6 happyReduction_7
happyReduction_7 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn6  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1 ++ [happy_var_2]
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happyReduce 5 7 happyReduction_8
happyReduction_8 (_ `HappyStk`
	(HappyAbsSyn13  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Elements happy_var_4
	) `HappyStk` happyRest

happyReduce_9 = happyReduce 5 7 happyReduction_9
happyReduction_9 (_ `HappyStk`
	(HappyAbsSyn15  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Init happy_var_4
	) `HappyStk` happyRest

happyReduce_10 = happyReduce 5 7 happyReduction_10
happyReduction_10 (_ `HappyStk`
	(HappyAbsSyn9  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Actions happy_var_4
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 5 7 happyReduction_11
happyReduction_11 (_ `HappyStk`
	(HappyAbsSyn8  happy_var_4) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Unlock happy_var_4
	) `HappyStk` happyRest

happyReduce_12 = happySpecReduce_1  8 happyReduction_12
happyReduction_12 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_3  8 happyReduction_13
happyReduction_13 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 : happy_var_3
	)
happyReduction_13 _ _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_0  9 happyReduction_14
happyReduction_14  =  HappyAbsSyn9
		 ([]
	)

happyReduce_15 = happySpecReduce_1  9 happyReduction_15
happyReduction_15 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 ([happy_var_1]
	)
happyReduction_15 _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  9 happyReduction_16
happyReduction_16 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1 : happy_var_3
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happyReduce 7 10 happyReduction_17
happyReduction_17 ((HappyAbsSyn12  happy_var_7) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn11  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenIdent happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (ActionDeclare happy_var_1 happy_var_3 happy_var_5 happy_var_7
	) `HappyStk` happyRest

happyReduce_18 = happySpecReduce_0  11 happyReduction_18
happyReduction_18  =  HappyAbsSyn11
		 (Nothing
	)

happyReduce_19 = happySpecReduce_2  11 happyReduction_19
happyReduction_19 (HappyTerminal (TokenType happy_var_2))
	_
	 =  HappyAbsSyn11
		 (Just happy_var_2
	)
happyReduction_19 _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_1  12 happyReduction_20
happyReduction_20 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn12
		 (Assign happy_var_1
	)
happyReduction_20 _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  12 happyReduction_21
happyReduction_21 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn12
		 (ChainedCall happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_2  12 happyReduction_22
happyReduction_22 (HappyAbsSyn17  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (Return happy_var_2
	)
happyReduction_22 _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  12 happyReduction_23
happyReduction_23 (HappyAbsSyn17  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (Show happy_var_2
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_0  13 happyReduction_24
happyReduction_24  =  HappyAbsSyn13
		 ([]
	)

happyReduce_25 = happySpecReduce_1  13 happyReduction_25
happyReduction_25 (HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_25 _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  13 happyReduction_26
happyReduction_26 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 : happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  14 happyReduction_27
happyReduction_27 (HappyTerminal (TokenIdent happy_var_2))
	(HappyTerminal (TokenType happy_var_1))
	 =  HappyAbsSyn14
		 (ElementDeclare happy_var_1 happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_0  15 happyReduction_28
happyReduction_28  =  HappyAbsSyn15
		 ([]
	)

happyReduce_29 = happySpecReduce_1  15 happyReduction_29
happyReduction_29 (HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 ([happy_var_1]
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  15 happyReduction_30
happyReduction_30 (HappyAbsSyn15  happy_var_3)
	_
	(HappyAbsSyn16  happy_var_1)
	 =  HappyAbsSyn15
		 (happy_var_1 : happy_var_3
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_3  16 happyReduction_31
happyReduction_31 (HappyAbsSyn17  happy_var_3)
	_
	(HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn16
		 (Let happy_var_1 happy_var_3
	)
happyReduction_31 _ _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_1  17 happyReduction_32
happyReduction_32 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  17 happyReduction_33
happyReduction_33 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn17
		 (happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  18 happyReduction_34
happyReduction_34 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn18
		 (Chained happy_var_1
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_1  18 happyReduction_35
happyReduction_35 (HappyTerminal (TokenNumber happy_var_1))
	 =  HappyAbsSyn18
		 (Natural happy_var_1
	)
happyReduction_35 _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  18 happyReduction_36
happyReduction_36 (HappyTerminal (TokenString happy_var_1))
	 =  HappyAbsSyn18
		 (Message happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  19 happyReduction_37
happyReduction_37 (HappyAbsSyn18  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 (Eq happy_var_1 happy_var_3
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  19 happyReduction_38
happyReduction_38 (HappyAbsSyn18  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn19
		 (NEq happy_var_1 happy_var_3
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  20 happyReduction_39
happyReduction_39 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_3  20 happyReduction_40
happyReduction_40 (HappyAbsSyn21  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (Or happy_var_1 happy_var_3
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_1  21 happyReduction_41
happyReduction_41 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn21
		 (happy_var_1
	)
happyReduction_41 _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  21 happyReduction_42
happyReduction_42 (HappyAbsSyn22  happy_var_3)
	_
	(HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn21
		 (And happy_var_1 happy_var_3
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_1  22 happyReduction_43
happyReduction_43 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn22
		 (happy_var_1
	)
happyReduction_43 _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_2  22 happyReduction_44
happyReduction_44 (HappyAbsSyn22  happy_var_2)
	_
	 =  HappyAbsSyn22
		 (Not happy_var_2
	)
happyReduction_44 _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_1  23 happyReduction_45
happyReduction_45 _
	 =  HappyAbsSyn23
		 (BTrue
	)

happyReduce_46 = happySpecReduce_1  23 happyReduction_46
happyReduction_46 _
	 =  HappyAbsSyn23
		 (BFalse
	)

happyReduce_47 = happySpecReduce_1  23 happyReduction_47
happyReduction_47 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn23
		 (happy_var_1
	)
happyReduction_47 _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  23 happyReduction_48
happyReduction_48 _
	(HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn23
		 (happy_var_2
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  24 happyReduction_49
happyReduction_49 (HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn24
		 (happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  25 happyReduction_50
happyReduction_50 (HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn25
		 (Variable happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happyReduce 4 25 happyReduction_51
happyReduction_51 (_ `HappyStk`
	(HappyAbsSyn26  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenIdent happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (Action happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_52 = happySpecReduce_3  25 happyReduction_52
happyReduction_52 (HappyTerminal (TokenIdent happy_var_3))
	_
	(HappyAbsSyn25  happy_var_1)
	 =  HappyAbsSyn25
		 (ChainAccess happy_var_1 happy_var_3
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happyReduce 6 25 happyReduction_53
happyReduction_53 (_ `HappyStk`
	(HappyAbsSyn26  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenIdent happy_var_3)) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn25  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn25
		 (ChainCall happy_var_1 happy_var_3 happy_var_5
	) `HappyStk` happyRest

happyReduce_54 = happySpecReduce_0  26 happyReduction_54
happyReduction_54  =  HappyAbsSyn26
		 ([]
	)

happyReduce_55 = happySpecReduce_1  26 happyReduction_55
happyReduction_55 (HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn26
		 ([happy_var_1]
	)
happyReduction_55 _  = notHappyAtAll 

happyReduce_56 = happySpecReduce_3  26 happyReduction_56
happyReduction_56 (HappyAbsSyn26  happy_var_3)
	_
	(HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn26
		 (happy_var_1 : happy_var_3
	)
happyReduction_56 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 59 59 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TokenGame -> cont 27;
	TokenTarget -> cont 28;
	TokenObject -> cont 29;
	TokenUnlock -> cont 30;
	TokenElements -> cont 31;
	TokenInit -> cont 32;
	TokenActions -> cont 33;
	TokenReturn -> cont 34;
	TokenAs -> cont 35;
	TokenShow -> cont 36;
	TokenTrue -> cont 37;
	TokenFalse -> cont 38;
	TokenLBrace -> cont 39;
	TokenRBrace -> cont 40;
	TokenLBracket -> cont 41;
	TokenRBracket -> cont 42;
	TokenLPar -> cont 43;
	TokenRPar -> cont 44;
	TokenColon -> cont 45;
	TokenComma -> cont 46;
	TokenAssign -> cont 47;
	TokenDot -> cont 48;
	TokenEquals -> cont 49;
	TokenArrow -> cont 50;
	TokenAnd -> cont 51;
	TokenOr -> cont 52;
	TokenNot -> cont 53;
	TokenDistinct -> cont 54;
	TokenIdent happy_dollar_dollar -> cont 55;
	TokenType happy_dollar_dollar -> cont 56;
	TokenNumber happy_dollar_dollar -> cont 57;
	TokenString happy_dollar_dollar -> cont 58;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 59 tk tks = happyError' (tks, explist)
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
parseError _ = error "Syntax error"
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
