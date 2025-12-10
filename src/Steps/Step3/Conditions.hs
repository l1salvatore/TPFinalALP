{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Steps.Step3.Conditions where

import AST
import GameStateMonad
import GameModel
import Control.Monad.State ()

-- Evaluador de condiciones
evalCond :: Conditions -> GameState Bool
evalCond Locked = do current <- objectNavigationTop -- Obtengo el primer elemento de la pila (el actual de la navegación)
                     status <- getLockStatus current -- Chequeo si está bloqueado o desbloqueado
                     return (status == VLock) -- Retorno true si está locked, o false si está unlocked
evalCond Unlocked = do current <- objectNavigationTop -- Obtengo el primer elemento de la pila (el actual de la navegación)
                       status <- getLockStatus current -- Chequeo si está bloqueado o desbloqueado
                       return (status == VUnlock) -- Retorno true si está unlocked, o false si está locked
evalCond (ObjectLocked o) = do status <- getLockStatus o -- Obtengo el estado del objeto o
                               return (status == VLock)  -- Retorno true si está locked, o false si está unlocked
evalCond (ObjectUnlocked o) = do status <- getLockStatus o -- Obtengo el estado del objeto o
                                 return (status == VUnlock)  -- Retorno true si está unlocked, o false si está locked
evalCond (And c1 c2) = do v1 <- evalCond c1 -- Evaluo recursivamente c1
                          v2 <- evalCond c2 -- Evaluo recursivamente c2
                          return (v1 && v2) -- Retorno la conjunción de ambos v1 y v2
evalCond (Or c1 c2) = do v1 <- evalCond c1 -- Evaluo recursivamente c1
                         v2 <- evalCond c2 -- Evaluo recursivamente c2
                         return (v1 || v2) -- Retorno la conjunción de ambos v1 y v2

