{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs #-}
module Eval where

import AST
import Data.Maybe (fromMaybe)
import qualified Data.Map as Map
import qualified Data.Set as Set

type ObjectsMap = Map.Map ObjectName ObjectDefData
data ObjectDefData = ObjectDefData
  { elements :: Set.Set ObjectName,
    sentences :: [Sentence]
  } deriving (Show, Eq)

type TargetsMap = Map.Map ObjectName TargetDefData
data TargetDefData = TargetDefData
  { elements :: Set.Set ObjectName,
    sentences :: [Sentence],
    code :: UnlockCode
  } deriving (Show, Eq)

type Gamma = (ObjectsMap, TargetsMap)
emptyGamma :: Gamma
emptyGamma = (Map.empty, Map.empty)

eval :: GameDefinition -> Gamma
eval [] = emptyGamma
eval ((Game objs):defs) = do (o1, t1) <- eval_o(objs)
                             (o2, t2) <- eval defs
                             (Map.union o1 o2, Map.union t1 t2) 