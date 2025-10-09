module Main (main) where
main :: IO ()
main = do
    input <- getContents
    let tokens = alexScanTokens input
    print tokens