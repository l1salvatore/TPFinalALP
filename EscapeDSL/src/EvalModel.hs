{-# LANGUAGE GADTs #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE InstanceSigs #-}
module EvalModel where

import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Stack


-- Definiciones de datos para ítems y objetivos en el entorno Gamma
-- Para Items , es una función parcial que toma un ObjectName y devuelve su ItemDefData
-- ItemDefData es un registro con los elementos y las sentencias asociadas al item
type ItemsMap = Map.Map ObjectName ItemDefData
data ItemDefData = ItemDefData
  { ielements :: Set.Set ObjectName,
    isentences :: [Sentence]
  } deriving (Show, Eq)
emptyItemDefData :: ItemDefData
emptyItemDefData = ItemDefData Set.empty []

-- Para objetivos, es una función parcial que toma un ObjectName y devuelve su TargetDefData
-- TargetDefData es un registro con los elementos, las sentencias y el código de desbloqueo asociado al objetivo
type TargetsMap = Map.Map ObjectName TargetDefData
data TargetDefData = TargetDefData
  { telements :: Set.Set ObjectName,
    tsentences :: [Sentence],
    code :: UnlockCode
  } deriving (Show, Eq)
emptyTargetDefData :: TargetDefData
emptyTargetDefData = TargetDefData Set.empty [] 0

-- Los elementos es un conjunto de nombres de objetos
type Elements = Set.Set ObjectName

-- El mapa de objetos: un par de mapas, uno para ítems y otro para objetivos
type Gamma = (ItemsMap, TargetsMap)

-- El mapa de objetos vacío, el estado inicial
emptyGamma :: Gamma
emptyGamma = (Map.empty, Map.empty)

-- El tipo de dato de bloqueo de un objeto: puede ser locked o unlocked
data BlockData = VLock | VUnlock deriving (Show, Eq)

-- Mapa de bloqueos de objetos (L)
type BlockMap = Map.Map ObjectName BlockData

-- La pila de navegación de objetos
type ObjectStack = [ObjectName]

-- El estado de la evaluación: contiene el mapa de bloqueos y la pila de navegación
type Sigma = (BlockMap, ObjectStack)

initSigma :: TargetsMap -> Sigma
initSigma targets = (initialBlockMap, initialStack)
  where
    -- 1. Creamos el BlockMap:
    -- Map.map toma el TargetsMap, ignora los valores (TargetDefData),
    -- y crea un nuevo mapa con las MISMAS keys, pero
    -- con el valor VLock para cada una.
    initialBlockMap = Map.map (const VLock) targets

    -- 2. Creamos la pila de navegación inicial
    initialStack = ["game"]

-- El comando de entrada del usuario
data InputCommand = InputSelect ObjectName
                  | InputUnlock UnlockCode
                  | InputBack
                  | InputUse
        deriving(Show ,Eq)
