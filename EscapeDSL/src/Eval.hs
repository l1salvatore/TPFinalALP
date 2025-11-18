{-# LANGUAGE GADTs #-}
module Eval where

import AST
import qualified Data.Set as Set
import EvalCommon
import MonadGame


evalCond :: Conditions -> Gamma Bool
evalCond Locked = do current <- navigationtop
                     status <- getlockstatus current
                     return (status == VLock)
evalCond Unlocked = do current <- navigationtop
                       status <- getlockstatus current
                       return (status == VUnlock)
evalCond (ObjectLocked o) = do status <- getlockstatus o
                               return (status == VLock)
evalCond (ObjectUnlocked o) = do status <- getlockstatus o
                                 return (status == VUnlock)
evalCond (And c1 c2) = do v1 <- evalCond c1
                          v2 <- evalCond c2
                          return (v1 && v2)
evalCond (Or c1 c2) = do v1 <- evalCond c1
                         v2 <- evalCond c2
                         return (v1 || v2)                            

evalE :: [ObjectName] -> Gamma Elements
evalE [] = return Set.empty
evalE (o:os) = do es <- evalE os
                  checkdefinition o
                  return (Set.insert o es)

checkCommand :: Command -> Gamma ()
checkCommand (Show (ShowObject obj)) = checkdefinition obj
checkCommand _ = return ()

checkSentence :: Sentence -> Gamma ()
checkSentence (Command c) = checkCommand c
checkSentence (IfCommand _ c) = checkCommand c

checkSentences :: Sentences -> Gamma ()
checkSentences [] = return ()
checkSentences (x:xs) = do checkSentence x
                           checkSentences xs

evalI1 :: Declaration -> Gamma ItemDefData
evalI1 (Unlock _) = throwerror "Unlock declaration not allowed here"
evalI1 (Elements e) = do k <- evalE e
                         return (emptyItemDefData { ielements = k })
evalI1 (OnUse s) = do checkSentences s
                      return (emptyItemDefData { isentences = s })

evalI :: [Declaration] -> Gamma ItemDefData
evalI [] = return emptyItemDefData
evalI (x:os) = do itemdata <- evalI1 x
                  restdata <- evalI os
                  elements <- unionelements (ielements itemdata) (ielements restdata)
                  sentences <- unionsentences (isentences itemdata) (isentences restdata)
                  return (ItemDefData elements sentences)

evalT1 :: Declaration -> Gamma TargetDefData
evalT1 (Unlock n) = return (emptyTargetDefData { code = n })
evalT1 (Elements e) = do k <- evalE e
                         return (emptyTargetDefData { telements = k })
evalT1 (OnUse s) =  do checkSentences s
                       return (emptyTargetDefData { tsentences = s })

evalT :: [Declaration] -> Gamma TargetDefData
evalT [] = return emptyTargetDefData
evalT (x:xs) = do targetdata <- evalT1 x
                  restdata <- evalT xs
                  elements <- unionelements (telements targetdata) (telements restdata)
                  sentences <- unionsentences (tsentences targetdata) (tsentences restdata)
                  code <- maxunlockcodes (code targetdata) (code restdata)
                  return (TargetDefData elements sentences code)

eval1 :: Definition -> Gamma ()
eval1 (Game objs) = do itemdata <- evalI [Elements objs]
                       objects <- getobjects
                       putitem "game" itemdata objects
eval1 (ObjectDef TItem name decls) = do itemdata <- evalI decls
                                        objects <- getobjects
                                        putitem name itemdata objects
eval1 (ObjectDef TTarget name decls) = do targetdata <- evalT decls
                                          objects <- getobjects
                                          puttarget name targetdata objects
eval :: GameDefinition -> Gamma Objects
eval [] = return emptyObjects
eval (x:xs) = do eval1 x
                 eval xs

