{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

-- | Módulo EnvironmentBuilder
-- Este módulo se encarga de construir el entorno del juego a partir de las definiciones del AST.
-- Incluye la construcción de datos de objetos individuales y el entorno completo.
module Steps.Step1.EnvironmentBuilder where

import AST
import GameStateMonad
import GameModel
import Control.Monad.State ()
import qualified Data.Set as Set
import Control.Monad

-- | Construye los datos de un objeto a partir de sus declaraciones
-- 
-- Procesa recursivamente la lista de declaraciones y construye un ObjectData con:
-- - Elementos del objeto (si tiene declaración Elements)
-- - Código de desbloqueo (si tiene declaración Unlock)
-- - Sentencias de comportamiento (si tiene declaración OnUse)
--
-- Los parámetros de tupla (Int, Int, Int) son contadores para evitar duplicados:
-- - Primer Int: contador de declaraciones Elements (máximo 1)
-- - Segundo Int: contador de declaraciones OnUse (máximo 1)
-- - Tercer Int: contador de declaraciones Unlock (máximo 1)
buildObjectData :: [Declaration] -> Type -> (Int, Int, Int) -> GameState ObjectData
-- Caso base: lista de declaraciones vacía
-- Retorna un ObjectData vacío del tipo especificado
buildObjectData [] t _ = return (emptyObjectData t)

-- Caso 1: Declaración de desbloqueo (Unlock)
-- Verifica que no haya múltiples declaraciones de unlock
-- Si n > 0, ya hay un unlock declarado previamente, por lo que lanza un error
buildObjectData ((Unlock ncode) : xs) t (e,s,n) = if n > 0 then error "Multiple declarations of unlock"
                                                else
                                                do
                                                  odata <- buildObjectData xs t (e, s, n+1) -- Procesar el resto, incrementando contador de unlock
                                                  return (odata { code = Just ncode }) -- Agregar el código de desbloqueo al ObjectData
-- Caso 2: Declaración de elementos (Elements)
-- Verifica que no haya múltiples declaraciones de elementos
-- Si e > 0, ya hay elementos declarados previamente, por lo que lanza un error
buildObjectData ((Elements objList) : xs) t (e,s,n)  = if e > 0 then error "Multiple declarations of elements"
                                                     else
                                                     do
                                                      odata <- buildObjectData xs t (e+1,s,n) -- Procesar el resto, incrementando contador de elementos
                                                      return (odata { elements = Set.fromList objList}) -- Convertir lista a conjunto y agregar al ObjectData
-- Caso 3: Declaración de comportamiento al usar el objeto (OnUse)
-- Verifica que no haya múltiples declaraciones de OnUse
-- Si s > 0, ya hay un comportamiento declarado previamente, por lo que lanza un error
buildObjectData ((OnUse onUseCode) : xs) t (e,s,n) = if s > 0 then error "Multiple declarations of onUSe"
                                                   else
                                                   do
                                                      odata <- buildObjectData xs t (e,s+1,n) -- Procesar el resto, incrementando contador de OnUse
                                                      return (odata { sentences = onUseCode }) -- Agregar las sentencias al ObjectData

-- | Construye el entorno completo del juego a partir de la definición del juego
-- 
-- Procesa recursivamente todas las definiciones (Game y ObjectDef) y:
-- 1. Convierte definiciones Game a ObjectDef de tipo TItem
-- 2. Construye el ObjectData para cada objeto
-- 3. Inserta cada objeto en el entorno
-- 4. Para objects del tipo Target, inicializa su estado de bloqueo como bloqueado (VLock)
buildEnvironment :: GameDefinition -> GameState ()
-- Caso base: definición vacía, no hay nada que construir
buildEnvironment [] = return ()

-- Caso 1: Definición del juego raíz (Game)
-- Convierte "game {elementos}" en "item game {elements: [elementos]}"
-- Esto normaliza la definición para que sea tratada como un objeto normal
buildEnvironment ((Game objList) :xs) = do
                                            buildEnvironment (ObjectDef TItem "game" [Elements objList]: xs)
-- Caso 2: Definición de un objeto (ObjectDef)
-- Procesa la definición del objeto y lo agrega al entorno
buildEnvironment ((ObjectDef typ name decls):xs) = do
                                                      odata <- buildObjectData decls typ (0,0,0) -- Construir los datos del objeto
                                                      insertobjectdata name odata -- Insertar el objeto en el entorno de objetos
                                                      -- Si el objeto es un Target, inicializar su estado de bloqueo como bloqueado
                                                      when (typ == TTarget) $ do blockmap <- getBlockMap -- Obtener mapa de bloqueos actual
                                                                                 newblockmap <- getNewBlockMap name VLock blockmap -- Añadir nuevo target al mapa bloqueado
                                                                                 putBlockMap newblockmap -- Actualizar mapa de bloqueos
                                                      buildEnvironment xs -- Procesar recursivamente el resto de definiciones




