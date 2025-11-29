{-# LANGUAGE GADTs #-}
module GameMonads where

import AST
import qualified Data.Map as Map
import Control.Monad.State
import Control.Monad (ap)
import Stack
import GameModel
import Control.Monad.Except (ExceptT, throwError)
import GHC.IO.Handle
import System.IO
import PrettyPrinter
import Control.Monad.Writer
import qualified Data.Set as Set


-- 1. El Entorno de Lectura (Read-Only)
-- Contiene los "planos" del juego que no cambian.
data GameEnv = GameEnv {
    envGamma :: Gamma,          -- Tipos
    envObjects :: ObjectsMap    -- Definiciones (Elements, OnUse, Code)
}

-- Instancia de Semigroup (Cómo sumar dos entornos)
instance Semigroup GameEnv where
    (GameEnv g1 o1) <> (GameEnv g2 o2) = 
        GameEnv (Map.union g1 g2) (if Map.keysSet o1 `Set.isDisjoint` Map.keysSet o2
                                   then Map.union o1 o2
                                   else error "Duplicate object definitions in environment")

-- Instancia de Monoid (Cuál es el entorno vacío)
instance Monoid GameEnv where
    mempty = GameEnv Map.empty Map.empty

type EnvironmentBuilder a = Writer GameEnv a

class Monad m => MonadEnvironmentBuilder m where
    singletonType :: ObjectName -> Type -> m Gamma
    singletonObjectData :: ObjectName -> ObjectData -> m ObjectsMap

instance MonadEnvironmentBuilder (EnvironmentBuilder) where
    singletonType name t = return (Map.singleton name t)
    singletonObjectData name od = return (Map.singleton name od)

-- Caso: Definición del Game
buildEnv :: [Definition] -> EnvironmentBuilder ()
buildEnv [] = return () -- Caso base: lista vacía
buildEnv (Game elements : rest) = do gammaPart <- singletonType "game" TTarget
                                     -- 1. "Escribimos" el pedacito de información del Game
                                     objPart <- singletonObjectData "game" (ObjectData (Set.fromList elements) [] Nothing)
                                     tell $ GameEnv gammaPart objPart -- ¡ACUMULAMOS!
                                      -- 2. Seguimos con el resto
                                      buildEnv rest
buildEnv (ObjectDef t name decls : rest) = do
    -- 1. "Escribimos" el pedacito de información del objeto
    let gammaPart = Map.singleton name t
    
    -- Procesamos las declaraciones para obtener los elementos, sentencias y código
    let (elements, sentences, mcode) = foldr processDecl (Set.empty, [], Nothing) decls
    
    let objPart = Map.singleton name (ObjectData elements sentences mcode)
    
    tell $ GameEnv gammaPart objPart -- ¡ACUMULAMOS!
    
    -- 2. Seguimos con el resto
    buildEnv rest