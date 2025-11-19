{-# LANGUAGE GADTs #-}
module GameExec where

import AST
import EvalModel
import GameMonads
import Control.Monad (when)
import Eval
import PrettyPrinter
import qualified Data.Set as Set
import qualified Data.Map as Map

executeCmd :: Command -> Gamma ()
executeCmd (Show (ShowMessage msg)) = applyprettyprinter ppMessage msg
executeCmd (Show (ShowObject obj)) = applyprettyprinter ppShowObject obj

execute :: Sentences -> Gamma ()
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



processUserInput :: String -> Gamma ()
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
                                                         (_, targetsmap) <- getobjects
                                                         case Map.lookup current targetsmap of
                                                            Nothing -> applyprettyprinter (ppUserError CurrentObjectNotTarget)  current
                                                            Just targetdata -> let requiredcode = code targetdata
                                                                               in if inputcode == requiredcode
                                                                                  then do applyprettyprinter ppUnlockObject current
                                                                                          unlock current
                                                                                  else  applyprettyprinter (ppUserError IncorrectLockCode)  current
                             InputBack -> do applyprettyprinter ppMessage "Going back"
                                             objectNavigationPop
                             InputUse -> do applyprettyprinter ppMessage "Using current object"
                                            current <- objectNavigationTop
                                            do (_, targetsmap) <- getobjects
                                               case Map.lookup current targetsmap of
                                                     Nothing -> return ()
                                                     Just _ -> do status <- getLockStatus current
                                                                  when (status == VLock) $ applyprettyprinter ppMessage "It seems this object has an unlock mechanism."
                                            sentences <- getusecommands current
                                            execute sentences
runGame :: Gamma ()
runGame = do applyprettyprinter ppMessage "Welcome to escape room"
             applyprettyprinter (const ppShowMenu) ()
             showrootgame
             runGame'

runGame' :: Gamma ()
runGame' = do msg <- readusercmd
              case msg of
                 "quit" -> applyprettyprinter ppMessage "Exiting game. Goodbye!"
                 "help" -> do applyprettyprinter (const ppShowMenu) ()
                              runGame'
                 _      -> do processUserInput msg
                              b <- allunlocked
                              if b then applyprettyprinter ppMessage "Congratulations! All objects are unlocked. You have completed the game."
                                  else runGame'