{-# LANGUAGE GADTs #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE InstanceSigs #-}
module MonadGame where

import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Monad.State
import Control.Monad (ap)
import qualified Data.Bifunctor
import Stack
import EvalCommon
import Control.Monad.Except (ExceptT, throwError, runExceptT)
import GHC.IO.Handle
import System.IO


-- La mónada Sigma maneja el estado del juego (GameState) y errores en IO 
newtype Sigma a = Sigma { runSigma :: StateT GameState (ExceptT String IO) a }

instance Functor Sigma where
  fmap f (Sigma ma) = Sigma (fmap f ma)

instance Applicative Sigma where
  pure = Sigma . pure
  (<*>) = ap

instance Monad Sigma where
  return = pure
  (Sigma ma) >>= f = Sigma (ma >>= \a -> runSigma (f a))

-- La mónada Gamma maneja el entorno de objetos (Objects) y usa Sigma para el estado del juego y errores
newtype Gamma a = Gamma { runGamma :: StateT Objects Sigma a }

instance Functor Gamma where
  fmap f (Gamma ma) = Gamma (fmap f ma)
instance Applicative Gamma where
  pure = Gamma . pure
  (<*>) = ap
instance Monad Gamma where
  return = pure
  (Gamma ma) >>= f = Gamma (ma >>= \a -> runGamma (f a))

-- Además, definimos la clase MonadGame que encapsula las operaciones necesarias para evaluar y ejecutar el juego
class MonadGame m where
  -- Verifica que todos los elementos estén definidos en el entorno Gamma
  -- Lleva un acumulador de elementos no definidos
  checkdefinition :: ObjectName -> m ()
  -- Extrae el entorno actual Gamma
  getobjects :: m Objects
  -- Inserta un objeto común en el entorno Gamma
  putitem :: ObjectName -> ItemDefData -> Objects -> m ()
  -- Inserts a objetivo co
  puttarget :: ObjectName -> TargetDefData -> Objects -> m ()
  -- Throws an error with a message
  throwerror :: String -> m a
  -- Union de dos conjuntos de elementos, lanzando error si hay declaración duplicada
  unionelements :: Elements -> Elements -> m Elements
  -- Union de dos listas de sentencias, lanzando error si hay declaración duplicada
  unionsentences :: Sentences -> Sentences -> m Sentences
  -- Máximo de dos códigos de desbloqueo, lanzando error si hay declaración duplicada
  maxunlockcodes :: UnlockCode -> UnlockCode -> m UnlockCode
  -- Obtiene el elemento en la cima de la pila de navegación
  navigationtop :: m ObjectName
  -- Inserta un objeto en la pila de navegación
  navigationpush :: ObjectName -> m ()
  -- Elimina el elemento en la cima de la pila de navegación
  navigationpop :: m ()
  -- Obtiene el estado de bloqueo de un objeto
  getlockstatus :: ObjectName -> m BlockData
  -- Imprime un mensaje al usuario
  printmsg :: String -> m ()
  -- Lee un comando del usuario
  readusercmd :: m String
  -- Obtiene los elementos de un objeto
  getelements :: ObjectName -> m Elements
  -- Desbloquea un objeto
  unlock :: ObjectName -> m ()
  -- Obtiene las sentencias de uso de un objeto
  getusecommands :: ObjectName -> m Sentences
  -- Verifica si todos los objetos están desbloqueados
  allunlocked :: m Bool

showrootgame :: Gamma ()
showrootgame =  do (_, xs) <- Gamma (lift (Sigma get))
                   case xs of
                       Stack ["game"] -> do  i <- Gamma get
                                             case Map.lookup "game" (fst i) of
                                                 Nothing -> throwerror "Game object not found"
                                                 Just gamedata -> let mainobjects = ielements gamedata
                                                                  in printmsg ("Game elements: " ++ show mainobjects)
                                             return ()
                       Stack (x:_)   -> printmsg ("Current object: " ++ x)
                       _              -> throwerror "Object stack is empty"



instance MonadGame Gamma where
  checkdefinition element = do
          (itemsmap, targetsmap) <- Gamma get
          if Map.member element itemsmap || Map.member element targetsmap
            then return ()
            else throwerror ("Element " ++ element ++ " is not defined")
  getobjects = Gamma get
  getelements obj = do
          (itemsmap, targetsmap) <- Gamma get
          case Map.lookup obj itemsmap of
            Just itemdata -> return (ielements itemdata)
            Nothing -> case Map.lookup obj targetsmap of
                         Just targetdata -> return (telements targetdata)
                         Nothing -> throwerror ("Object " ++ obj ++ " not found")
  putitem o d g = Gamma (put (Data.Bifunctor.first (Map.insert o (ItemDefData e s)) g))
    where
      e = ielements d
      s = isentences d
  puttarget o d g = Gamma (put (Data.Bifunctor.second (Map.insert o (TargetDefData e s c)) g))
    where
      e = telements d
      s = tsentences d
      c = code d
  throwerror msg = Gamma (lift (Sigma (lift (throwError msg))))
  unionelements e1 e2
    | e1 == Set.empty = return e2
    | e2 == Set.empty = return e1
    | otherwise = throwerror "Duplicate elements declaration"
  unionsentences s1 s2
    | null s1 = return s2
    | null s2 = return s1
    | otherwise = throwerror "Duplicate onuse declaration"
  maxunlockcodes k1 k2
    | k1 == 0 = return k2
    | k2 == 0 = return k1
    | otherwise = throwerror "Multiple Unlock declarations"
  navigationtop = do
          (_, objectstack) <- Gamma (lift (Sigma get))
          case peek objectstack of
            Nothing -> throwerror "Object stack is empty"
            Just o -> return o
  navigationpush o = do
          (blockmap, objectstack) <- Gamma (lift (Sigma get))
          let newstack = push o objectstack
          Gamma (lift (Sigma (put (blockmap, newstack))))
  navigationpop = do
          (blockmap, objectstack) <- Gamma (lift (Sigma get))
          case objectstack of
            Stack ["game"] -> do printmsg "Reached the root"
                                 showrootgame
            _              -> do let newstack = pop objectstack in
                                  Gamma (lift (Sigma (put (blockmap, newstack))))
                                 showrootgame
  getlockstatus o = do
          (blockmap, _) <- Gamma (lift (Sigma get))
          case Map.lookup o blockmap of
            Nothing -> throwerror ("Lock status for object " ++ o ++ " not found")
            Just status -> return status
  printmsg msg = Gamma (lift (Sigma (lift (lift (putStrLn msg)))))
  readusercmd = do Gamma (lift (Sigma (lift (lift (putStr ">")))))
                   Gamma (lift (Sigma (lift (lift (do hFlush stdout; getLine)))))
  unlock o = do
          (blockmap, objectstack) <- Gamma (lift (Sigma get))
          let newblockmap = Map.insert o VUnlock blockmap
          Gamma (lift (Sigma (put (newblockmap, objectstack))))
  getusecommands o = do
          (itemsmap, targetsmap) <- Gamma get
          case Map.lookup o itemsmap of
            Just itemdata -> return (isentences itemdata)
            Nothing -> case Map.lookup o targetsmap of
                         Just targetdata -> return (tsentences targetdata)
                         Nothing -> throwerror ("Object " ++ o ++ " not found")
  allunlocked = do
          (blockmap, _) <- Gamma (lift (Sigma get))
          return (all (== VUnlock) (Map.elems blockmap))