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
conversion' (LLet v t1 t) xs i = let arg = conversion' t1 xs i in
                                 case infer [] arg of
                                   Right typ -> let f = LAbs v typ t
                                                in conversion' (LApp f t1) xs i
                                   Left err -> error err
conversion' LZero xs i        = Zero
conversion' (LSuc term) xs i  = Suc (conversion' term xs i)
conversion' (LRec term1 term2 term3) xs i = Rec (conversion' term1 xs i) (conversion' term2 xs i) (conversion' term3 xs i)
conversion' (LNil) xs i         = Nil
conversion' (LCons term1 term2) xs i = Cons (conversion' term1 xs i) (conversion' term2 xs i)
conversion' (LRecList term1 term2 term3) xs i = RecList (conversion' term1 xs i) (conversion' term2 xs i) (conversion' term3 xs i)
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
sub i t (Let t'   u)          = case infer [] t' of
                                  Right typ -> sub i t (Lam typ u :@: t')
                                  Left err -> error err
sub i t Zero                  = Zero
sub i t (Suc term)            = Suc (sub i t term)
sub i t (Rec t1 t2 t3)        = Rec (sub i t t1) (sub i t t2) (sub i t t3)
sub i t Nil                   = Nil
sub i t (Cons t1 t2)          = Cons (sub i t t1) (sub i t t2)
sub i t (RecList t1 t2 t3)    = RecList (sub i t t1) (sub i t t2) (sub i t t3)

-- convierte un valor en el término equivalente
quote :: Value -> Term
quote (VLam t f) = Lam t f
quote (VNum NZero) = Zero
quote (VNum (NSuc v)) = Suc (quote (VNum v))
quote (VList VNil) = Nil
quote (VList (VCons n l)) = Cons (quote (VNum n)) (quote (VList l))


-- evalúa un término en un entorno dado
eval :: NameEnv Value Type -> Term -> Value
eval xs (t1 :@: t2) =
        let v1 = eval xs t1
        in
            case v1 of
              VLam _ body -> eval xs (sub 0 t2 body)
              x           -> error "Error de evaluación: se intentó aplicar un valor que no es una función."
eval xs (Lam t body) = VLam t body -- Se empaqueta como valor, NO se evalúa el cuerpo.
-- Caso 3: Variable Libre (Global)
eval xs (Free n) =
    case lookup n xs of
        Just (v, _) -> v
        Nothing     -> error ("Error de evaluación: variable no definida: " ++ show n)
-- Caso 4: Variable Ligada (Bound)
eval xs (Bound i) =
    error ("Error de evaluación: se encontró una variable ligada (Bound " ++ show i ++ ") fuera de su alcance. Esto no debería ocurrir en un término cerrado.")
eval xs (Let t tv) = eval xs (sub 0 tv t)
eval xs Zero       = VNum NZero
eval xs (Suc t)    = let v = eval xs t in
                     case v of
                        VNum nv -> VNum (NSuc nv)
                        _       -> error "No es un número"
eval xs (Rec t1 t2 t3) =
    let v3 = eval xs t3 -- Evalúa el número (call-by-value)
    in
    case v3 of
        VNum NZero -> eval xs t1 -- Caso base
        VNum (NSuc n_val) -> -- n_val es el NumVal anterior
            let
                t_n = quote (VNum n_val)     -- El término para n
                t_rec_n = Rec t1 t2 t_n      -- El término para (R t1 t2 n)
            in
                -- Aplicamos la regla: t2 (R t1 t2 n) n
                eval xs (t2 :@: t_rec_n :@: t_n)
        _ -> error "Rec aplicado a un valor que no es un número"
eval xs Nil        = VList VNil
eval xs (Cons t ts) = let vs = eval xs ts
                          v  = eval xs t
                      in
                      case vs of
                         VList l -> case v of
                                      VNum n -> VList (VCons n l)
                                      _      -> error "Se esperaba un número"
                         _       -> error "No es una lista"
eval xs (RecList t1 t2 t3) =
    let v3 = eval xs t3 -- Evalúa la lista (call-by-value)
    in
    case v3 of
        VList VNil -> eval xs t1 -- Caso base
        VList (VCons n_val l_val) ->
            let
                t_l = quote (VList l_val)     -- El término para l
                t_rec_l = RecList t1 t2 t_l   -- El término para (RList t1 t2 l)
                t_n = quote (VNum n_val)      -- El término para n
            in
                -- Aplicamos la regla: t2 n (RList t1 t2 l)  l
                eval xs (t2 :@: t_n :@: t_l :@: t_rec_l)
        _ -> error "RecList aplicado a un valor que no es una lista"

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
infer' c e (Let t u) = case infer [] t of
                          Right typ -> infer' c e (Lam typ u :@: t)
                          Left err -> error err
infer' c e Zero      = ret NatT
infer' c e (Suc t)   = case infer' c e t of
                          Right typ  -> if typ == NatT then ret typ else matchError typ NatT
                          Left  err  -> error err
infer' c e (Rec t1 t2 t3) = do ty_t3 <- infer' c e t3
                               if ty_t3 /= NatT then matchError NatT ty_t3 else
                                do ty_t1 <- infer' c e t1
                                   ty_t2 <- infer' c e t2
                                   let expected_ty_t2 = FunT ty_t1 (FunT NatT ty_t1) in
                                    if ty_t2 == expected_ty_t2 then ret ty_t1 else matchError expected_ty_t2 ty_t2
infer' c e Nil = ret ListT
infer' c e (Cons t ts) = do ty_t <- infer' c e t
                            if ty_t /= NatT then matchError NatT ty_t else
                             do ty_ts <- infer' c e ts
                                if ty_ts /= ListT then matchError ListT ty_ts else ret ListT
infer' c e (RecList t1 t2 t3) = do ty_t3 <- infer' c e t3
                                   if ty_t3 /= ListT then matchError ListT ty_t3 else
                                    do ty_t1 <- infer' c e t1
                                       ty_t2 <- infer' c e t2
                                       let expected_ty_t2 = FunT NatT (FunT ListT (FunT ty_t1 ty_t1)) in
                                        if ty_t2 == expected_ty_t2 then ret ty_t1 else matchError expected_ty_t2 ty_t2


