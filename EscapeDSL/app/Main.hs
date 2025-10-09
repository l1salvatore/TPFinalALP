module Main (main) where

import Lexer (alexScanTokens)
import Parser (parseEscapeRoom)
import System.IO (getContents)

main :: IO ()
main = do
    input <- getContents
    let ast = parseEscapeRoom (alexScanTokens input)
    print ast