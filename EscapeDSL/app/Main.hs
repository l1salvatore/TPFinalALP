module Main (main) where

import Parser.Lexer (alexScanTokens)
import Parser.Parser (parseEscapeRoom)
import System.IO (getContents)
import Eval (eval, emptyGamma, runM)
import Control.Monad.State (runStateT)

main :: IO ()
main = do
    input <- getContents
    let ast = parseEscapeRoom (alexScanTokens input)
    case runStateT (runM (eval ast)) emptyGamma of
        Left err -> putStrLn ("Error: " ++ err)
        Right (res, gammaFinal) -> do
            putStrLn "Evaluación exitosa:"
            print res
            putStrLn "Estado final:"
            print gammaFinal