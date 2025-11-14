{-# LANGUAGE GADTs #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE InstanceSigs #-}
module Stack where

import Control.Monad (ap)


-- Definición de una estructura llamada pila
newtype Stack a = Stack [a]
  deriving (Show)
emptyStack :: Stack a
emptyStack = Stack []
instance Functor Stack where
  fmap f (Stack xs) = Stack (map f xs)

instance Applicative Stack where
  pure x = Stack [x]
  (<*>) = ap

instance Monad Stack where
  return = pure
  Stack [] >>= _ = Stack []
  Stack (x:xs) >>= f = let Stack ys = f x
                           Stack zs = Stack xs >>= f
                       in Stack (ys ++ zs)

class MonadStack m where
  push :: a -> m a -> m a
  pop :: m a -> m a
  peek :: m a -> Maybe a

instance MonadStack Stack where
  push x (Stack xs) = Stack (x:xs)
  pop (Stack []) = Stack []
  pop (Stack (_:xs)) = Stack xs
  peek (Stack []) = Nothing
  peek (Stack (x:_)) = Just x
 