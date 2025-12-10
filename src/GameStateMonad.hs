{-# LANGUAGE GADTs #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-missing-export-lists #-}

module GameStateMonad where


import Control.Monad.State
import Control.Monad (ap)

import GameModel
import Control.Monad.Except (ExceptT)
import AST
import qualified Data.Map as Map
import qualified Data.Set as Set
import Control.Monad.Error.Class
import Stack
import GHC.IO.Handle
import GHC.IO.Handle.FD
import PrettyPrinter
import GHC.Base (when)


-- La mónada GameState maneja el mapa de objetos (Gamma) y el estado de los objetos y navegación (Sigma)
newtype GameState a = GameState { runGameState :: StateT (GameEnvironment, Sigma) (ExceptT String IO) a }

-- Declaro las instancias de Functor, Applicative y Gamestate. Me baso en la definición de mónada de StateT
instance Functor GameState where
  fmap f (GameState s) = GameState (fmap f s)
instance Applicative GameState where
  pure = GameState . pure
  (<*>) = ap
instance Monad GameState where
  return = pure
  (GameState s) >>= f = GameState (s >>= \a -> runGameState (f a))

-- La mónada GameState es un GameStateError. Tiene una definición llamada 'throwException'
class Monad m => GameStateError m where
  throwException :: String -> m ()

instance GameStateError GameState where
  throwException err = GameState (lift (throwError err))

-- La clase MonadGameIO maneja las operaciones de entrada/salida del juego
class MonadGameIO m where
  -- Toma un pretty printer de a, un elemento de tipo a y aplica el prettyprinter a ese elemento
  applyprettyprinter :: (a -> IO ()) -> a -> m ()
  -- Lee el comando de usuario
  readusercmd :: m String


instance MonadGameIO GameState where
  applyprettyprinter f x = GameState (lift (lift (f x)))
  -- read user cmd
  readusercmd = do o <- objectNavigationTop -- Toma el elemento superior de la pila (El current)
                   GameState (lift (lift (putStr o))) -- Lo imprime
                   GameState (lift (lift (putStr ">"))) -- Imprime un prompt. La idea es tener algo como 'current>'
                   GameState (lift (lift (do hFlush stdout; getLine))) -- Lee la entrada del usuario
  

-- La clase GameStateMonad. Contiene las funciones necesarias para manipular el GameStateMonad
class Monad m => GameStateMonad m where
   -- Obtiene el mapa o entorno de objetos
   getObjectEnvironment :: m GameEnvironment
   -- Dado un entorno de objetos, reemplaza el entorno actual por este nuevo en la mónada
   putObjectEnvironment :: GameEnvironment -> m ()
   -- Obtiene el mapa de bloqueos de la mónada 
   getBlockMap :: m BlockMap
   -- Dado un mapa de bloqueos, reemplaza el mapa de bloqueos actual por este nuevo en la mónada
   putBlockMap :: BlockMap -> m ()
   -- Dado un objeto, un estado Lock o Unlock, y un mapa de bloqueo, retorna un nuevo mapa de bloqueos con el par { objeto -> estado }
   getNewBlockMap :: ObjectName -> BlockData -> BlockMap -> m BlockMap
   -- Obtiene la pila de navegación de objetos
   getNavigationStack :: m ObjectStack
   -- Dado una pila de navegación, reemplaza la pila de navegación actual por este nuevo en la mónada
   putNavigationStack :: ObjectStack -> m ()



instance GameStateMonad GameState where
  getBlockMap = do
                  (_ , (blockmap, _)) <- GameState get
                  return blockmap
  putBlockMap g = do
                     (gameenvironment, (_, objectstack)) <- GameState get
                     GameState (put (gameenvironment, (g, objectstack)))

  getObjectEnvironment = do
                    (gameenvironment, (_, _)) <- GameState get
                    return gameenvironment
  putObjectEnvironment g = do
                     (_, (blockmap, objectstack)) <- GameState get
                     GameState (put (g, (blockmap, objectstack)))
  getNavigationStack = do
                      (_, (_, objectstack)) <- GameState get
                      return objectstack
  putNavigationStack g = do
                      (gameenvironment, (blockmap, _)) <- GameState get
                      GameState (put (gameenvironment, (blockmap, g)))






-- La clase GameStateNavigationStackMonad maneja las operaciones sobre la pila de navegación de objetos            
class Monad m => GameStateNavigationStackMonad m where
 -- Obtiene el objeto en la cima de la pila de navegación
   objectNavigationTop :: m ObjectName
  -- Empuja un objeto a la pila de navegación
   objectNavigationPush :: ObjectName -> m ()
  -- Saca el objeto en la cima de la pila de navegación
   objectNavigationPop :: m ()


instance GameStateNavigationStackMonad GameState where
   objectNavigationTop = do
          objectstack <- getNavigationStack
          case peek objectstack of
            Nothing -> do throwException "Unexpected Error: Object stack is empty"
                          return "" -- Esto nunca se va a ejecutar, pero lo pongo para evitar warnings
            Just o -> return o
   objectNavigationPush o = do
          objectstack <- getNavigationStack
          let newstack = push o objectstack
          putNavigationStack newstack
   objectNavigationPop = do
          objectstack <- getNavigationStack
          case objectstack of
            ["game"] -> do applyprettyprinter ppMessage "Reached the root"
                           showrootgame
            _              -> do let newstack = pop objectstack in
                                   putNavigationStack newstack
                                 showrootgame




-- Definició de funciones 
-- Estas funciones permiten manipular el estado del juego

-- Dado un objeto y un entorno, devuelve la data correspondiente. O Nothing si no encuentra el objeto
getObjectData :: ObjectName -> GameEnvironment -> GameState (Maybe ObjectData)
getObjectData o env = return (Map.lookup o env)


-- Dado un objeto, la data del objeto , inserta 
insertObjectData :: ObjectName -> ObjectData -> GameState ()
insertObjectData name odata = do
                              gameenvironment <- getObjectEnvironment
                              putObjectEnvironment (Map.insert name odata gameenvironment)
-- Inserta un objeto como bloqueado en el mapa de bloqueos
insertObjectAsLocked :: ObjectName -> GameState ()
insertObjectAsLocked o = do
          objectlockstate <- getBlockMap
          let newobjectlockstate = Map.insert o VLock objectlockstate
          putBlockMap newobjectlockstate

-- Verifica si un objeto es miembro de un conjunto de elementos
isMemberOf :: ObjectName -> Elements -> GameState Bool
isMemberOf objname elementsset = return (Set.member objname elementsset)

-- Desbloquea un objeto
unlock :: ObjectName -> GameState ()
unlock o = do
          objectlockstate <- getBlockMap
          let newobjectlockstate = Map.insert o VUnlock objectlockstate
          putBlockMap newobjectlockstate

-- Obtiene el estado de bloqueo de un objeto
getLockStatus :: ObjectName -> GameState BlockData
getLockStatus o = do
          objectlockstate <- getBlockMap
          case Map.lookup o objectlockstate of
            Nothing -> do throwException ("Unexpected Error: Lock status for object " ++ o ++ " not found")   
                          return VLock -- Esto nunca se va a ejecutar, pero lo pongo para evitar warnings
            Just status -> return status

-- Verifica si todos los objetos están desbloqueados
allunlocked :: GameState Bool
allunlocked = do
          all (== VUnlock) . Map.elems <$> getBlockMap

-- Muestra el juego raiz
showrootgame :: GameState ()
showrootgame =  do 
                    gameenvironment <- getObjectEnvironment -- Consulto el mapa de objetos
                    xs <- getNavigationStack -- Consulto la pila de navegación
                    case xs of
                        -- Si la pila sólo contiene "game", consulto el objeto "game" en el mapa
                        -- Me traigo la data, principalmente los elements de game para imprimirlos
                        ["game"] -> case Map.lookup "game" gameenvironment of
                                             Nothing -> throwException "Game object not found"
                                             Just gamedata -> let mainobjects = elements gamedata
                                                              in applyprettyprinter ppElements mainobjects
                        -- Si la pila es no vacía pero tiene un elemento distinto a game
                        -- llamo a la función ppCurrentObject que realiza un pp de la estructura de xs                                  
                        (x:_)    -> applyprettyprinter ppCurrentObject x
                        -- Caso contrario, lanzo la excepción de que la pila está vacía
                        _              -> throwException "Object stack is empty"
