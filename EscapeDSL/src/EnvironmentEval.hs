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

evalI :: [Declaration] -> Gamma ItemDefData
evalI [] = return emptyItemDefData 
evalI ((Unlock _):_) = throwerror "Unlock declaration not allowed here"
evalI ((Elements e):os) = do itemdata <- evalI os
                             k <- evalE e
                             elements <- unionelements k (ielements itemdata)
                             checkdefinition elements []
                             return (itemdata { ielements = elements })
evalI ((OnUse s):os) = do itemdata <- evalI os
                          sentences <- unionsentences s (isentences itemdata)
                          return (itemdata { isentences = sentences })

                          
evalT :: [Declaration] -> Gamma TargetDefData
evalT [] = return emptyTargetDefData
evalT ((Unlock n):os) = do targetdata <- evalT os
                           unlockcode <- maxunlockcodes n (code targetdata)
                           return (targetdata { code = unlockcode })
evalT ((Elements e):os) = do targetdata <- evalT os
                             k <- evalE e
                             elements <- unionelements k (telements targetdata)
                             checkdefinition elements []
                             return (targetdata { telements = elements })
evalT ((OnUse s):os) = do targetdata <- evalT os
                          sentences <- unionsentences s (tsentences targetdata)
                          return (targetdata { tsentences = sentences })

eval :: GameDefinition -> Gamma Objects
eval [] = return emptyObjects
eval ((Game objs):defs) = do itemdata <- evalI [Elements objs]
                             objects <- getobjects
                             putitem "game" itemdata objects
                             eval defs
eval ((ObjectDef TItem name decls):defs) = do itemdata <- evalI decls
                                              objects <- getobjects
                                              putitem name itemdata objects
                                              eval defs
eval ((ObjectDef TTarget name decls):defs) = do targetdata <- evalT decls
                                                objects <- getobjects
                                                puttarget name targetdata objects
                                                eval defs


