{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs #-}
module Eval where

import AST
import Data.Maybe (fromMaybe)
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
  mget :: m Gamma
  mput :: Gamma -> m ()

instance MonadM M where
  mget = M get
  mput g = M (put g)

emptyGamma :: Gamma
emptyGamma = (Map.empty, Map.empty)

evalE :: [ObjectName] -> M Elements
evalE [] = return Set.empty
evalE (o:os) = do es <- evalE os
                  return (Set.insert o es)

evalO :: [Declaration] -> M (Elements, Sentences)
evalO [] = return (Set.empty, [])
evalO ((Unlock n):os) = M (lift (Left "Unlock declaration not allowed here"))
evalO ((Elements e):os) = do (e1, s1) <- evalO os
                             es <- evalE e
                             return (Set.union es e1, s1)
evalO ((OnUse s):os) = do (e1, s1) <- evalO os
                          return (e1, s1++s)

evalT :: [Declaration] -> M (Elements, Sentences, UnlockCode)
evalT [] = return (Set.empty, [], 0)
evalT ((Unlock n):os) = do (e1, s1, k) <- evalT os
                           if k == 0 then return (e1, s1, n)
                                     else M (lift (Left "Multiple Unlock declarations"))
evalT ((Elements e):os) = do (e1, s1, k) <- evalT os
                             es <- evalE e
                             return (Set.union es e1, s1, k)
evalT ((OnUse s):os) = do (e1, s1, k) <- evalT os
                          return (e1, s1++s, k)

eval :: GameDefinition -> M Gamma
eval [] = return emptyGamma
eval ((Game objs):defs) = do (e, s) <- evalO [Elements objs]
                             st <- mget
                             mput (Data.Bifunctor.first (Map.insert "game" (ObjectDefData e s)) st)
                             eval defs
eval ((ObjectDef TObject name decls):defs) = do (e, s) <- evalO decls
                                                st <- mget
                                                mput (Data.Bifunctor.first (Map.insert name (ObjectDefData e s)) st)
                                                eval defs
eval ((ObjectDef TTarget name decls):defs) = do (e, s, k) <- evalT decls
                                                st <- mget
                                                mput (Data.Bifunctor.second (Map.insert name (TargetDefData e s k)) st)
                                                eval defs


