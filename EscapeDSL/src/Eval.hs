{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs #-}
module Eval where

import AST
import Data.Maybe (fromMaybe)
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Monad.State

type ObjectsMap = Map.Map ObjectName ObjectDefData
data ObjectDefData = ObjectDefData
  { oelements :: Set.Set ObjectName,
    osentences :: [Sentence]
  } deriving (Show, Eq)

type TargetsMap = Map.Map ObjectName TargetDefData
data TargetDefData = TargetDefData
  { telements :: Set.Set ObjectName,
    tsentences :: [Sentence],
    code :: UnlockCode
  } deriving (Show, Eq)

type Elements = Set.Set ObjectName
type Sentences = [Sentence]

type Gamma = (ObjectsMap, TargetsMap)
newtype M a = M { runM :: StateT Gamma (Either String) a }

emptyGamma :: Gamma
emptyGamma = (Map.empty, Map.empty)

eval_e :: [ObjectName] -> M Elements
eval_e [] = return Set.empty
eval_e (o:os) = do es <- eval_e os
                   return (Set.insert o es)

eval_o :: [Declaration] -> M (Elements, Sentences)
eval_o [] = return (Set.empty, [])
eval_o ((Unlock n):os) = error "Unlock declaration not allowed here"
eval_o ((Elements e):os) = do (e1, s1) <- eval_o os 
                              es <- (eval_e e)
                              return (Set.union es e1, s1)
eval_o ((OnUse s):os) = do (e1, s1) <- eval_o os 
                           return (e1, s1++s)


eval :: GameDefinition -> M Gamma
eval [] = return emptyGamma
eval ((Game objs):defs) = do (e, s) <- eval_o [Elements objs]
                             (o2, t2) <- eval defs

                             return (Map.union (Map.insert "game" (e,s) Map.empty) o2, t2)
