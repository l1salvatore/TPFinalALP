import Parser.Lexer (alexScanTokens)
import Parser.Parser (parseEscapeRoom)
import Eval (collectObjects)
import EvalModel
import GameMonads (runGamma, runSigma, Gamma (runGamma), Sigma (Sigma))
import GameExec (runGame)
import Control.Monad.Except (runExceptT)
import Control.Monad.State (runStateT)
import System.Environment (getArgs)
import qualified Data.Map as Map 
import Stack (Stack(Stack))

main :: IO ()
main = do
    -- 1. Obtener el nombre del archivo y parsear el AST (igual que antes)
    args <- getArgs
    case args of
        [filename] -> do
            input <- readFile filename
            let ast = parseEscapeRoom (alexScanTokens input)

            -- ----------------------------------------------------
            -- ETAPA 1: Ejecutar 'eval' para obtener los 'Objects'
            -- ----------------------------------------------------
            
            -- 'collectObjects ast' es de tipo Gamma ()
            -- Lo corremos con un estado Gamma (Objects) vacío
            let (Sigma sigmaActionForEval) = runStateT (runGamma (collectObjects ast)) emptyObjects

            -- Para correr esta acción de Sigma, necesitamos un GameState "dummy".
            -- No importa, porque 'eval' (idealmente) no debería tocar el GameState.
            let dummyGameState = (Map.empty, Stack ["game"]) 
            
            -- Corremos la pila de 'eval'
            evalResult <- runExceptT (runStateT sigmaActionForEval dummyGameState)

            -- Revisamos si 'eval' falló
            case evalResult of
                Left errMsg -> putStrLn $ "Error during evaluation: " ++ errMsg
                
                -- ¡Éxito! 'eval' nos dio los 'finalObjects'
                Right ((_, finalObjects), _) -> do
                    
                    -- ----------------------------------------------------
                    -- ETAPA 2: Ejecutar 'runGame' con el estado correcto
                    -- ----------------------------------------------------
                    
                    -- 1. Extraemos el TargetsMap de los objetos que cargamos
                    let (_, targetsMap) = finalObjects
                    
                    -- 2. ¡Llamamos a tu nueva función!
                    --    Creamos el GameState INICIAL REAL
                    let realInitialGameState = initGameState targetsMap
                    
                    -- 3. Ahora corremos 'runGame'.
                    --    La acción 'runGame' vive en la mónada Gamma.
                    --    La corremos con los 'finalObjects' como su estado inicial.
                    let (Sigma sigmaActionForGame) = runStateT (runGamma runGame) finalObjects
                    
                    -- 4. Corremos la pila de 'runGame'
                    --    ¡Esta vez usamos el 'realInitialGameState'!
                    gameResult <- runExceptT (runStateT sigmaActionForGame realInitialGameState)
                    
                    -- 5. Manejamos el resultado final del juego
                    case gameResult of
                        Left errMsg -> putStrLn $ "Error during game: " ++ errMsg
                        Right (((), _), finalGameState) -> do
                            putStrLn "Game run successful."

        _ -> putStrLn "Usage: ./your-game-executable <game_file.esc>"