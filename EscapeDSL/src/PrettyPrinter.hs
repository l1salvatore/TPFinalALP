{-# LANGUAGE GADTs #-}
module PrettyPrinter where
import AST (ObjectName)
import qualified Data.Set as Set

data UserErrorType = ObjectNotFound | CurrentObjectNotTarget | IncorrectLockCode 
  deriving (Show, Eq)
ppMessage :: String -> IO ()
ppMessage = putStrLn

ppUserError :: UserErrorType -> String -> IO ()
ppUserError ObjectNotFound x = do putStr "Object "
                                  putStr x
                                  putStrLn " not found in current context"
ppUserError CurrentObjectNotTarget x = do putStr "Current object "
                                          putStr x
                                          putStrLn " is not a target"
ppUserError IncorrectLockCode x = do putStr "Incorrect unlock code for object "
                                     putStrLn x
                                     
ppElements :: Set.Set ObjectName -> IO ()
ppElements s = do putStrLn "GameElements"
                  ppObjList (Set.toList s)

ppCurrentObject :: ObjectName -> IO ()
ppCurrentObject o = do putStr "Current Object: "
                       putStrLn o

ppShowObject :: ObjectName -> IO ()
ppShowObject o = do putStr "Showing Object: "
                    putStrLn o

ppSelectObject :: ObjectName -> IO ()
ppSelectObject o = do putStr "Selected Object: "
                      putStrLn o

ppUnlockObject :: ObjectName -> IO ()
ppUnlockObject o = do putStr "Unlocked Object: "
                      putStrLn o

ppObjList :: [ObjectName] -> IO ()
ppObjList [x] = do putStr "* "
                   putStrLn x
ppObjList (x:xs) = do putStr "* "
                      putStrLn x
                      ppObjList xs
ppObjList [] = putStrLn ""