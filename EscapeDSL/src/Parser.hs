{-# OPTIONS_GHC -w #-}
module Parser where
import AST
import Lexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10 t11 t12 t13 t14 t15 t16 t17 t18 t19 t20 t21 t22 t23 t24 t25
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

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,227) ([0,3584,0,0,0,224,0,0,0,0,0,0,0,512,0,0,0,0,64,0,0,0,4,0,14,0,0,0,0,0,0,0,32,0,0,0,2,0,0,240,0,0,0,1039,0,0,0,0,0,0,0,128,0,0,0,8,0,0,32768,0,0,0,2048,0,0,3840,0,0,0,240,0,0,0,1039,0,0,61440,64,0,0,0,8,0,0,32768,0,0,0,2048,0,0,0,128,0,0,0,0,0,0,0,0,0,0,8576,25216,0,0,0,448,0,0,0,2,0,0,8192,0,0,0,0,0,0,0,0,0,0,16,0,0,0,16,0,0,8192,0,0,0,256,0,0,0,256,0,0,0,32,0,0,4096,0,0,0,0,32,0,0,256,0,0,0,0,0,0,0,0,0,0,0,0,0,0,16,0,0,0,4224,0,0,0,0,0,0,4096,6,0,0,0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8576,25216,0,0,536,1576,0,0,32,0,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,1540,0,0,0,512,0,0,536,1576,0,32768,32801,98,0,6144,10242,6,0,0,25088,0,0,0,1568,0,0,0,0,0,0,49152,1,0,0,0,0,0,0,0,0,0,0,98,0,0,8192,0,0,0,0,0,0,0,448,0,0,0,2,0,0,0,0,0,0,0,0,0,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,32,0,0,0,0,0,0,16384,0,0,0,4096,0,0,0,0,2,0,0,0,0,0,0,512,0,0,2,0,0,0,4096,0,0,0,49152,1,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,0,80,512,0,0,0,0,0,0,0,0,0,0,64,0,0,0,0,0,0,0,1568,0,0,0,98,0,0,34,0,0,0,0,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseEscapeRoom","GameDefinition","Definition","Declarations","Declaration","UnlockConditions","Actions","Action","ActionReturnType","Command","Elements","Type","Element","Assignments","Assignment","Exp","SimpleExp","BoolExp","CompExp","Chained","ChainedCall","ChainedAccess","Args","game","target","object","unlock","elements","init","actions","return","as","show","true","false","'{'","'}'","'['","']'","'('","')'","':'","','","'='","'.'","\"==\"","\"->\"","\"&&\"","\"||\"","\"!\"","\"!=\"","ident","typename","numbertype","messagetype","number","string","%eof"]
        bit_start = st Prelude.* 60
        bit_end = (st Prelude.+ 1) Prelude.* 60
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..59]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (26) = happyShift action_3
action_0 (27) = happyShift action_4
action_0 (28) = happyShift action_5
action_0 (4) = happyGoto action_6
action_0 (5) = happyGoto action_2
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (26) = happyShift action_3
action_1 (27) = happyShift action_4
action_1 (28) = happyShift action_5
action_1 (5) = happyGoto action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (38) = happyShift action_10
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (55) = happyShift action_9
action_4 _ = happyFail (happyExpListPerState 4)

action_5 (55) = happyShift action_8
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (26) = happyShift action_3
action_6 (27) = happyShift action_4
action_6 (28) = happyShift action_5
action_6 (60) = happyAccept
action_6 (5) = happyGoto action_7
action_6 _ = happyFail (happyExpListPerState 6)

action_7 _ = happyReduce_2

action_8 (38) = happyShift action_18
action_8 _ = happyFail (happyExpListPerState 8)

action_9 (38) = happyShift action_17
action_9 _ = happyFail (happyExpListPerState 9)

action_10 (29) = happyShift action_13
action_10 (30) = happyShift action_14
action_10 (31) = happyShift action_15
action_10 (32) = happyShift action_16
action_10 (6) = happyGoto action_11
action_10 (7) = happyGoto action_12
action_10 _ = happyFail (happyExpListPerState 10)

action_11 (29) = happyShift action_13
action_11 (30) = happyShift action_14
action_11 (31) = happyShift action_15
action_11 (32) = happyShift action_16
action_11 (39) = happyShift action_26
action_11 (7) = happyGoto action_25
action_11 _ = happyFail (happyExpListPerState 11)

action_12 _ = happyReduce_6

