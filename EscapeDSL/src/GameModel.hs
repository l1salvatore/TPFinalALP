{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module GameModel where

import AST
import qualified Data.Map as Map
import qualified Data.Set as Set



-- Objetos O: ObjectName -> Elements x Sentences x (N u {e})
type ObjectsMap = Map.Map ObjectName ObjectData
-- El mapa de objetos vacío
emptyObjectsMap :: ObjectsMap
emptyObjectsMap = Map.empty



-- Elements x Sentences x (N u {e}) ; La data del juego
data ObjectData = ObjectData
  { elements :: Set.Set ObjectName,
    sentences :: [Sentence],
    code :: Maybe UnlockCode
  } deriving (Show, Eq)
-- La data vacía o zero
emptyObjectData :: ObjectData
emptyObjectData = ObjectData Set.empty [] Nothing




-- Los elementos es un conjunto de nombres de objetos
-- Elements = Partes de ObjectName
type Elements = Set.Set ObjectName



-- El entorno de tipos gamma. 
-- Gamma : ObjectName -> Type
type Gamma = Map.Map ObjectName Type
-- El mapa de objetos vacío, el estado inicial
emptyGamma :: Gamma
emptyGamma = Map.empty



-- El tipo de dato de bloqueo de un objeto: puede ser locked o unlocked
-- { locked, unlocked}
data BlockData = VLock | VUnlock deriving (Show, Eq)



-- Mapa de bloqueos de objetos (L)
-- L : O' -> { locked, unlocked}
-- O' = { o in dom(Gamma) / Gamma(o) = target}
type BlockMap = Map.Map ObjectName BlockData



-- La pila de navegación de objetos
type ObjectStack = [ObjectName]



-- El estado de la evaluación: contiene el mapa de bloqueos y la pila de navegación
type Sigma = (BlockMap, ObjectStack)



-- El comando de entrada del usuario
data InputCommand = InputSelect ObjectName
                  | InputUnlock UnlockCode
                  | InputBack
                  | InputUse
        deriving(Show ,Eq)

