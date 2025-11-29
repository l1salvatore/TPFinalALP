{-# LANGUAGE GADTs #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE InstanceSigs #-}
module GameModel where

import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Stack

-- Objetos O
type ObjectsMap = Map.Map ObjectName ObjectData
data ObjectData = ObjectData
  { telements :: Set.Set ObjectName,
    tsentences :: [Sentence],
    code :: Maybe UnlockCode
  } deriving (Show, Eq)

emptyObjectData :: ObjectData
emptyObjectData = ObjectData Set.empty [] Nothing

-- Los elementos es un conjunto de nombres de objetos
type Elements = Set.Set ObjectName



-- El tipo de dato de bloqueo de un objeto: puede ser locked o unlocked
data BlockData = VLock | VUnlock deriving (Show, Eq)

-- Mapa de bloqueos de objetos (L)
type BlockMap = Map.Map ObjectName BlockData

-- La pila de navegación de objetos
type ObjectStack = [ObjectName]

-- El estado de la evaluación: contiene el mapa de bloqueos y la pila de navegación
type Sigma = (BlockMap, ObjectStack)

-- initSigma :: TargetsMap -> Sigma
-- initSigma targets = (initialBlockMap, initialStack)
--   where
--     -- 1. Creamos el BlockMap:
--     -- Map.map toma el TargetsMap, ignora los valores (TargetDefData),
--     -- y crea un nuevo mapa con las MISMAS keys, pero
--     -- con el valor VLock para cada una.
--     initialBlockMap = Map.map (const VLock) targets

--     -- 2. Creamos la pila de navegación inicial
--     initialStack = ["game"]

-- El comando de entrada del usuario
data InputCommand = InputSelect ObjectName
                  | InputUnlock UnlockCode
                  | InputBack
                  | InputUse
        deriving(Show ,Eq)


-- El mapa de objetos: un par de mapas, uno para ítems y otro para objetivos
type Gamma = Map.Map ObjectName Type

-- El mapa de objetos vacío, el estado inicial
emptyGamma :: Gamma
emptyGamma = Map.empty