action_13 (44) = happyShift action_24
action_13 _ = happyFail (happyExpListPerState 13)

action_14 (44) = happyShift action_23
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (44) = happyShift action_22
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (44) = happyShift action_21
action_16 _ = happyFail (happyExpListPerState 16)

action_17 (29) = happyShift action_13
action_17 (30) = happyShift action_14
action_17 (31) = happyShift action_15
action_17 (32) = happyShift action_16
action_17 (6) = happyGoto action_20
action_17 (7) = happyGoto action_12
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (29) = happyShift action_13
action_18 (30) = happyShift action_14
action_18 (31) = happyShift action_15
action_18 (32) = happyShift action_16
action_18 (6) = happyGoto action_19
action_18 (7) = happyGoto action_12
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (29) = happyShift action_13
action_19 (30) = happyShift action_14
action_19 (31) = happyShift action_15
action_19 (32) = happyShift action_16
action_19 (39) = happyShift action_32
action_19 (7) = happyGoto action_25
action_19 _ = happyFail (happyExpListPerState 19)

action_20 (29) = happyShift action_13
action_20 (30) = happyShift action_14
action_20 (31) = happyShift action_15
action_20 (32) = happyShift action_16
action_20 (39) = happyShift action_31
action_20 (7) = happyGoto action_25
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (40) = happyShift action_30
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (40) = happyShift action_29
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (40) = happyShift action_28
action_23 _ = happyFail (happyExpListPerState 23)

action_24 (40) = happyShift action_27
action_24 _ = happyFail (happyExpListPerState 24)

action_25 _ = happyReduce_7

action_26 _ = happyReduce_3

action_27 (36) = happyShift action_53
action_27 (37) = happyShift action_54
action_27 (42) = happyShift action_55
action_27 (52) = happyShift action_56
action_27 (54) = happyShift action_57
action_27 (58) = happyShift action_58
action_27 (59) = happyShift action_59
action_27 (8) = happyGoto action_45
action_27 (18) = happyGoto action_46
action_27 (19) = happyGoto action_47
action_27 (20) = happyGoto action_48
action_27 (21) = happyGoto action_49
action_27 (22) = happyGoto action_50
action_27 (23) = happyGoto action_51
action_27 (24) = happyGoto action_52
action_27 _ = happyReduce_12

action_28 (55) = happyShift action_42
action_28 (56) = happyShift action_43
action_28 (57) = happyShift action_44
action_28 (13) = happyGoto action_39
action_28 (14) = happyGoto action_40
action_28 (15) = happyGoto action_41
action_28 _ = happyReduce_25

action_29 (54) = happyShift action_38
action_29 (16) = happyGoto action_36
action_29 (17) = happyGoto action_37
action_29 _ = happyReduce_32

action_30 (54) = happyShift action_35
action_30 (9) = happyGoto action_33
action_30 (10) = happyGoto action_34
action_30 _ = happyReduce_15

action_31 _ = happyReduce_4

action_32 _ = happyReduce_5

action_33 (41) = happyShift action_78
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (45) = happyShift action_77
action_34 _ = happyReduce_16

action_35 (42) = happyShift action_76
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (41) = happyShift action_75
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (45) = happyShift action_74
action_37 _ = happyReduce_33

action_38 (46) = happyShift action_73
action_38 _ = happyFail (happyExpListPerState 38)

action_39 (41) = happyShift action_72
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (54) = happyShift action_71
action_40 _ = happyFail (happyExpListPerState 40)

action_41 (45) = happyShift action_70
action_41 _ = happyReduce_26

action_42 _ = happyReduce_30

action_43 _ = happyReduce_28

action_44 _ = happyReduce_29

action_45 (41) = happyShift action_69
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (48) = happyShift action_67
action_46 (53) = happyShift action_68
action_46 _ = happyFail (happyExpListPerState 46)

action_47 _ = happyReduce_36

action_48 (45) = happyShift action_64
action_48 (50) = happyShift action_65
action_48 (51) = happyShift action_66
action_48 _ = happyReduce_13

action_49 _ = happyReduce_46

action_50 (47) = happyShift action_63
action_50 _ = happyReduce_37

action_51 _ = happyReduce_49

action_52 _ = happyReduce_50

action_53 _ = happyReduce_40

action_54 _ = happyReduce_41

