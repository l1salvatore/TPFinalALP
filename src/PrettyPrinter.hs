{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module PrettyPrinter where
import AST (ObjectName)
import qualified Data.Set as Set

-- Estos casos de errores se aplican cuando el usuario ingresa comandos incorrectos. 
-- El error mostrado se muestra siguiendo un formato de printing que es agradable al usuario

data UserErrorType = ObjectNotFound | CurrentObjectNotTarget | IncorrectLockCode 
  deriving (Show, Eq)

-- Simplemente imprime un mensaje usando putStrLn
ppMessage :: String -> IO ()
ppMessage = putStrLn

-- En base al tipo de error, muestra el correspondiente mensaje
ppUserError :: UserErrorType -> String -> IO ()
ppUserError ObjectNotFound x = do putStr "Object "
                                  putStr x
                                  putStrLn " not found in current context"
ppUserError CurrentObjectNotTarget x = do putStr "Current object "
                                          putStr x
                                          putStrLn " is not a target"
ppUserError IncorrectLockCode x = do putStr "Incorrect unlock code for object "
                                     putStrLn x

-- Muestra la lista de elementos       
ppElements :: Set.Set ObjectName -> IO ()
ppElements s = do putStrLn "Game Elements" -- Imprime 'Game Elements'
                  ppObjList (Set.toList s) -- Y luego imprime la lista

-- Muestra el objeto actual de navegación
ppCurrentObject :: ObjectName -> IO ()
ppCurrentObject o = do putStr "Current Object: " -- Imprime mensaje
                       putStrLn o -- Imprime el nombre del objeto

-- Imprime el mensaje 'Showing Object' del objeto O
ppShowObject :: ObjectName -> IO ()
ppShowObject o = do putStr "Showing Object: " -- Imprime mensaje
                    putStrLn o -- Imprime el nombre del objeto

-- Imprime el mensaje 'Selected Object' del objeto O
ppSelectObject :: ObjectName -> IO ()
ppSelectObject o = do putStr "Selected Object: " -- Imprime mensaje
                      putStrLn o -- Imprime el nombre del objeto

-- Imprime el mensaje 'Unlocked Object' del objeto O
ppUnlockObject :: ObjectName -> IO () 
ppUnlockObject o = do putStr "Unlocked Object: " -- Imprime mensaje
                      putStrLn o -- Imprime el nombre del objeto

-- Imprime el menú
ppShowMenu :: IO ()
ppShowMenu = do putStrLn "Available commands:"
                putStrLn " select <object_name>  -- Select an object from the current object's elements"
                putStrLn " unlock <code>         -- Unlock the current object with the provided code"
                putStrLn " back                  -- Go back to the previous object"
                putStrLn " use                   -- Use the current object"
                putStrLn " help                  -- Show help"
                putStrLn " quit                  -- Quit the game"

-- Imprime una lista de objetos
ppObjList :: [ObjectName] -> IO ()
ppObjList [x] = do putStr "* "
                   putStrLn x
ppObjList (x:xs) = do putStr "* "
                      putStrLn x
                      ppObjList xs
ppObjList [] = putStrLn ""