{-# LANGUAGE GADTs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module Stack where

class Stack m where
  push :: a -> m a -> m a
  pop :: m a -> m a
  peek :: m a -> Maybe a

instance Stack [] where
  push x xs = x:xs
  pop [] = []
  pop (_:xs) = xs
  peek [] = Nothing
  peek (x:_) = Just x
 