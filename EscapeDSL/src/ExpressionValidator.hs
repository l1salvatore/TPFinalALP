{-# LANGUAGE GADTs #-}
module ExpressionValidator where

import AST
import GameStateMonad
import GameModel
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Monad.State
import Control.Monad (ap)

class Monad m => GameStateValidation m where
   checkistargetException :: ObjectName -> m ()
   checkistargetBool :: ObjectName -> m Bool
   checkisaelementofException :: ObjectName -> ObjectName -> m ()
   checkingammaException :: ObjectName -> m ()

instance GameStateValidation GameState where
  checkistargetBool objname = do
                            (GameEnv gamma _, _) <- GameState get
                            case Map.lookup objname gamma of
                              Nothing -> error (objname ++ " object not found")
                              Just ttype -> if ttype == TTarget then return True else return False
  checkistargetException objname = do
                            (GameEnv gamma _, _) <- GameState get
                            case Map.lookup objname gamma of
                              Nothing -> throwException (objname ++ " object not found")
                              Just ttype -> if ttype == TTarget then return () else throwException (objname ++ " is not a target")
  checkisaelementofException elementname objectname = do
                                        (GameEnv _ objectmap, _) <- GameState get
                                        case Map.lookup objectname objectmap of
                                          Nothing -> throwException (objectname ++ " object not found")
                                          Just odata -> if Set.member elementname (elements odata) then return ()
                                                        else throwException (elementname ++ " is not an element of "++ objectname)
  checkingammaException objectname = do
                          (GameEnv gamma _, _) <- GameState get
                          case Map.lookup objectname gamma of
                            Nothing -> throwException (objectname ++ " object not found")
                            Just _ -> return ()


validateGameDefinition :: GameDefinition ->  ObjectName -> GameState ()
validateGameDefinition [] _ = return ()
validateGameDefinition (Game elems : rest) currentobject = do
                                                                    validateElements elems  currentobject
                                                                    validateGameDefinition rest  currentobject
                                                                    
validateGameDefinition (ObjectDef _ objname decls : rest)  currentobject = do
                                                                            validateDeclarations decls  objname
                                                                            validateGameDefinition rest  currentobject

validateDeclarations :: [Declaration] ->  ObjectName -> GameState ()
validateDeclarations [] _ = return ()
validateDeclarations (Unlock _ : rest) currentobject = do 
                                                               checkistargetException currentobject 
                                                               validateDeclarations rest  currentobject
validateDeclarations (Elements elems : rest) currentobject = do
                                                                     validateElements elems  currentobject
                                                                     validateDeclarations rest  currentobject
validateDeclarations (OnUse sentences : rest) currentobject = do
                                                                      validateSentences sentences currentobject
                                                                      validateDeclarations rest currentobject

validateSentences :: [Sentence] ->  ObjectName -> GameState ()
validateSentences [] _ = return ()
validateSentences (Command command : rest) currentobject = do
                                                                   validateCommand command  currentobject
                                                                   validateSentences rest  currentobject
validateSentences (IfCommand conditions command : rest)  currentobject = do
                                                                                validateConditions conditions currentobject
                                                                                validateCommand command currentobject
                                                                                validateSentences rest currentobject

validateCommand :: Command ->  ObjectName -> GameState ()
validateCommand (Show (ShowObject x)) currentobject =  do 
                                                               checkingammaException x
                                                               checkingammaException currentobject
                                                               checkisaelementofException x currentobject
validateCommand (Show (ShowMessage _)) _ = return ()

validateConditions :: Conditions ->  ObjectName -> GameState ()
validateConditions Locked currentobject = checkistargetException currentobject
validateConditions Unlocked currentobject = checkistargetException currentobject
validateConditions (ObjectLocked o) currentobject = do 
                                                            checkisaelementofException o currentobject
                                                            checkistargetException o
validateConditions (ObjectUnlocked o) currentobject = do   
                                                              checkisaelementofException o currentobject 
                                                              checkistargetException o 
validateConditions (And c1 c2)  currentobject = do 
                                                       validateConditions c1 currentobject
                                                       validateConditions c2 currentobject
validateConditions (Or c1 c2)  currentobject = do 
                                                      validateConditions c1 currentobject
                                                      validateConditions c2 currentobject


validateElements :: [ObjectName] ->  ObjectName -> GameState ()
validateElements [] _ = return ()
validateElements (objname : xs)  currentobject = do 
                                                    checkingammaException objname
                                                    validateElements xs currentobject
