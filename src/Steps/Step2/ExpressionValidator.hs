{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Steps.Step2.ExpressionValidator where

import AST
import GameStateMonad
import GameModel
import Control.Monad.State ()

-- El punto 2. Validación de las expresiones. Contiene diferentes checkers
class Monad m => GameStateValidation m where
   -- Se revisa si el objeto en cuestión es un objetivo. Si no lo es, falla
   checkistargetException :: ObjectName -> m ()
   -- Se revisa si el objeto en cuestión es un objetivo. Si no lo es, retorna Falso
   checkistargetBool :: ObjectName -> m Bool
   -- Se revisa si dado un objeto e y un objeto O, el objeto e es un elemento de O. Si no lo es, falla
   checkisaelementofException :: ObjectName -> ObjectName -> m ()
   -- Se chequea que el objeto exista dentro del entorno. Si no lo está, falla
   checkObjectExist :: ObjectName -> m ()

-- Implementación con la mónada GameState
instance GameStateValidation GameState where
  checkistargetBool objname = do
                            gameenvironment <- getObjectEnvironment -- Extraigo el entorno de objetos de la mónada
                            odata' <- getObjectData objname gameenvironment -- Extraigo la data del objeto
                            case odata' of  -- Analizo por casos
                              -- No existe la data, es decir, el objeto no existe
                              Nothing -> do throwException (objname ++ " object not found") -- Lanzo el error 'El objeto no existe'
                                            return False -- Retorno Falso
                              -- Existe la data, chequeo si el tipo del objeto objname es Target
                              Just odata -> if objecttype odata == TTarget then return True else return False
  checkistargetException objname = do
                            gameenvironment <- getObjectEnvironment -- Extraigo el entorno de objetos de la mónada
                            odata' <- getObjectData objname gameenvironment -- Extraigo la data del objeto
                            case odata' of -- Analizo por casos
                              -- No existe la data, es decir, el objeto no existe
                              Nothing -> throwException (objname ++ " object not found")  -- Lanzo el error 'El objeto no existe'
                               -- Existe la data, chequeo si el tipo del objeto objname es Target
                               -- A diferencia de la función anterior, en este caso en lugar de retornar un Bool lanzo una exception o retorno ()
                              Just odata -> if objecttype odata == TTarget then return () else throwException (objname ++ " is not a target")
  checkisaelementofException elementname objectname = do
                                        gameenvironment <- getObjectEnvironment -- Extraigo el entorno de objetos de la mónada
                                        odata' <- getObjectData objectname gameenvironment -- Extraigo la data del objeto
                                        case odata' of -- Analizo por casos
                                          -- No existe la data, es decir, el objeto no existe
                                          Nothing -> throwException (objectname ++ " object not found")
                                          -- Existe la data, chequeo si el elemento es parte de los elementos del objeto
                                          Just odata -> do check <- isMemberOf elementname (elements odata)
                                                           if check then return () -- Si está, retorno ()
                                                           else throwException (elementname ++ " is not an element of "++ objectname) -- Caso contrario, lanzo una exception
  checkObjectExist objectname = do
                          gameenvironment <- getObjectEnvironment -- Extraigo el entorno de objetos de la mónada
                          odata' <- getObjectData objectname gameenvironment -- Extraigo la data del objeto
                          case odata' of -- Analizo por casos
                            -- No existe la data, es decir, el objeto no existe
                            Nothing -> throwException (objectname ++ " object not found")
                            -- Existe la data, existe el objeto. Retorno ()
                            Just _ -> return ()


-- Validación del GameDefinition
validateGameDefinition :: GameDefinition ->  ObjectName -> GameState ()
validateGameDefinition [] _ = return () -- Retorno () si la lista es vacía
validateGameDefinition (Game elems : rest) currentobject = do
                                                                    validateElements elems  currentobject -- Valido los elementos (verifica que existan)
                                                                    validateGameDefinition rest  currentobject -- Valido recursivamente el resto de definiciones

validateGameDefinition (ObjectDef _ objname decls : rest)  currentobject = do 
                                                                            validateDeclarations decls  objname -- Valido todas las declaraciones del objeto actual
                                                                            validateGameDefinition rest  currentobject -- Valido recursivamente el resto de definiciones

-- Validación de las Declarations
validateDeclarations :: [Declaration] ->  ObjectName -> GameState ()
validateDeclarations [] _ = return () -- Retorno () si la lista es vacía
validateDeclarations (Unlock _ : rest) currentobject = do -- Viene un unlock en la lista de declaraciones
                                                               checkistargetException currentobject -- Verificar que currentobject es un target (solo targets pueden desbloquearse)
                                                               validateDeclarations rest  currentobject -- Validar recursivamente el resto de declaraciones
validateDeclarations (Elements elems : rest) currentobject = do -- Viene una declaración de elementos en la lista
                                                                     validateElements elems  currentobject -- Verificar que todos los elementos existen
                                                                     validateDeclarations rest  currentobject -- Validar recursivamente el resto de declaraciones
validateDeclarations (OnUse sentences : rest) currentobject = do -- Viene una declaración de sentencias en la lista
                                                                      validateSentences sentences currentobject -- Chequeo las sentencias
                                                                      validateDeclarations rest currentobject -- valido el resto de las declaraciones

-- Validación de las Sentences
validateSentences :: [Sentence] ->  ObjectName -> GameState ()
validateSentences [] _ = return ()
validateSentences (Command command : rest) currentobject = do
                                                                   validateCommand command  currentobject -- Validar el comando actual
                                                                   validateSentences rest  currentobject -- Validar recursivamente el resto de sentencias
validateSentences (IfCommand conditions command : rest)  currentobject = do
                                                                                validateConditions conditions currentobject -- Validar que las condiciones sean correctas
                                                                                validateCommand command currentobject -- Validar el comando condicional
                                                                                validateSentences rest currentobject -- Validar recursivamente el resto de sentencias

-- Validación de los Commands
validateCommand :: Command ->  ObjectName -> GameState ()
validateCommand (Show (ShowObject x)) currentobject =  do
                                                               checkObjectExist x -- Verificar que el objeto a mostrar existe
                                                               checkObjectExist currentobject -- Verificar que el objeto actual existe
                                                               checkisaelementofException x currentobject -- Verificar que x es un elemento de currentobject
validateCommand (Show (ShowMessage _)) _ = return ()

-- Validación de las Condiciones
validateConditions :: Conditions ->  ObjectName -> GameState ()
validateConditions Locked currentobject = checkistargetException currentobject
validateConditions Unlocked currentobject = checkistargetException currentobject
validateConditions (ObjectLocked o) currentobject = do
                                                            checkisaelementofException o currentobject -- Verificar que o es un elemento de currentobject
                                                            checkistargetException o -- Verificar que o es un target (solo targets pueden estar bloqueados)
validateConditions (ObjectUnlocked o) currentobject = do
                                                              checkisaelementofException o currentobject -- Verificar que o es un elemento de currentobject
                                                              checkistargetException o -- Verificar que o es un target (solo targets pueden estar desbloqueados)
validateConditions (And c1 c2)  currentobject = do
                                                       validateConditions c1 currentobject -- Validar primera condición
                                                       validateConditions c2 currentobject -- Validar segunda condición
validateConditions (Or c1 c2)  currentobject = do
                                                      validateConditions c1 currentobject -- Validar primera condición
                                                      validateConditions c2 currentobject -- Validar segunda condición



-- Validación de los elements
validateElements :: [ObjectName] ->  ObjectName -> GameState ()
validateElements [] _ = return ()
validateElements (objname : xs)  currentobject = do
                                                    checkObjectExist objname -- Verificar que el elemento actual existe
                                                    validateElements xs currentobject -- Validar recursivamente el resto de elementos
