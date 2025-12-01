{-# LANGUAGE GADTs #-}
module GameExec where

import AST
import GameModel
import GameStateMonad
import Control.Monad (when)
import PrettyPrinter
import qualified Data.Set as Set
import qualified Data.Map as Map
import ExpressionValidator

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


executeCmd :: Command -> GameState ()
executeCmd (Show (ShowMessage msg)) = applyprettyprinter ppMessage msg
executeCmd (Show (ShowObject obj)) = applyprettyprinter ppShowObject obj

execute :: Sentences -> GameState ()
execute [] = return ()
execute ((Command c):xs) = do executeCmd c
                              execute xs
execute ((IfCommand cond c):xs) = do b <- evalCond cond
                                     when b $ executeCmd c
                                     execute xs


parseInput :: String -> Maybe InputCommand
parseInput input = case words input of
                      ["select", obj] -> Just (InputSelect obj)
                      ["unlock", codeStr] -> case reads codeStr :: [(Int, String)] of
                                               [(codee, "")] -> Just (InputUnlock codee)
                                               _ -> Nothing
                      ["back"] -> Just InputBack
                      ["use"] -> Just InputUse
                      _ -> Nothing



processUserInput :: String -> GameState ()
processUserInput msg = case parseInput msg of
               Nothing -> applyprettyprinter ppMessage "Invalid command"
               Just cmd -> case cmd of
                             InputSelect obj -> do current <- objectNavigationTop
                                                   elements <- getelements current
                                                   if Set.member obj elements
                                                     then do objectNavigationPush obj
                                                             applyprettyprinter ppSelectObject obj
                                                     else applyprettyprinter (ppUserError ObjectNotFound) obj
                             InputUnlock inputcode -> do current <- objectNavigationTop
                                                         currentistarget <- checkistargetBool current
                                                         if currentistarget then
                                                                               do odata <- getobjectdata current
                                                                                  case code odata of
                                                                                        Nothing -> applyprettyprinter (ppUserError CurrentObjectNotTarget) current
                                                                                        Just requiredcode -> if inputcode == requiredcode
                                                                                                             then do applyprettyprinter ppUnlockObject current
                                                                                                                     unlock current
                                                                                                             else  applyprettyprinter (ppUserError IncorrectLockCode)  current

                                                         else applyprettyprinter (ppUserError CurrentObjectNotTarget) current
                             InputBack -> do applyprettyprinter ppMessage "Going back"
                                             objectNavigationPop
                             InputUse -> do applyprettyprinter ppMessage "Using current object"
                                            current <- objectNavigationTop
                                            istarget <- checkistargetBool current
                                            when istarget $ do status <- getLockStatus current
                                                               when (status == VLock) $ applyprettyprinter ppMessage "It seems this object has an unlock mechanism."
                                            sentences <- getusecommands current
                                            execute sentences
runGame :: GameState ()
runGame = do applyprettyprinter ppMessage "Welcome to escape room"
             applyprettyprinter (const ppShowMenu) ()
             showrootgame
             runGame'

runGame' :: GameState ()
runGame' = do msg <- readusercmd
              case msg of
                 "quit" -> applyprettyprinter ppMessage "Exiting game. Goodbye!"
                 "help" -> do applyprettyprinter (const ppShowMenu) ()
                              runGame'
                 _      -> do processUserInput msg
                              b <- allunlocked
                              if b then applyprettyprinter ppMessage "Congratulations! All objects are unlocked. You have completed the game."
                                  else runGame'

