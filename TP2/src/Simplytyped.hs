module Simplytyped
  ( conversion
  ,    -- conversion a terminos localmente sin nombre
    eval
  ,          -- evaluador
    infer
  ,         -- inferidor de tipos
    quote          -- valores -> terminos
  )
where

import           Data.List
import           Data.Maybe
import           Prelude                 hiding ( (>>=) )
import           Text.PrettyPrint.HughesPJ      ( render )
import           PrettyPrinter
import           Common

-----------------------
-- conversion
-----------------------

-- conversion a términos localmente sin nombres
conversion :: LamTerm -> Term
conversion l = conversion' l [] 0

conversion' :: LamTerm -> [String] -> Int -> Term
conversion' (LVar name) [] i = Free (Global name)
conversion' (LVar name) (x:xs) i = if x == name then Bound i
                                 else conversion' (LVar name) xs (i+1)
conversion' (LAbs name t term) xs i = Lam t (conversion' term (name:xs) i)
conversion' (LApp term1 term2) xs i = conversion' term1 xs i :@: conversion' term2 xs i


----------------------------
--- evaluador de términos
----------------------------

-- substituye una variable por un término en otro término
sub :: Int -> Term -> Term -> Term
sub i t (Bound j) | i == j    = t
sub _ _ (Bound j) | otherwise = Bound j
sub _ _ (Free n   )           = Free n
sub i t (u   :@: v)           = sub i t u :@: sub i t v
sub i t (Lam t'  u)           = Lam t' (sub (i + 1) t u)

-- convierte un valor en el término equivalente
quote :: Value -> Term
quote (VLam t f) = Lam t f

-- evalúa un término en un entorno dado
eval :: NameEnv Value Type -> Term -> Value
eval xs (t1 :@: t2) =
        let v1 = eval xs t1
            v2 = eval xs t2
        in
            case v1 of
              VLam _ body -> eval xs (sub 0 (quote v2) body)
              _           -> error "Error de evaluación: se intentó aplicar un valor que no es una función."
eval xs (Lam t body) = VLam t body -- Se empaqueta como valor, NO se evalúa el cuerpo.
-- Caso 3: Variable Libre (Global)
eval xs (Free n) =
    case lookup n xs of
        Just (v, _) -> v
        Nothing     -> error ("Error de evaluación: variable libre no ligada: " ++ show n)

-- Caso 4: Variable Ligada (Bound)
eval xs (Bound i) =
    error ("Error de evaluación: se encontró una variable ligada (Bound " ++ show i ++ ") fuera de su alcance. Esto no debería ocurrir en un término cerrado.")
eval xs (Let t tv) = undefined
eval xs Zero       = VNum NZero
eval xs (Suc t)    = let v = eval xs t in
                     case v of
                        VNum nv -> VNum (NSuc nv)
                        _       -> error "No es un número"
eval xs (Rec t1 t2 t3) = undefined
eval xs Nil        = VList VNil
eval xs (Cons t ts) = let vs = eval xs ts 
                          v  = eval xs t
                      in
                      case vs of 
                         VList l -> case v of 
                                      VNum n -> VList (VCons n l)
                                      _      -> error "Se esperaba un número"
                         _       -> error "No es una lista"


----------------------
--- type checker
-----------------------

-- infiere el tipo de un término
infer :: NameEnv Value Type -> Term -> Either String Type
infer = infer' []

-- definiciones auxiliares
ret :: Type -> Either String Type
ret = Right

err :: String -> Either String Type
err = Left

(>>=)
  :: Either String Type -> (Type -> Either String Type) -> Either String Type
(>>=) v f = either Left f v
-- fcs. de error

matchError :: Type -> Type -> Either String Type
matchError t1 t2 =
  err
    $  "se esperaba "
    ++ render (printType t1)
    ++ ", pero "
    ++ render (printType t2)
    ++ " fue inferido."

notfunError :: Type -> Either String Type
notfunError t1 = err $ render (printType t1) ++ " no puede ser aplicado."

notfoundError :: Name -> Either String Type
notfoundError n = err $ show n ++ " no está definida."

-- infiere el tipo de un término a partir de un entorno local de variables y un entorno global
infer' :: Context -> NameEnv Value Type -> Term -> Either String Type
infer' c _ (Bound i) = ret (c !! i)
infer' _ e (Free  n) = case lookup n e of
  Nothing     -> notfoundError n
  Just (_, t) -> ret t
infer' c e (t :@: u) = infer' c e t >>= \tt -> infer' c e u >>= \tu ->
  case tt of
    FunT t1 t2 -> if (tu == t1) then ret t2 else matchError t1 tu
    _          -> notfunError tt
infer' c e (Lam t u) = infer' (t : c) e u >>= \tu -> ret $ FunT t tu