action_55 (36) = happyShift action_53
action_55 (37) = happyShift action_54
action_55 (42) = happyShift action_55
action_55 (52) = happyShift action_56
action_55 (54) = happyShift action_57
action_55 (58) = happyShift action_58
action_55 (59) = happyShift action_59
action_55 (18) = happyGoto action_46
action_55 (19) = happyGoto action_47
action_55 (20) = happyGoto action_62
action_55 (21) = happyGoto action_49
action_55 (22) = happyGoto action_50
action_55 (23) = happyGoto action_51
action_55 (24) = happyGoto action_52
action_55 _ = happyFail (happyExpListPerState 55)

action_56 (36) = happyShift action_53
action_56 (37) = happyShift action_54
action_56 (42) = happyShift action_55
action_56 (52) = happyShift action_56
action_56 (54) = happyShift action_57
action_56 (58) = happyShift action_58
action_56 (59) = happyShift action_59
action_56 (18) = happyGoto action_46
action_56 (19) = happyGoto action_47
action_56 (20) = happyGoto action_61
action_56 (21) = happyGoto action_49
action_56 (22) = happyGoto action_50
action_56 (23) = happyGoto action_51
action_56 (24) = happyGoto action_52
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (42) = happyShift action_60
action_57 _ = happyReduce_53

action_58 _ = happyReduce_38

action_59 _ = happyReduce_39

action_60 (54) = happyShift action_92
action_60 (25) = happyGoto action_91
action_60 _ = happyReduce_55

action_61 (50) = happyShift action_65
action_61 (51) = happyShift action_66
action_61 _ = happyReduce_43

action_62 (43) = happyShift action_90
action_62 (50) = happyShift action_65
action_62 (51) = happyShift action_66
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (54) = happyShift action_89
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (36) = happyShift action_53
action_64 (37) = happyShift action_54
action_64 (42) = happyShift action_55
action_64 (52) = happyShift action_56
action_64 (54) = happyShift action_57
action_64 (58) = happyShift action_58
action_64 (59) = happyShift action_59
action_64 (8) = happyGoto action_88
action_64 (18) = happyGoto action_46
action_64 (19) = happyGoto action_47
action_64 (20) = happyGoto action_48
action_64 (21) = happyGoto action_49
action_64 (22) = happyGoto action_50
action_64 (23) = happyGoto action_51
action_64 (24) = happyGoto action_52
action_64 _ = happyReduce_12

action_65 (36) = happyShift action_53
action_65 (37) = happyShift action_54
action_65 (42) = happyShift action_55
action_65 (52) = happyShift action_56
action_65 (54) = happyShift action_57
action_65 (58) = happyShift action_58
action_65 (59) = happyShift action_59
action_65 (18) = happyGoto action_46
action_65 (19) = happyGoto action_47
action_65 (20) = happyGoto action_87
action_65 (21) = happyGoto action_49
action_65 (22) = happyGoto action_50
action_65 (23) = happyGoto action_51
action_65 (24) = happyGoto action_52
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (36) = happyShift action_53
action_66 (37) = happyShift action_54
action_66 (42) = happyShift action_55
action_66 (52) = happyShift action_56
action_66 (54) = happyShift action_57
action_66 (58) = happyShift action_58
action_66 (59) = happyShift action_59
action_66 (18) = happyGoto action_46
action_66 (19) = happyGoto action_47
action_66 (20) = happyGoto action_86
action_66 (21) = happyGoto action_49
action_66 (22) = happyGoto action_50
action_66 (23) = happyGoto action_51
action_66 (24) = happyGoto action_52
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (54) = happyShift action_57
action_67 (58) = happyShift action_58
action_67 (59) = happyShift action_59
action_67 (18) = happyGoto action_85
action_67 (19) = happyGoto action_47
action_67 (22) = happyGoto action_50
action_67 (23) = happyGoto action_51
action_67 (24) = happyGoto action_52
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (54) = happyShift action_57
action_68 (58) = happyShift action_58
action_68 (59) = happyShift action_59
action_68 (18) = happyGoto action_84
action_68 (19) = happyGoto action_47
action_68 (22) = happyGoto action_50
action_68 (23) = happyGoto action_51
action_68 (24) = happyGoto action_52
action_68 _ = happyFail (happyExpListPerState 68)

action_69 _ = happyReduce_11

action_70 (55) = happyShift action_42
action_70 (56) = happyShift action_43
action_70 (57) = happyShift action_44
action_70 (13) = happyGoto action_83
action_70 (14) = happyGoto action_40
action_70 (15) = happyGoto action_41
action_70 _ = happyReduce_25

