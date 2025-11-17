{-# LANGUAGE GADTs #-}
module EnvironmentEval where

import AST
import qualified Data.Set as Set
import EvalCommon
import MonadGame




evalE :: [ObjectName] -> Gamma Elements
evalE [] = return Set.empty
evalE (o:os) = do es <- evalE os
                  return (Set.insert o es)

evalI1 :: Declaration -> Gamma ItemDefData
evalI1 (Unlock _) = throwerror "Unlock declaration not allowed here"
evalI1 (Elements e) = do k <- evalE e
                         checkdefinition k []
                         return (emptyItemDefData { ielements = k })
evalI1 (OnUse s) = return (emptyItemDefData { isentences = s })

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
                         checkdefinition k []
                         return (emptyTargetDefData { telements = k })
evalT1 (OnUse s) = return (emptyTargetDefData { tsentences = s })

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
                 o <- eval xs
                 return o

