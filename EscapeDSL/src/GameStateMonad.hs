{-# LANGUAGE GADTs #-}
{-# LANGUAGE InstanceSigs #-}
module GameStateMonad where


import Control.Monad.State
import Control.Monad (ap)

import GameModel
import Control.Monad.Except (ExceptT)
import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Monad.Error.Class
import Stack
import GHC.IO.Handle
import GHC.IO.Handle.FD
import PrettyPrinter


-- 1. El Entorno de Lectura (Read-Only)
-- Contiene los "planos" del juego que no cambian.
data GameEnv = GameEnv {
    envGamma :: Gamma,          -- Tipos
    envObjects :: ObjectsMap    -- Definiciones (Elements, OnUse, Code)
}



-- La mónada GameState maneja el mapa de objetos (Gamma) y el estado de los objetos y navegación (Sigma)
newtype GameState a = GameState { runGameState :: StateT (GameEnv,Sigma) (ExceptT String IO) a }

instance Functor GameState where
  fmap f (GameState s) = GameState (fmap f s)
instance Applicative GameState where
  pure = GameState . pure
  (<*>) = ap
instance Monad GameState where
  return = pure
  (GameState s) >>= f = GameState (s >>= \a -> runGameState (f a))

class Monad m => GameStateError m where
  throwException :: String -> m ()

instance GameStateError GameState where
  throwException err = GameState (lift (throwError err))

-- La clase MonadGameIO maneja las operaciones de entrada/salida del juego
class MonadGameIO m where
  -- Toma un pretty printer de a, un elemento de tipo a y aplica el prettyprinter a ese elemento
  applyprettyprinter :: (a -> IO ()) -> a -> m ()
  -- Lee el comando de usuario
  readusercmd :: m String
  -- Muestra el juego raiz
  showrootgame :: m ()

instance MonadGameIO GameState where
  applyprettyprinter f x = GameState (lift (lift (f x)))
  readusercmd = do o <- objectNavigationTop
                   applyprettyprinter putStr o
                   applyprettyprinter putStr ">"
                   GameState (lift (lift (do hFlush stdout; getLine)))
  showrootgame =  do (GameEnv _ objectmap, (_, xs)) <- GameState get
                     case xs of
                        ["game"] -> case Map.lookup "game" objectmap of
                                             Nothing -> throwException "Game object not found"
                                             Just gamedata -> let mainobjects = elements gamedata
                                                              in applyprettyprinter ppElements mainobjects
                        (x:_)    -> applyprettyprinter ppCurrentObject x
                        _              -> throwException "Object stack is empty"



class Monad m => GameStateObjectsMonad m where
   insertnamewithtype :: ObjectName -> Type -> m ()
   insertobjectdata :: ObjectName -> ObjectData -> m ()
   checkistargetException :: ObjectName -> m ()
   checkistargetBool :: ObjectName -> m Bool
   checkisaelementofException :: ObjectName -> ObjectName -> m ()
   checkingammaException :: ObjectName -> m ()
   getelements :: ObjectName -> m Elements
   getobjectdata :: ObjectName -> m ObjectData
   getusecommands :: ObjectName -> m Sentences



instance GameStateObjectsMonad GameState where
  insertnamewithtype o t = do
                              (GameEnv gamma objectmap, (blockmap, objectstack)) <- GameState get
                              if t == TTarget then
                               GameState (put (GameEnv (Map.insert o t gamma) objectmap, (Map.insert o VLock blockmap, objectstack)))
                              else
                               GameState (put (GameEnv (Map.insert o t gamma) objectmap, (blockmap, objectstack)))
  insertobjectdata :: ObjectName -> ObjectData -> GameState ()
  insertobjectdata name odata = do
                              (GameEnv gamma objectmap, sigma) <- GameState get
                              GameState (put (GameEnv gamma (Map.insert name odata objectmap), sigma))
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
  getelements obj = do
          (GameEnv _ objectmap, _) <- GameState get
          case Map.lookup obj objectmap of
            Just itemdata -> return (elements itemdata)
            Nothing -> error ("Object " ++ obj ++ " not found")
  getobjectdata obj = do
          (GameEnv _ objectmap, _) <- GameState get
          case Map.lookup obj objectmap of
            Just itemdata -> return itemdata
            Nothing -> error ("Object " ++ obj ++ " not found")
  getusecommands obj = do
          (GameEnv _ objectmap, _) <- GameState get
          case Map.lookup obj objectmap of
            Just itemdata -> return (sentences itemdata)
            Nothing -> error ("Object " ++ obj ++ " not found")
class Monad m => GameStateNavigationStackMonad m where
 -- Obtiene el objeto en la cima de la pila de navegación
   objectNavigationTop :: m ObjectName
  -- Empuja un objeto a la pila de navegación
   objectNavigationPush :: ObjectName -> m ()
  -- Saca el objeto en la cima de la pila de navegación
   objectNavigationPop :: m ()
  -- Obtiene el estado de bloqueo de un objeto
   getLockStatus :: ObjectName -> m BlockData
  -- Desbloquea un objeto
   unlock :: ObjectName -> m ()
  -- Verifica si todos los objetos están desbloqueados
   allunlocked :: m Bool

instance GameStateNavigationStackMonad GameState where
   objectNavigationTop = do
          (_, (_, objectstack)) <- GameState get
          case peek objectstack of
            Nothing -> error "Object stack is empty"
            Just o -> return o
   objectNavigationPush o = do
          (env, (objectlockstate, objectstack)) <- GameState   get
          let newstack = push o objectstack
          GameState (put (env, (objectlockstate, newstack)))
   objectNavigationPop = do
          (env, (objectlockstate, objectstack)) <- GameState   get
          case objectstack of
            ["game"] -> do applyprettyprinter ppMessage "Reached the root"
                           showrootgame
            _              -> do let newstack = pop objectstack in
                                   GameState (put (env, (objectlockstate, newstack)))
                                 showrootgame
   getLockStatus :: ObjectName -> GameState BlockData
   getLockStatus o = do
          (_, (objectlockstate, _)) <- GameState   get
          case Map.lookup o objectlockstate of
            Nothing -> error ("Lock status for object " ++ o ++ " not found")
            Just status -> return status
   unlock o = do
          (env, (objectlockstate, objectstack)) <- GameState  get
          let newobjectlockstate = Map.insert o VUnlock objectlockstate
          GameState (put (env, (newobjectlockstate, objectstack)))
   allunlocked :: GameState Bool
   allunlocked = do
          (_, (objectlockstate, _)) <- GameState   get
          return (all (== VUnlock) (Map.elems objectlockstate))




buildObjectData :: [Declaration] -> (Int, Int, Int) -> GameState ObjectData
buildObjectData [] _ = return emptyObjectData
buildObjectData ((Unlock ncode) : xs) (e,s,n) = if n > 0 then error "Multiple declarations of unlock"
                                                else
                                                do
                                                  odata <- buildObjectData xs (e, s, n+1)
                                                  return (odata { code = Just ncode })
buildObjectData ((Elements objList) : xs) (e,s,n)  = if e > 0 then error "Multiple declarations of elements"
                                                     else
                                                     do
                                                      odata <- buildObjectData xs (e+1,s,n)
                                                      return (odata { elements = Set.fromList objList})
buildObjectData ((OnUse onUseCode) : xs) (e,s,n) = if s > 0 then error "Multiple declarations of onUSe"
                                                   else
                                                   do
                                                      odata <- buildObjectData xs (e,s+1,n)
                                                      return (odata { sentences = onUseCode })

buildEnvironment :: GameDefinition -> GameState ()
buildEnvironment [] = return ()
buildEnvironment ((Game objList) :xs) = do
                                            buildEnvironment (ObjectDef TItem "game" [Elements objList]: xs)
buildEnvironment ((ObjectDef typ name decls):xs) = do
                                                      odata <- buildObjectData decls (0,0,0)
                                                      insertnamewithtype name typ
                                                      insertobjectdata name odata
                                                      buildEnvironment xs




