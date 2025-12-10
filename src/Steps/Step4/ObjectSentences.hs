{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Steps.Step4.ObjectSentences where

import AST
import GameStateMonad
import Control.Monad.State ()
import Steps.Step3.Conditions
import Control.Monad
import PrettyPrinter

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

