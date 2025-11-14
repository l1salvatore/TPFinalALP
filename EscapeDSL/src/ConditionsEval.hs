{-# LANGUAGE GADTs #-}
module ConditionsEval where

import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Monad.State
import Control.Monad (ap)
import qualified Data.Bifunctor
import EvalCommon
import MonadGame


ceval :: Conditions -> Gamma Bool
ceval Locked = do current <- navigationtop
                  status <- getlockstatus current
                  return (status == VLock)
ceval Unlocked = do current <- navigationtop
                    status <- getlockstatus current
                    return (status == VUnlock)
ceval (ObjectLocked o) = do status <- getlockstatus o
                            return (status == VLock)
ceval (ObjectUnlocked o) = do status <- getlockstatus o
                              return (status == VUnlock)
ceval (And c1 c2) = do v1 <- ceval c1
                       v2 <- ceval c2
                       return (v1 && v2)
ceval (Or c1 c2) = do v1 <- ceval c1
                      v2 <- ceval c2
                      return (v1 || v2)                            