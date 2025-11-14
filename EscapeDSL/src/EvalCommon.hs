{-# LANGUAGE GADTs #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE InstanceSigs #-}
module EvalCommon where

import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Stack



type ItemsMap = Map.Map ObjectName ItemDefData
data ItemDefData = ObjectDefData
  { ielements :: Set.Set ObjectName,
    isentences :: [Sentence]
  } deriving (Show, Eq)
emptyItemDefData :: ItemDefData
emptyItemDefData = ObjectDefData Set.empty []

type TargetsMap = Map.Map ObjectName TargetDefData
data TargetDefData = TargetDefData
  { telements :: Set.Set ObjectName,
    tsentences :: [Sentence],
    code :: UnlockCode
  } deriving (Show, Eq)
emptyTargetDefData :: TargetDefData
emptyTargetDefData = TargetDefData Set.empty [] 0

type Elements = Set.Set ObjectName
type Sentences = [Sentence]

-- El entorno Gamma: un par de mapas, uno para ítems y otro para objetivos
type Objects = (ItemsMap, TargetsMap)

-- El entorno Gamma vacío, el estado inicial
emptyObjects :: Objects
emptyObjects = (Map.empty, Map.empty)

-- El tipo de dato de bloqueo de un objeto: puede ser locked o unlocked
data BlockData = VLock | VUnlock deriving (Show, Eq)

-- Mapa de bloqueos de objetos (L)
type BlockMap = Map.Map ObjectName BlockData

-- La pila de navegación de objetos
type ObjectStack = Stack ObjectName

-- El estado de la evaluación: contiene el entorno Gamma, el mapa de bloqueos y la pila de navegación
type GameState = (BlockMap, ObjectStack)

initGameState :: TargetsMap -> GameState
initGameState targets = (initialBlockMap, initialStack)
  where
    -- 1. Creamos el BlockMap:
    -- Map.map toma el TargetsMap, ignora los valores (TargetDefData),
    -- y crea un nuevo mapa con las MISMAS keys, pero
    -- con el valor VLock para cada una.
    initialBlockMap = Map.map (const VLock) targets

    -- 2. Creamos la pila de navegación inicial
    initialStack = Stack ["game"]

-- El comando de entrada del usuario
data InputCommand = InputSelect ObjectName
                  | InputUnlock UnlockCode
                  | InputBack
                  | InputUse
        deriving(Show ,Eq)
