{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs #-}
module AST where

-- Identificadores de Variable
type ObjectName = String
type Message = String
type UnlockCode = Int
-- Los tipos. Pueden ser Message (String), Natural o de un tipo específicado en el DSL (String)
data Type = TTarget | TObject
  deriving (Show, Eq)

data ShowMode = ShowMessage Message | ShowObject ObjectName
  deriving (Show, Eq)
-- Comandos (sentencias)
data Sentence
  = Command Command
  | IfCommand Status Command 
  deriving (Show, Eq)

newtype Command = Show ShowMode
  deriving (Show, Eq)

-- El tipo de un game definition
-- Una lista de definiciones
type GameDefinition = [Definition]

-- El tipo de lass definiciones
data Definition = Game [ObjectName]
                | ObjectDef Type ObjectName [Declaration]
  deriving (Show, Eq)

-- Las declaraciones dentro de una clase
-- Puede contener Unlock, Elements, Init, Actions 
data Declaration = Unlock Int
                 | Elements [ObjectName]
                 | OnUse [Sentence]
  deriving (Show, Eq)                   
           

data Status = Locked | Unlocked | ObjectLocked ObjectName | ObjectUnlocked ObjectName | And Status Status | Or Status Status
  deriving (Show, Eq)