{-# LANGUAGE GADTs #-}
module EnvironmentEval where

import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Monad.State
import Control.Monad (ap)
import qualified Data.Bifunctor

type ObjectsMap = Map.Map ObjectName ObjectDefData
data ObjectDefData = ObjectDefData
  { oelements :: Set.Set ObjectName,
    osentences :: [Sentence]
  } deriving (Show, Eq)

type TargetsMap = Map.Map ObjectName TargetDefData
data TargetDefData = TargetDefData
  { telements :: Set.Set ObjectName,
    tsentences :: [Sentence],
    code :: UnlockCode
  } deriving (Show, Eq)

type Elements = Set.Set ObjectName
type Sentences = [Sentence]

type Gamma = (ObjectsMap, TargetsMap)
newtype M a = M { runM :: StateT Gamma (Either String) a }

instance Functor M where
  fmap f (M ma) = M (fmap f ma)
instance Applicative M where
  pure = M . pure
  (<*>) = ap

instance Monad M where
  return = M . return
  (M ma) >>= f = M (ma >>= \a -> runM (f a))

class MonadM m where
  -- Extrae el entorno actual Gamma
  getstate :: m Gamma
  -- Inserta un objeto común en el entorno Gamma
  putobject :: ObjectName -> Elements -> Sentences -> Gamma -> m ()
  -- Inserts a objetivo co
  puttarget :: ObjectName -> Elements -> Sentences -> UnlockCode -> Gamma -> m ()
  -- Throws an error with a message
  throwerror :: String -> m a
  -- Union de dos conjuntos de elementos, lanzando error si hay declaración duplicada
  unionobjects :: Elements -> Elements -> m Elements
  -- Union de dos listas de sentencias, lanzando error si hay declaración duplicada
  unionsentences :: Sentences -> Sentences -> m Sentences
  -- Máximo de dos códigos de desbloqueo, lanzando error si hay declaración duplicada
  maxunlockcodes :: UnlockCode -> UnlockCode -> m UnlockCode

instance MonadM M where
  getstate = M get
  putobject o e s g = M (put (Data.Bifunctor.first (Map.insert o (ObjectDefData e s)) g))
  puttarget o e s k g = M (put (Data.Bifunctor.second (Map.insert o (TargetDefData e s k)) g))
  throwerror msg = M (lift (Left msg))
  unionobjects e1 e2
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

emptyGamma :: Gamma
emptyGamma = (Map.empty, Map.empty)

evalE :: [ObjectName] -> M Elements
evalE [] = return Set.empty
evalE (o:os) = do es <- evalE os
                  return (Set.insert o es)

evalO :: [Declaration] -> M (Elements, Sentences)
evalO [] = return (Set.empty, [])
evalO ((Unlock _):_) = throwerror "Unlock declaration not allowed here"
evalO ((Elements e):os) = do (resto, sentences) <- evalO os
                             k <- evalE e
                             elements <- unionobjects k resto
                             return (elements, sentences)
evalO ((OnUse s):os) = do (elements, resto) <- evalO os
                          sentences <- unionsentences s resto
                          return (elements, sentences)

evalT :: [Declaration] -> M (Elements, Sentences, UnlockCode)
evalT [] = return (Set.empty, [], 0)
evalT ((Unlock n):os) = do (elements, sentences, resto) <- evalT os
                           unlockcode <- maxunlockcodes n resto
                           return (elements, sentences, unlockcode)
evalT ((Elements e):os) = do (resto, sentences, unlockcode) <- evalT os
                             k <- evalE e
                             elements <- unionobjects k resto
                             return (elements, sentences, unlockcode)
evalT ((OnUse s):os) = do (elements, resto, unlockcode) <- evalT os
                          sentences <- unionsentences s resto
                          return (elements, sentences, unlockcode)

eval :: GameDefinition -> M Gamma
eval [] = return emptyGamma
eval ((Game objs):defs) = do (elements, sentences) <- evalO [Elements objs]
                             oldstate <- getstate
                             putobject "game" elements sentences oldstate
                             eval defs
eval ((ObjectDef TObject name decls):defs) = do (elements, sentences) <- evalO decls
                                                oldstate <- getstate
                                                putobject name elements sentences oldstate
                                                eval defs
eval ((ObjectDef TTarget name decls):defs) = do (elements, sentences, unlockcode) <- evalT decls
                                                oldstate <- getstate
                                                puttarget name elements sentences unlockcode oldstate
                                                eval defs


