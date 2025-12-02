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


-- 1. El Entorno de Lectura (Read-Only)
-- Contiene los "planos" del juego que no cambian.
data GameEnv = GameEnv {
    envGamma :: Gamma,          -- Tipos
    envObjects :: ObjectsMap    -- Definiciones (Elements, OnUse, Code)
}



-- La mónada GameState maneja el mapa de objetos (Gamma) y el estado de los objetos y navegación (Sigma)
newtype GameState a = GameState { runGameState :: StateT (GameEnv,Sigma) (ExceptT String IO) a }

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
  -- Muestra el juego raiz
  showrootgame :: m ()

instance MonadGameIO GameState where
  applyprettyprinter f x = GameState (lift (lift (f x)))
  -- read user cmd
  readusercmd = do o <- objectNavigationTop -- Toma el elemento superior de la pila (El current)
                   applyprettyprinter putStr o -- Lo imprime
                   applyprettyprinter putStr ">" -- Imprime un prompt. La idea es tener algo como 'current>'
                   GameState (lift (lift (do hFlush stdout; getLine))) -- Lee la entrada del usuario
  showrootgame =  do objectmap <- getObjectMap -- Consulto el mapa de objetos
                     xs <- getNavigationStack -- Consulto la pila de navegación
                     case xs of 
                        -- Si la pila sólo contiene "game", consulto el objeto "game" en el mapa
                        -- Me traigo la data, principalmente los elements de game para imprimirlos
                        ["game"] -> case Map.lookup "game" objectmap of
                                             Nothing -> throwException "Game object not found"
                                             Just gamedata -> let mainobjects = elements gamedata
                                                              in applyprettyprinter ppElements mainobjects
                        -- Si la pila es no vacía pero tiene un elemento distinto a game
                        -- llamo a la función ppCurrentObject que realiza un pp de la estructura de xs                                  
                        (x:_)    -> applyprettyprinter ppCurrentObject x
                        -- Caso contrario, lanzo la excepción de que la pila está vacía
                        _              -> throwException "Object stack is empty"



class Monad m => GameStateObjectsMonad m where
   getGamma :: m Gamma
   putGamma :: Gamma -> m ()
   getObjectMap :: m ObjectsMap
   putObjectMap :: ObjectsMap -> m ()
   getBlockMap :: m BlockMap
   putBlockMap :: BlockMap -> m ()
   getNavigationStack :: m ObjectStack
   putNavigationStack :: ObjectStack -> m ()
   insertnamewithtype :: ObjectName -> Type -> m ()
   insertobjectdata :: ObjectName -> ObjectData -> m ()
   getelements :: ObjectName -> m Elements
   getobjectdata :: ObjectName -> m ObjectData
   getusecommands :: ObjectName -> m Sentences




instance GameStateObjectsMonad GameState where
  getGamma = do
                (GameEnv gamma _, (_, _)) <- GameState get
                return gamma
  putGamma g = do
                  (GameEnv _ objectmap, (blockmap, objectstack)) <- GameState get
                  GameState (put (GameEnv g objectmap, (blockmap, objectstack)))
  getBlockMap = do
                  (GameEnv _ _ , (blockmap, _)) <- GameState get
                  return blockmap
  putBlockMap g = do
                     (GameEnv gamma objectmap, (_, objectstack)) <- GameState get
                     GameState (put (GameEnv gamma objectmap, (g, objectstack)))
  getObjectMap = do
                    (GameEnv _ objectmap, (_, _)) <- GameState get
                    return objectmap
  putObjectMap g = do
                     (GameEnv gamma _, (blockmap, objectstack)) <- GameState get
                     GameState (put (GameEnv gamma g, (blockmap, objectstack)))
  getNavigationStack = do
                      (GameEnv _ _, (_, objectstack)) <- GameState get
                      return objectstack
  putNavigationStack g = do
                      (GameEnv gamma objectmap, (blockmap, _)) <- GameState get
                      GameState (put (GameEnv gamma objectmap, (blockmap, g)))
  insertnamewithtype o t = do
                              gamma <- getGamma
                              if t == TTarget then
                               do blockmap <- getBlockMap
                                  putGamma (Map.insert o t gamma)
                                  putBlockMap (Map.insert o VLock blockmap)
                              else
                                  putGamma (Map.insert o t gamma)
  insertobjectdata name odata = do
                              objectmap <- getObjectMap
                              putObjectMap (Map.insert name odata objectmap)
  getelements obj = do
          objectmap <- getObjectMap
          case Map.lookup obj objectmap of
            Just itemdata -> return (elements itemdata)
            Nothing -> error ("Object " ++ obj ++ " not found")
  getobjectdata obj = do
          objectmap <- getObjectMap
          case Map.lookup obj objectmap of
            Just itemdata -> return itemdata
            Nothing -> error ("Object " ++ obj ++ " not found")
  getusecommands obj = do
          objectmap <- getObjectMap
          case Map.lookup obj objectmap of
            Just itemdata -> return (sentences itemdata)
            Nothing -> error ("Object " ++ obj ++ " not found")

