{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE GADTs #-}
module AST where

-- Identificadores de Variable
type Variable = String
type TypeName = String

-- Expresiones booleanas
data BoolExp where
  -- Expresiones booleanas
  BTrue  :: BoolExp
  BFalse :: BoolExp
  And    :: BoolExp -> BoolExp -> BoolExp 
  Or     :: BoolExp -> BoolExp -> BoolExp 
  Not    :: BoolExp  -> BoolExp 
  Eq     :: Exp -> Exp  -> BoolExp
  NEq    :: Exp -> Exp -> BoolExp  

deriving instance Show BoolExp
deriving instance Eq BoolExp

-- Expresiones generales
data Exp where
  Natural :: Int -> Exp
  Chained :: Chained -> Exp
  Message :: String -> Exp
  BoolExp :: BoolExp -> Exp

deriving instance Show Exp
deriving instance Eq Exp

-- Los tipos. Pueden ser Message (String), Natural o de un tipo específicado en el DSL (String)
data Type = TMessage | TNatural | TypeName TypeName
  deriving (Show, Eq)


-- Comandos (sentencias)
data Command
  = Assign Assignment
  | ChainedCall ChainedCall
  | Return Exp
  | Show Exp
  deriving (Show, Eq)

data Assignment = Let Variable Exp
   deriving (Show, Eq)
-- El tipo de variables encadenadas: a.b.c.d.e 
-- Puede ser una llamada encadenada
-- O un acceso encadenado
data Chained = Call ChainedCall | Access ChainedAccess 
  deriving (Show, Eq)

-- Una llamada encadenada es del tipo a.b.c().d.....f(), el último componente es una llamada 
data ChainedCall = Action Variable Args | ChainAction Chained Variable Args
  deriving (Show, Eq)

-- Un acceso encadenado es del tipo a.b.c.d().e.....x.y.z, el último componente no es una acción
data ChainedAccess = Variable Variable | ChainVariable Chained Variable
  deriving (Show, Eq)
-- Los argumentos es una lista de variables
type Args = [Variable]

-- El tipo de la definición
-- Si o sí tiene que tener un Game definido
data GameDefinition = Game Declaration Definition 
                    | GameDefinitionSeq Definition GameDefinition
  deriving (Show, Eq)

-- El tipo de las definiciones
-- Puede contener Target y Object, o una secuencia de las mismas
data Definition = Target TypeName TargetDeclaration
                | Object TypeName Declaration
                | DefinitionSeq Definition Definition
  deriving (Show, Eq)

-- Las declaraciones dentro de una clase de tipo Target
-- Sí o sí contiene las condiciones de desbloqueo. La lista de boolexp indica que se tiene que cumplir la conjunción de todos los elementos
data TargetDeclaration = Unlock [BoolExp] Declaration
                      | TargetDeclarationSeq Declaration TargetDeclaration
  deriving (Show, Eq)                   

-- Las declaraciones dentro de una clase de tipo Object
-- Puede tener elementos, una sección que indica el estado inicial de estos elements
-- E indica acciones
data Declaration = Elements [Element]
                 | Init [Assignment] 
                 | Actions [Action]
                 | DeclarationSeq Declaration Declaration
  deriving (Show, Eq)                   


-- La definición de un elemento. 
-- El mismo consta de el nombre de un tipo y la variable
data Element = ElementDeclare Type Variable
  deriving (Show, Eq)                   

-- La definición de una acción
-- Una acción puede contener o no argumentos (La lista [Element] refleja este hecho)
-- Puede tener un tipo de retorno o no (El tipo Maybe refleja este hecho)
-- Y sí o sí tiene una línea que indica qué hace la acción (El Command)
data Action = ActionDeclare Variable [Element] (Maybe Type) Command
  deriving (Show, Eq)                   
