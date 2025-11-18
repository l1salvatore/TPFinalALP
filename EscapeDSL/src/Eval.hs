{-# LANGUAGE GADTs #-}
module Eval where

import AST
import qualified Data.Set as Set
import EvalModel
import GameMonads


evalCond :: Conditions -> Gamma Bool
evalCond Locked = do current <- objectNavigationTop
                     status <- getLockStatus current
                     return (status == VLock)
evalCond Unlocked = do current <- objectNavigationTop
                       status <- getLockStatus current
                       return (status == VUnlock)
evalCond (ObjectLocked o) = do status <- getLockStatus o
                               return (status == VLock)
evalCond (ObjectUnlocked o) = do status <- getLockStatus o
                                 return (status == VUnlock)
evalCond (And c1 c2) = do v1 <- evalCond c1
                          v2 <- evalCond c2
                          return (v1 && v2)
evalCond (Or c1 c2) = do v1 <- evalCond c1
                         v2 <- evalCond c2
                         return (v1 || v2)                            

collectElements :: [ObjectName] -> Gamma Elements
collectElements [] = return Set.empty
collectElements (o:os) = do es <- collectElements os
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

collectOneItem :: Declaration -> Gamma ItemDefData
collectOneItem (Unlock _) = throwException "Unlock declaration not allowed here"
collectOneItem (Elements e) = do k <- collectElements e
                                 return (emptyItemDefData { ielements = k })
collectOneItem (OnUse s) = do checkSentences s
                              return (emptyItemDefData { isentences = s })

collectItems :: [Declaration] -> Gamma ItemDefData
collectItems [] = return emptyItemDefData
collectItems (x:xs) = do itemdata <- collectOneItem x
                         restdata <- collectItems xs
                         elements <- unionelements (ielements itemdata) (ielements restdata)
                         sentences <- unionsentences (isentences itemdata) (isentences restdata)
                         return (ItemDefData elements sentences)

collectOneTarget :: Declaration -> Gamma TargetDefData
collectOneTarget (Unlock n) = return (emptyTargetDefData { code = n })
collectOneTarget (Elements e) = do k <- collectElements e
                                   return (emptyTargetDefData { telements = k })
collectOneTarget (OnUse s) =  do checkSentences s
                                 return (emptyTargetDefData { tsentences = s })

collectTargets :: [Declaration] -> Gamma TargetDefData
collectTargets [] = return emptyTargetDefData
collectTargets (x:xs) = do targetdata <- collectOneTarget x
                           restdata <- collectTargets xs
                           elements <- unionelements (telements targetdata) (telements restdata)
                           sentences <- unionsentences (tsentences targetdata) (tsentences restdata)
                           code <- maxunlockcodes (code targetdata) (code restdata)
                           return (TargetDefData elements sentences code)


-- Recolecto la información de un sólo objeto
collectOneObject :: Definition -> Gamma ()
collectOneObject (Game objs) = do itemdata <- collectItems [Elements objs] -- El juego raiz es un item con los elementos principales
                                  objects <- getobjects -- Consulto el mapa de objetos actual
                                  putitem "game" itemdata objects -- Inserto el juego raiz al mapa de objetos
collectOneObject (ObjectDef TItem name decls) = do itemdata <- collectItems decls -- Recolecto la información del item
                                                   objects <- getobjects -- Consulto el mapa de objetos actual
                                                   putitem name itemdata objects -- Inserto el item al mapa de objetos
collectOneObject (ObjectDef TTarget name decls) = do targetdata <- collectTargets decls -- Recolecto la información del target
                                                     objects <- getobjects -- Consulto el mapa de objetos actual
                                                     puttarget name targetdata objects -- Inserto el target al mapa de objetos


-- Recolecto todos los objetos del GameDefinition
collectObjects :: GameDefinition -> Gamma Objects
collectObjects [] = return emptyObjects -- Caso de lista vacía
collectObjects (x:xs) = do collectOneObject x -- Recolecto un objeto, x y lo inserto en el mapa
                           collectObjects xs -- Recolecto el resto de los objetos
