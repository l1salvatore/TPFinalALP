{-# LANGUAGE GADTs #-}
module Main (main) where

import Parser.Lexer (alexScanTokens)
import Parser.Parser (parseEscapeRoom)
import System.Environment (getArgs)
import GameStateMonad
import AST
import ExpressionValidator
import GameExec
import GameModel
import Control.Monad.Except
import Control.Monad.State
import qualified Data.Map as Map

main :: IO ()
main = do
    args <- getArgs
    case args of
        [filename] -> do
            input <- readFile filename
            let ast = parseEscapeRoom (alexScanTokens input)
            
            -- Ejecutar el juego con el AST parseado
            result <- runExceptT (runStateT (runGameState (buildAndStartGame ast >> runGame)) (GameEnv emptyGamma emptyObjectsMap, (Map.empty, ["game"])))
            
            case result of
                Left err -> putStrLn $ "Error: " ++ err
                Right _ -> putStrLn "Game finished."
        _ -> putStrLn "Usage: EscapeDSL-exe <game_file.esc>"

-- Función para construir el entorno inicial del juego
buildAndStartGame :: GameDefinition -> GameState ()
buildAndStartGame ast = do 
    buildEnvironment ast
    validateGameDefinition ast "game"