action_71 _ = happyReduce_31

action_72 _ = happyReduce_8

action_73 (54) = happyShift action_57
action_73 (58) = happyShift action_58
action_73 (59) = happyShift action_59
action_73 (18) = happyGoto action_82
action_73 (19) = happyGoto action_47
action_73 (22) = happyGoto action_50
action_73 (23) = happyGoto action_51
action_73 (24) = happyGoto action_52
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (54) = happyShift action_38
action_74 (16) = happyGoto action_81
action_74 (17) = happyGoto action_37
action_74 _ = happyReduce_32

action_75 _ = happyReduce_9

action_76 (55) = happyShift action_42
action_76 (56) = happyShift action_43
action_76 (57) = happyShift action_44
action_76 (13) = happyGoto action_80
action_76 (14) = happyGoto action_40
action_76 (15) = happyGoto action_41
action_76 _ = happyReduce_25

action_77 (54) = happyShift action_35
action_77 (9) = happyGoto action_79
action_77 (10) = happyGoto action_34
action_77 _ = happyReduce_15

action_78 _ = happyReduce_10

action_79 _ = happyReduce_17

action_80 (43) = happyShift action_96
action_80 _ = happyFail (happyExpListPerState 80)

action_81 _ = happyReduce_34

action_82 _ = happyReduce_35

action_83 _ = happyReduce_27

action_84 _ = happyReduce_48

action_85 _ = happyReduce_47

action_86 _ = happyReduce_45

action_87 _ = happyReduce_44

action_88 _ = happyReduce_14

action_89 (42) = happyShift action_95
action_89 _ = happyReduce_54

action_90 _ = happyReduce_42

action_91 (43) = happyShift action_94
action_91 _ = happyFail (happyExpListPerState 91)

action_92 (45) = happyShift action_93
action_92 _ = happyReduce_56

action_93 (54) = happyShift action_92
action_93 (25) = happyGoto action_100
action_93 _ = happyReduce_55

action_94 _ = happyReduce_51

action_95 (54) = happyShift action_92
action_95 (25) = happyGoto action_99
action_95 _ = happyReduce_55

action_96 (34) = happyShift action_98
action_96 (11) = happyGoto action_97
action_96 _ = happyReduce_19

action_97 (49) = happyShift action_103
action_97 _ = happyFail (happyExpListPerState 97)

action_98 (55) = happyShift action_42
action_98 (56) = happyShift action_43
action_98 (57) = happyShift action_44
action_98 (14) = happyGoto action_102
action_98 _ = happyFail (happyExpListPerState 98)

action_99 (43) = happyShift action_101
action_99 _ = happyFail (happyExpListPerState 99)

action_100 _ = happyReduce_57

action_101 _ = happyReduce_52

action_102 _ = happyReduce_20

action_103 (33) = happyShift action_108
action_103 (35) = happyShift action_109
action_103 (54) = happyShift action_110
action_103 (12) = happyGoto action_104
action_103 (17) = happyGoto action_105
action_103 (22) = happyGoto action_106
action_103 (23) = happyGoto action_107
action_103 (24) = happyGoto action_52
action_103 _ = happyFail (happyExpListPerState 103)

action_104 _ = happyReduce_18

action_105 _ = happyReduce_21

action_106 (47) = happyShift action_63
action_106 _ = happyFail (happyExpListPerState 106)

action_107 (47) = happyReduce_49
action_107 _ = happyReduce_22

action_108 (54) = happyShift action_57
action_108 (58) = happyShift action_58
action_108 (59) = happyShift action_59
action_108 (18) = happyGoto action_112
action_108 (19) = happyGoto action_47
action_108 (22) = happyGoto action_50
action_108 (23) = happyGoto action_51
action_108 (24) = happyGoto action_52
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (54) = happyShift action_57
action_109 (58) = happyShift action_58
action_109 (59) = happyShift action_59
action_109 (18) = happyGoto action_111
action_109 (19) = happyGoto action_47
action_109 (22) = happyGoto action_50
action_109 (23) = happyGoto action_51
action_109 (24) = happyGoto action_52
action_109 _ = happyFail (happyExpListPerState 109)

action_110 (42) = happyShift action_60
action_110 (46) = happyShift action_73
action_110 _ = happyReduce_53

action_111 _ = happyReduce_24

action_112 _ = happyReduce_23

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
	(HappyAbsSyn16  happy_var_4) `HappyStk`
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

