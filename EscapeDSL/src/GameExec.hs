{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module GameExec where

import AST
import GameModel
import GameStateMonad
import Control.Monad (when)
import PrettyPrinter
import qualified Data.Set as Set
import ExpressionValidator

-- Empezamos con la función runGame que es un GameState ()
runGame :: GameState ()
runGame = do applyprettyprinter ppMessage "Welcome to escape room" --Imprime sólamente este mensaje
             applyprettyprinter (const ppShowMenu) () -- Imprime el menú
             showrootgame -- Muestro los objetos del juego. Los principales objetos del juego
             runGame' -- Llamo a runGame', donde esta función será recursiva

-- Definición auxiliar de la ejecución del juego

runGame' :: GameState ()
runGame' = do msg <- readusercmd -- Leo el comando del usuario
              case msg of
                 -- El usuario ingresó quit
                 "quit" -> applyprettyprinter ppMessage "Exiting game. Goodbye!" -- Imprime sólamente el mensaje
                 -- El usuario ingresó help
                 "help" -> do applyprettyprinter (const ppShowMenu) () -- Imprime el menú
                              runGame' -- Llamo recursivamente 
                -- En cualquier otro caso
                 _      -> do processUserInput msg -- Proceso la entrada del usuario, es un comando 
                              b <- allunlocked -- Chequeo si están todos los objetivos desbloqueados
                              -- Si es así, imprimo el mensaje de logro
                              if b then applyprettyprinter ppMessage "Congratulations! All objects are unlocked. You have completed the game."
                              -- En caso contrario, vuelvo a llamar recursivamente al juego
                                  else runGame'

-- Proceso la entrada del usuario. Toma una string y devuelve un GameState
processUserInput :: String -> GameState ()
processUserInput msg = case parseInput msg of -- Parseo la entrada del usuario
               Nothing -> applyprettyprinter ppMessage "Invalid command" -- Comando Invalido
               Just cmd -> case cmd of -- Comando reconocido, proceso a analizar en un case al comando
                             -- El usuario quiere seleccionar un objeto
                             InputSelect obj -> do current <- objectNavigationTop -- Extraigo el objeto actual en la pila de navegación
                                                   elements <- getelements current -- Extraigo los elementos del objeto actual
                                                   if Set.member obj elements -- Si el objeto que quiere seleccionar el usuario está entre los elementos del objeto actual, es decir, es alcanzable
                                                     then do objectNavigationPush obj -- Pusheo en la pila de navegación al objeto seleccionado, es decir, entro en el contexto del objeto seleccionado
                                                             applyprettyprinter ppSelectObject obj -- Imprimo el objeto seleccionado
                                                     else applyprettyprinter (ppUserError ObjectNotFound) obj -- Si no está el objeto, imprimo un mensaje de error "Objecto no encontrado"
                             -- El usuario ingresa un código de desbloqueo
                             InputUnlock inputcode -> do current <- objectNavigationTop -- Extraigo el objeto actual en la pila de navegación
                                                         currentistarget <- checkistargetBool current -- Chequeo si el objeto actual es un objetivo
                                                         if currentistarget then -- Si es un objetivo
                                                                               do unlockcode <- getcode current -- Extraigo el código de este objeto actual
                                                                                  case unlockcode of -- Si el unlock code 
                                                                                        Nothing -> applyprettyprinter (ppUserError CurrentObjectNotTarget) current -- No hay codigo, entonces imprimo el error de que el objeto actual no es objetivo
                                                                                        Just requiredcode -> if inputcode == requiredcode -- Hay un código, chequeo que el input sea igual al código requerido
                                                                                                             then do applyprettyprinter ppUnlockObject current -- Si lo es, imprimo el mensaje de objeto desbloqueado
                                                                                                                     unlock current -- Desbloqueo el objeto
                                                                                                             else  applyprettyprinter (ppUserError IncorrectLockCode)  current -- Si no son iguales, imprimo el mensaje de código incorrecto

                                                         else applyprettyprinter (ppUserError CurrentObjectNotTarget) current -- Si no es un objetivo imprimo el mensaje de que el objeto actual no es un objetivo
                             -- El usuario quiere 'soltar' o navegar hacia el objeto anterior
                             InputBack -> do applyprettyprinter ppMessage "Going back" -- Imprime el mensaje "Going back"
                                             objectNavigationPop -- Se realiza el pop del objeto de la pila
                             -- El usuario quiere usar el objeto 
                             InputUse -> do applyprettyprinter ppMessage "Using current object" -- Se imprime el mensaje "usando el objeto actual"
                                            current <- objectNavigationTop  -- Extraigo el objeto actual en la pila de navegación
                                            istarget <- checkistargetBool current -- Chequeo si el objeto actual es un objetivo
                                            when istarget $ do status <- getLockStatus current -- Si es target, chequeo el status del objeto actual
                                                               when (status == VLock) $ applyprettyprinter ppMessage "It seems this object has an unlock mechanism." -- Si el status es locked, imprimo el mensaje de sugerencia "Este objeto parece que tiene un mecanismo de desbloqueo"
                                            sentences <- getusecommands current -- Extraigo las sentencias del objeto
                                            execute sentences -- Ejecuto las sentencias

-- Ejecucion de las sentencias
execute :: [Sentence] -> GameState ()
execute [] = return () -- No hay ninguna sentencia, retorno ()
execute ((Command c):xs) = do executeCmd c -- Ejecuto el comando c
                              execute xs -- Ejecuto el resto de la lista
execute ((IfCommand cond c):xs) = do b <- evalCond cond -- Evaluo la condición
                                     when b $ executeCmd c -- Si b es verdadera, ejecuto c
                                     execute xs -- Ejecuto el resto de la lista

-- Ejecuto los comandos
executeCmd :: Command -> GameState ()
-- ejecuto el comando 'Show msg', imprimo el mensaje msg
executeCmd (Show (ShowMessage msg)) = applyprettyprinter ppMessage msg
-- ejecuto el comando 'Show obj', imprimo el objeto obj
executeCmd (Show (ShowObject obj)) = applyprettyprinter ppShowObject obj


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



-- Parseo del input del usuario. Simplemente hago un sepBy ' '
parseInput :: String -> Maybe InputCommand
parseInput input = case words input of 
                      ["select", obj] -> Just (InputSelect obj) 
                      ["unlock", codeStr] -> case reads codeStr :: [(Int, String)] of
                                               [(code, "")] -> Just (InputUnlock code)
                                               _ -> Nothing
                      ["back"] -> Just InputBack
                      ["use"] -> Just InputUse
                      _ -> Nothing



