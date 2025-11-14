{-# LANGUAGE GADTs #-}
module GameExec where

import AST
import EvalCommon
import MonadGame
import ConditionsEval
import Control.Monad (when)
import qualified Data.Set as Set
import qualified Data.Map as Map

executeCmd :: Command -> Gamma ()
executeCmd (Show (ShowMessage msg)) = printmsg msg
executeCmd (Show (ShowObject obj)) = printmsg ("Showing object: " ++ obj)

execute :: Sentences -> Gamma ()
execute [] = return ()
execute ((Command c):xs) = do executeCmd c
                              execute xs
execute ((IfCommand cond c):xs) = do b <- ceval cond
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
               Nothing -> printmsg "Invalid command"
               Just cmd -> case cmd of
                             InputSelect obj -> do current <- navigationtop
                                                   elements <- getelements current
                                                   if Set.member obj elements
                                                     then do navigationpush obj
                                                             printmsg ("Selected object: " ++ obj)
                                                     else printmsg ("Object " ++ obj ++ " not found in current context")
                             InputUnlock inputcode -> do current <- navigationtop
                                                         objects <- getobjects
                                                         let (_, targetsmap) = objects
                                                         case Map.lookup current targetsmap of
                                                            Nothing -> printmsg ("Current object " ++ current ++ " is not a target")
                                                            Just targetdata -> let requiredcode = code targetdata
                                                                               in if inputcode == requiredcode
                                                                                  then do printmsg ("Unlocked object " ++ current)
                                                                                          unlock current
                                                                                  else printmsg ("Incorrect unlock code for object " ++ current)
                             InputBack -> do printmsg "Going back"
                                             navigationpop
                             InputUse -> do printmsg "Using current object"
                                            sentences <- getusecommands =<< navigationtop
                                            execute sentences
runGame :: Gamma ()
runGame = do msg <- readusercmd
             processUserInput msg
             b <- allunlocked
             if b then printmsg "Congratulations! All objects are unlocked. You have completed the game."
                  else runGame
             
      
              