class Monad m => GameStateNavigationStackMonad m where
 -- Obtiene el objeto en la cima de la pila de navegación
   objectNavigationTop :: m ObjectName
  -- Empuja un objeto a la pila de navegación
   objectNavigationPush :: ObjectName -> m ()
  -- Saca el objeto en la cima de la pila de navegación
   objectNavigationPop :: m ()
  -- Obtiene el estado de bloqueo de un objeto
   getLockStatus :: ObjectName -> m BlockData
  -- Desbloquea un objeto
   unlock :: ObjectName -> m ()
  -- Verifica si todos los objetos están desbloqueados
   allunlocked :: m Bool

instance GameStateNavigationStackMonad GameState where
   objectNavigationTop = do
          objectstack <- getNavigationStack
          case peek objectstack of
            Nothing -> error "Object stack is empty"
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
   getLockStatus :: ObjectName -> GameState BlockData
   getLockStatus o = do
          objectlockstate <- getBlockMap
          case Map.lookup o objectlockstate of
            Nothing -> error ("Lock status for object " ++ o ++ " not found")
            Just status -> return status
   unlock o = do
          objectlockstate <- getBlockMap
          let newobjectlockstate = Map.insert o VUnlock objectlockstate
          putBlockMap newobjectlockstate
   allunlocked :: GameState Bool
   allunlocked = do
          all (== VUnlock) . Map.elems <$> getBlockMap




buildObjectData :: [Declaration] -> (Int, Int, Int) -> GameState ObjectData
buildObjectData [] _ = return emptyObjectData
buildObjectData ((Unlock ncode) : xs) (e,s,n) = if n > 0 then error "Multiple declarations of unlock"
                                                else
                                                do
                                                  odata <- buildObjectData xs (e, s, n+1)
                                                  return (odata { code = Just ncode })
buildObjectData ((Elements objList) : xs) (e,s,n)  = if e > 0 then error "Multiple declarations of elements"
                                                     else
                                                     do
                                                      odata <- buildObjectData xs (e+1,s,n)
                                                      return (odata { elements = Set.fromList objList})
buildObjectData ((OnUse onUseCode) : xs) (e,s,n) = if s > 0 then error "Multiple declarations of onUSe"
                                                   else
                                                   do
                                                      odata <- buildObjectData xs (e,s+1,n)
                                                      return (odata { sentences = onUseCode })

buildEnvironment :: GameDefinition -> GameState ()
buildEnvironment [] = return ()
buildEnvironment ((Game objList) :xs) = do
                                            buildEnvironment (ObjectDef TItem "game" [Elements objList]: xs)
buildEnvironment ((ObjectDef typ name decls):xs) = do
                                                      odata <- buildObjectData decls (0,0,0)
                                                      insertnamewithtype name typ
                                                      insertobjectdata name odata
                                                      buildEnvironment xs




