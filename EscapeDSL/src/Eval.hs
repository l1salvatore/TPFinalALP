{-# LANGUAGE GADTs #-}
module Eval where

import AST
import qualified Data.Set as Set
import EvalModel
import GameMonads


-- Evaluador de condiciones
evalCond :: Conditions -> Gamma Bool
evalCond Locked = do current <- objectNavigationTop -- Obtengo el primer elemento de la pila (el actual de la navegación)
                     status <- getLockStatus current -- Chequeo si está bloqueado o desbloqueado
                     return (status == VLock) -- Retorno true si está locked, o false si está unlocked
evalCond Unlocked = do current <- objectNavigationTop -- Obtengo el primer elemento de la pila (el actual de la navegación)
                       status <- getLockStatus current -- Chequeo si está bloqueado o desbloqueado
                       return (status == VUnlock) -- Retorno true si está unlocked, o false si está locked
evalCond (ObjectLocked o) = do checkdefinition o  -- Chequeo la definición de o, si está declarado
                               status <- getLockStatus o -- Obtengo el estado del objeto o
                               return (status == VLock)  -- Retorno true si está locked, o false si está unlocked
evalCond (ObjectUnlocked o) = do checkdefinition o -- Chequeo la definición de o, si está declarado
                                 status <- getLockStatus o -- Obtengo el estado del objeto o
                                 return (status == VUnlock)  -- Retorno true si está unlocked, o false si está locked
evalCond (And c1 c2) = do v1 <- evalCond c1 -- Evaluo recursivamente c1
                          v2 <- evalCond c2 -- Evaluo recursivamente c2
                          return (v1 && v2) -- Retorno la conjunción de ambos v1 y v2
evalCond (Or c1 c2) = do v1 <- evalCond c1 -- Evaluo recursivamente c1
                         v2 <- evalCond c2 -- Evaluo recursivamente c2
                         return (v1 || v2) -- Retorno la conjunción de ambos v1 y v2

-- Recolecto los elementos (objetos) de un objeto
collectElements :: [ObjectName] -> Gamma Elements
collectElements [] = return Set.empty -- Retorno el conjunto vacío
collectElements (o:os) = do es <- collectElements os -- Recolecto la lista restante
                            checkdefinition o -- Chequeo la definición de o, si está declarado
                            return (Set.insert o es) -- Inserto o a la lista restante

-- Chequeo un sólo comando
checkCommand :: Command -> Gamma ()
checkCommand (Show (ShowObject obj)) = checkdefinition obj -- Para las sentencias de la forma 'Show object', chequeo si el objeto está declarado
checkCommand _ = return () -- Retorno () en otro caso

-- Chequeo una sola sentencia
checkSentence :: Sentence -> Type -> Gamma ()
checkSentence (Command c) _= checkCommand c -- Chequeo un comando
checkSentence (IfCommand Locked c) TTarget = checkCommand c -- Chequeo un comando dentro de un if
checkSentence (IfCommand Unlocked c) TTarget = checkCommand c -- Chequeo un comando dentro de un if
checkSentence (IfCommand Locked _) TItem = throwException "Object not target for this conditions"
checkSentence (IfCommand Unlocked _) TItem = throwException "Object not target for this conditions"
checkSentence (IfCommand _ c) _ = checkCommand c

-- Chequeo todas las sentencias de una lista
checkSentences :: Sentences -> Type -> Gamma ()
checkSentences [] _ = return () -- Caso de lista vacía
checkSentences (x:xs) t = do checkSentence x t -- Chequeo una sentencia
                             checkSentences xs t -- Chequeo el resto de las sentencias

-- Recolecto la información de un sólo objeto item
collectOneItem :: Declaration -> Gamma ItemDefData -- Recolecto la información de un sólo objeto item
collectOneItem (Unlock _) = throwException "Unlock declaration not allowed here" -- No puede haber Unlock en un item 
collectOneItem (Elements e) = do k <- collectElements e -- Recolecto los elementos
                                 return (emptyItemDefData { ielements = k }) -- Retorno el objeto vacío con los elementos sólamente
collectOneItem (OnUse s) = do checkSentences s TItem -- Chequeo las sentencias que se ejecutan al usar el objeto. Evito variables no declaradas
                              return (emptyItemDefData { isentences = s }) -- Retorno el objeto vacío con las sentencias sólamente

-- Recolecto los datos de los objetos item
collectItems :: [Declaration] -> Gamma ItemDefData
collectItems [] = return emptyItemDefData -- Caso de lista vacía
collectItems (x:xs) = do itemdata <- collectOneItem x -- Recolecto los datos de un objeto item
                         restdata <- collectItems xs -- Recolecto el resto de los datos
                         elements <- unionelements (ielements itemdata) (ielements restdata) -- Uno los elementos de cada uno
                         sentences <- unionsentences (isentences itemdata) (isentences restdata) -- Uno las sentencias de cada uno
                         return (ItemDefData elements sentences) -- Retorno el objeto item completo


-- Recolecto la información de un sólo objeto objetivo
collectOneTarget :: Declaration -> Gamma TargetDefData
collectOneTarget (Unlock n) = return (emptyTargetDefData { code = n }) -- Recolecto el código de desbloqueo
collectOneTarget (Elements e) = do k <- collectElements e -- Recolecto los elementos
                                   return (emptyTargetDefData { telements = k }) -- Retorno el objeto vacío con los elementos sólamente
collectOneTarget (OnUse s) =  do checkSentences s TTarget -- Chequeo las sentencias que se ejecutan al usar el objeto. Evito variables no declaradas
                                 return (emptyTargetDefData { tsentences = s }) -- Retorno el objeto vacío con las sentencias sólamente

-- Recolecto los datos de los objetos objetivo
collectTargets :: [Declaration] -> Gamma TargetDefData
collectTargets [] = return emptyTargetDefData -- Caso de lista vacía
collectTargets (x:xs) = do targetdata <- collectOneTarget x -- Recolecto los datos de un objeto objetivo
                           restdata <- collectTargets xs -- Recolecto el resto de los datos
                           elements <- unionelements (telements targetdata) (telements restdata) -- Uno los elementos de cada uno
                           sentences <- unionsentences (tsentences targetdata) (tsentences restdata) -- Uno las sentencias de cada uno
                           code <- maxunlockcodes (code targetdata) (code restdata) -- Obtengo el código de desbloqueo (el mayor, ya que sólo puede haber uno no cero)
                           return (TargetDefData elements sentences code) -- Retorno el objeto objetivo completo


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