happyReduce_12 = happySpecReduce_0  8 happyReduction_12
happyReduction_12  =  HappyAbsSyn8
		 ([]
	)

happyReduce_13 = happySpecReduce_1  8 happyReduction_13
happyReduction_13 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn8
		 ([happy_var_1]
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_3  8 happyReduction_14
happyReduction_14 (HappyAbsSyn8  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1 : happy_var_3
	)
happyReduction_14 _ _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_0  9 happyReduction_15
happyReduction_15  =  HappyAbsSyn9
		 ([]
	)

happyReduce_16 = happySpecReduce_1  9 happyReduction_16
happyReduction_16 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 ([happy_var_1]
	)
happyReduction_16 _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  9 happyReduction_17
happyReduction_17 (HappyAbsSyn9  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1 : happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happyReduce 7 10 happyReduction_18
happyReduction_18 ((HappyAbsSyn12  happy_var_7) `HappyStk`
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

happyReduce_19 = happySpecReduce_0  11 happyReduction_19
happyReduction_19  =  HappyAbsSyn11
		 (Nothing
	)

happyReduce_20 = happySpecReduce_2  11 happyReduction_20
happyReduction_20 (HappyAbsSyn14  happy_var_2)
	_
	 =  HappyAbsSyn11
		 (Just happy_var_2
	)
happyReduction_20 _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_1  12 happyReduction_21
happyReduction_21 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn12
		 (Assign happy_var_1
	)
happyReduction_21 _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_1  12 happyReduction_22
happyReduction_22 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn12
		 (ChainedCall happy_var_1
	)
happyReduction_22 _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_2  12 happyReduction_23
happyReduction_23 (HappyAbsSyn18  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (Return happy_var_2
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_2  12 happyReduction_24
happyReduction_24 (HappyAbsSyn18  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (Show happy_var_2
	)
happyReduction_24 _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_0  13 happyReduction_25
happyReduction_25  =  HappyAbsSyn13
		 ([]
	)

happyReduce_26 = happySpecReduce_1  13 happyReduction_26
happyReduction_26 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn13
		 ([happy_var_1]
	)
happyReduction_26 _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_3  13 happyReduction_27
happyReduction_27 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn13
		 (happy_var_1 : happy_var_3
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_1  14 happyReduction_28
happyReduction_28 _
	 =  HappyAbsSyn14
		 (TNatural
	)

happyReduce_29 = happySpecReduce_1  14 happyReduction_29
happyReduction_29 _
	 =  HappyAbsSyn14
		 (TMessage
	)

happyReduce_30 = happySpecReduce_1  14 happyReduction_30
happyReduction_30 (HappyTerminal (TokenType happy_var_1))
	 =  HappyAbsSyn14
		 (TypeName happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_2  15 happyReduction_31
happyReduction_31 (HappyTerminal (TokenIdent happy_var_2))
	(HappyAbsSyn14  happy_var_1)
	 =  HappyAbsSyn15
		 (ElementDeclare happy_var_1 happy_var_2
	)
happyReduction_31 _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_0  16 happyReduction_32
happyReduction_32  =  HappyAbsSyn16
		 ([]
	)

happyReduce_33 = happySpecReduce_1  16 happyReduction_33
happyReduction_33 (HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn16
		 ([happy_var_1]
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  16 happyReduction_34
happyReduction_34 (HappyAbsSyn16  happy_var_3)
	_
	(HappyAbsSyn17  happy_var_1)
	 =  HappyAbsSyn16
		 (happy_var_1 : happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  17 happyReduction_35
happyReduction_35 (HappyAbsSyn18  happy_var_3)
	_
	(HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn17
		 (Let happy_var_1 happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_1  18 happyReduction_36
happyReduction_36 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_1
	)
happyReduction_36 _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_1  19 happyReduction_37
happyReduction_37 (HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn19
		 (Chained happy_var_1
	)
happyReduction_37 _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_1  19 happyReduction_38
happyReduction_38 (HappyTerminal (TokenNumber happy_var_1))
	 =  HappyAbsSyn19
		 (Natural happy_var_1
	)
happyReduction_38 _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_1  19 happyReduction_39
happyReduction_39 (HappyTerminal (TokenString happy_var_1))
	 =  HappyAbsSyn19
		 (Message happy_var_1
	)
happyReduction_39 _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_1  20 happyReduction_40
happyReduction_40 _
	 =  HappyAbsSyn20
		 (BTrue
	)

happyReduce_41 = happySpecReduce_1  20 happyReduction_41
happyReduction_41 _
	 =  HappyAbsSyn20
		 (BFalse
	)

happyReduce_42 = happySpecReduce_3  20 happyReduction_42
happyReduction_42 _
	(HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (happy_var_2
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_2  20 happyReduction_43
happyReduction_43 (HappyAbsSyn20  happy_var_2)
	_
	 =  HappyAbsSyn20
		 (Not happy_var_2
	)
happyReduction_43 _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  20 happyReduction_44
happyReduction_44 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (And happy_var_1 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  20 happyReduction_45
happyReduction_45 (HappyAbsSyn20  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (Or happy_var_1 happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_1  20 happyReduction_46
happyReduction_46 (HappyAbsSyn21  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_1
	)
happyReduction_46 _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  21 happyReduction_47
happyReduction_47 (HappyAbsSyn18  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn21
		 (Eq happy_var_1 happy_var_3
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  21 happyReduction_48
happyReduction_48 (HappyAbsSyn18  happy_var_3)
	_
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn21
		 (NEq happy_var_1 happy_var_3
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_1  22 happyReduction_49
happyReduction_49 (HappyAbsSyn23  happy_var_1)
	 =  HappyAbsSyn22
		 (Call happy_var_1
	)
happyReduction_49 _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  22 happyReduction_50
happyReduction_50 (HappyAbsSyn24  happy_var_1)
	 =  HappyAbsSyn22
		 (Access happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happyReduce 4 23 happyReduction_51
happyReduction_51 (_ `HappyStk`
	(HappyAbsSyn25  happy_var_3) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenIdent happy_var_1)) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (Action happy_var_1 happy_var_3
	) `HappyStk` happyRest

happyReduce_52 = happyReduce 6 23 happyReduction_52
happyReduction_52 (_ `HappyStk`
	(HappyAbsSyn25  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (TokenIdent happy_var_3)) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn22  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn23
		 (ChainCall happy_var_1 (Action happy_var_3 happy_var_5)
	) `HappyStk` happyRest

happyReduce_53 = happySpecReduce_1  24 happyReduction_53
happyReduction_53 (HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn24
		 (Variable happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_3  24 happyReduction_54
happyReduction_54 (HappyTerminal (TokenIdent happy_var_3))
	_
	(HappyAbsSyn22  happy_var_1)
	 =  HappyAbsSyn24
		 (ChainAccess happy_var_1 (Variable happy_var_3)
	)
happyReduction_54 _ _ _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_0  25 happyReduction_55
happyReduction_55  =  HappyAbsSyn25
		 ([]
	)

happyReduce_56 = happySpecReduce_1  25 happyReduction_56
happyReduction_56 (HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn25
		 ([happy_var_1]
	)
happyReduction_56 _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_3  25 happyReduction_57
happyReduction_57 (HappyAbsSyn25  happy_var_3)
	_
	(HappyTerminal (TokenIdent happy_var_1))
	 =  HappyAbsSyn25
		 (happy_var_1 : happy_var_3
	)
happyReduction_57 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 60 60 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TokenGame -> cont 26;
	TokenTarget -> cont 27;
	TokenObject -> cont 28;
	TokenUnlock -> cont 29;
	TokenElements -> cont 30;
	TokenInit -> cont 31;
	TokenActions -> cont 32;
	TokenReturn -> cont 33;
	TokenAs -> cont 34;
	TokenShow -> cont 35;
	TokenTrue -> cont 36;
	TokenFalse -> cont 37;
	TokenLBrace -> cont 38;
	TokenRBrace -> cont 39;
	TokenLBracket -> cont 40;
	TokenRBracket -> cont 41;
	TokenLPar -> cont 42;
	TokenRPar -> cont 43;
	TokenColon -> cont 44;
	TokenComma -> cont 45;
	TokenAssign -> cont 46;
	TokenDot -> cont 47;
	TokenEquals -> cont 48;
	TokenArrow -> cont 49;
	TokenAnd -> cont 50;
	TokenOr -> cont 51;
	TokenNot -> cont 52;
	TokenDistinct -> cont 53;
	TokenIdent happy_dollar_dollar -> cont 54;
	TokenType happy_dollar_dollar -> cont 55;
	TokenNumberType -> cont 56;
	TokenMessageType -> cont 57;
	TokenNumber happy_dollar_dollar -> cont 58;
	TokenString happy_dollar_dollar -> cont 59;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 60 tk tks = happyError' (tks, explist)
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
