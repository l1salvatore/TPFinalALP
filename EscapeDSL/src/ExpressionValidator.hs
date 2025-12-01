{-# LANGUAGE GADTs #-}
module ExpressionValidator where

import AST
import GameStateMonad


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
