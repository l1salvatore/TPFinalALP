{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs #-}
module AST where

-- Nombres de objetos
type ObjectName = String
-- Mensajes
type Message = String
-- Códigos de desbloqueo
type UnlockCode = Int

-- Los tipos de objetos pueden ser Target u Objetos normales
data Type = TTarget | TItem
  deriving (Show, Eq)

-- Modos de mostrar: Mostrar un mensaje o mostrar un objeto
data ShowMode = ShowMessage Message | ShowObject ObjectName
  deriving (Show, Eq)


-- Las sentencias posibles en el juego
-- Pueden ser comandos o comandos condicionales
data Sentence
  = Command Command
  | IfCommand Conditions Command 
  deriving (Show, Eq)

-- Los comandos posibles
-- TODO: Agregar más comandos si es necesario, como por ejemplo, asignaciones o modificaciones de estado
newtype Command = Show ShowMode
  deriving (Show, Eq)

-- El tipo de un game definition
-- Una lista de definiciones
type GameDefinition = [Definition]

-- Las sentencias es una lista de sentencias
type Sentences = [Sentence]

-- Definiciones: Un juego con una lista de objetos o la definición de un objeto con su tipo, nombre y declaraciones
data Definition = Game [ObjectName]
                | ObjectDef Type ObjectName [Declaration]
  deriving (Show, Eq)

-- Las declaraciones dentro de una clase
-- Puede ser un desbloqueo, una lista de elementos o una lista de sentencias que se ejecutan al usar el objeto
data Declaration = Unlock Int
                 | Elements [ObjectName]
                 | OnUse Sentences
  deriving (Show, Eq)                   
           
-- Condiciones para los comandos condicionales. 
-- Sólamente tomaremos en cuenta si un objeto está bloqueado o desbloqueado
data Conditions = Locked | Unlocked | ObjectLocked ObjectName | ObjectUnlocked ObjectName | And Conditions Conditions | Or Conditions Conditions
  deriving (Show, Eq)