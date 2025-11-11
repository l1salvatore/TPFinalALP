module Main (main) where

import Parser.Lexer (alexScanTokens)
import Parser.Parser (parseEscapeRoom)
import System.IO (getContents)
import Eval (eval)

main :: IO ()
main = do
    input <- getContents
    let ast = parseEscapeRoom (alexScanTokens input)
    print ast