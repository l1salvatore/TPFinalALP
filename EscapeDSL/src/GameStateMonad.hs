{-# LANGUAGE GADTs #-}
module GameMonads where

import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Monad.State
import Control.Monad (ap)
import qualified Data.Bifunctor
import Stack
import EvalModel
import Control.Monad.Except (ExceptT, throwError)
import GHC.IO.Handle
import System.IO
import PrettyPrinter

-- La mónada GameState maneja el mapa de objetos (Gamma) y el estado de los objetos y navegación (Sigma)
newtype GameState a = GameState { runGameState :: StateT Sigma (ExceptT String IO) a }

instance Functor GameState where
  fmap f (GameState s) = GameState (fmap f s)
instance Applicative GameState where
  pure = GameState . pure
  (<*>) = ap
instance Monad GameState where
  return = pure
  (GameState s) >>= f = GameState (s >>= \a -> runGameState (f a))
  
-- La clase MonadError maneja errores en la mónada
class MonadError m where
  throwException :: String -> m a

-- La clase MonadGameIO maneja las operaciones de entrada/salida del juego
class MonadGameIO m where
  -- Toma un pretty printer de a, un elemento de tipo a y aplica el prettyprinter a ese elemento
  applyprettyprinter :: (a -> IO ()) -> a -> m ()
  -- Lee el comando de usuario
  readusercmd :: m String
  -- Muestra el juego raiz
  showrootgame :: m ()

-- Definimos la clase MonadGameState que maneja las operaciones necesarias para el estado del juego
class MonadGameState m where
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



instance MonadError GameState where
  throwException msg = GameState (lift (lift (throwError msg)))


instance MonadGameIO GameState where
  applyprettyprinter f x = GameState (lift (lift (lift (f x))))
  readusercmd = do o <- objectNavigationTop
                   applyprettyprinter putStr o
                   applyprettyprinter putStr ">" 
                   GameState (lift (lift (lift (do hFlush stdout; getLine))))
  showrootgame =  do (_, xs) <- GameState (lift get)
                     case xs of
                        ["game"] -> do  i <- GameState get
                                        case Map.lookup "game" (fst i) of
                                             Nothing -> throwException "Game object not found"
                                             Just gamedata -> let mainobjects = ielements gamedata
                                                              in applyprettyprinter ppElements mainobjects 
                                        return ()
                        (x:_)    -> applyprettyprinter ppCurrentObject x
                        _              -> throwException "Object stack is empty"




instance MonadGameState GameState where
  objectNavigationTop = do
          (_, objectstack) <- GameState (lift get)
          case peek objectstack of
            Nothing -> throwException "Object stack is empty"
            Just o -> return o
  objectNavigationPush o = do
          (blockmap, objectstack) <- GameState (lift  get)
          let newstack = push o objectstack
          GameState (lift  (put (blockmap, newstack)))
  objectNavigationPop = do
          (blockmap, objectstack) <- GameState (lift  get)
          case objectstack of
            ["game"] -> do applyprettyprinter ppMessage "Reached the root"
                           showrootgame
            _              -> do let newstack = pop objectstack in
                                   GameState (lift  (put (blockmap, newstack)))
                                 showrootgame
  getLockStatus o = do
          (blockmap, _) <- GameState (lift  get)
          case Map.lookup o blockmap of
            Nothing -> throwException ("Lock status for object " ++ o ++ " not found")
            Just status -> return status
  unlock o = do
          (blockmap, objectstack) <- GameState (lift  get)
          let newblockmap = Map.insert o VUnlock blockmap
          GameState (lift  (put (newblockmap, objectstack)))
  allunlocked = do
          (blockmap, _) <- GameState (lift  get)
          return (all (== VUnlock) (Map.elems blockmap))




instance MonadObjectMap GameState where
  checkdefinition element = do
          (itemsmap, targetsmap) <- GameState get
          if Map.member element itemsmap || Map.member element targetsmap
            then return ()
            else throwException ("Element " ++ element ++ " is not defined")
  getobjects = GameState get
  getelements obj = do
          (itemsmap, targetsmap) <- GameState get
          case Map.lookup obj itemsmap of
            Just itemdata -> return (ielements itemdata)
            Nothing -> case Map.lookup obj targetsmap of
                         Just targetdata -> return (telements targetdata)
                         Nothing -> throwException ("Object " ++ obj ++ " not found")
  putitem o d g = GameState (put (Data.Bifunctor.first (Map.insert o (ItemDefData e s)) g))
    where
      e = ielements d
      s = isentences d
  puttarget o d g = GameState (put (Data.Bifunctor.second (Map.insert o (TargetDefData e s c)) g))
    where
      e = telements d
      s = tsentences d
      c = code d
  checkistarget o = do (_, targetsmap) <- getobjects
                       case Map.lookup o targetsmap of
                                 Nothing -> throwException ("Object " ++ o ++ " not target for this conditions")
                                 Just _ -> return ()
  unionelements e1 e2
    | e1 == Set.empty = return e2
    | e2 == Set.empty = return e1
    | otherwise = throwException "Duplicate elements declaration"
  unionsentences s1 s2
    | null s1 = return s2
    | null s2 = return s1
    | otherwise = throwException "Duplicate onuse declaration"
  maxunlockcodes k1 k2
    | k1 == 0 = return k2
    | k2 == 0 = return k1
    | otherwise = throwException "Multiple Unlock declarations"
  getusecommands o = do
          (itemsmap, targetsmap) <- GameState get
          case Map.lookup o itemsmap of
            Just itemdata -> return (isentences itemdata)
            Nothing -> case Map.lookup o targetsmap of
                         Just targetdata -> return (tsentences targetdata)
                         Nothing -> throwException ("Object " ++ o ++ " not found")
