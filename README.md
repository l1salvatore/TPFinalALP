# EscapeDSL - Domain Specific Language para Juegos de Escape

Un lenguaje de dominio específico (DSL) implementado en Haskell para describir y ejecutar juegos de escape interactivos. El proyecto utiliza un parser y lexer generado automáticamente con las herramientas `happy` y `alex`.

## 📋 Tabla de Contenidos

- [Estructura del Proyecto](#estructura-del-proyecto)
- [Componentes Principales](#componentes-principales)
- [Archivos y Módulos](#archivos-y-módulos)
- [Uso](#uso)
- [Ejemplos](#ejemplos)

## 📁 Estructura del Proyecto

```
TPFinalALP/
├── app/                          # Ejecutable principal
│   └── Main.hs                   # Punto de entrada
├── src/                          # Código fuente de la librería
│   ├── AST.hs                    # Definición del árbol sintáctico abstracto
│   ├── ExpressionValidator.hs    # Validación de expresiones y definiciones
│   ├── GameExec.hs               # Motor de ejecución del juego
│   ├── GameModel.hs              # Estructuras de datos del modelo de juego
│   ├── GameStateMonad.hs         # Mónadas para manejar el estado del juego
│   ├── Lib.hs                    # Funciones auxiliares
│   ├── PrettyPrinter.hs          # Formatos de salida para el usuario
│   ├── Stack.hs                  # Implementación de pila genérica
│   └── Parser/                   # Parsing y lexing
│       ├── Lexer.hs              # Analizador léxico generado
│       ├── Lexer.x               # Definición del lexer (alex)
│       ├── Parser.hs             # Analizador sintáctico generado
│       └── Parser.y              # Definición del parser (happy)
├── test/                         # Tests
│   └── Spec.hs                   # Suite de pruebas
├── examples/                     # Archivos de ejemplo
│   ├── Success/                  # Ejemplos válidos
│   │   ├── blockfigures.escape
│   │   ├── booknumbers.escape
│   │   ├── clock.escape
│   │   └── flashlight.escape
│   └── Error/                    # Ejemplos con errores (para pruebas)
│       ├── badcondition.escape
│       ├── checkinglockstatusonitem.escape
│       ├── unknownobject.escape
│       └── unlockstatementonitem.escape
├── EscapeDSL.cabal               # Archivo de configuración Cabal
├── package.yaml                  # Configuración de Stack (formato YAML)
├── stack.yaml                    # Resolución de dependencias de Stack
└── README.md                     # Este archivo
```

## 🔧 Componentes Principales

### 1. **AST.hs** - Árbol Sintáctico Abstracto
Define las estructuras de datos que representan los programas en EscapeDSL:

- **`Type`**: Define tipos de objetos (`TTarget`, `TItem`)
- **`Definition`**: Definiciones del juego (objetos y configuración)
- **`Declaration`**: Propiedades de los objetos (desbloqueos, elementos, comportamientos)
- **`Sentence`**: Sentencias ejecutables (comandos y condicionales)
- **`Command`**: Acciones disponibles (mostrar mensajes u objetos)
- **`Conditions`**: Condiciones para comandos condicionales (estado de bloqueo)
- **`ShowMode`**: Modo de visualización (mensaje o objeto)

### 2. **Parser/** - Análisis Léxico y Sintáctico

#### Parser.y (Happy)
- Define la gramática del lenguaje EscapeDSL
- Reglas de parsing para convertir tokens en el AST
- Manejo de precedencia de operadores

#### Lexer.x (Alex)
- Especifica los tokens del lenguaje
- Palabras clave: `game`, `target`, `item`, `unlock`, `elements`, `onuse`, `if`, `show`, etc.
- Caracteres especiales y strings
- Números para códigos de desbloqueo

### 3. **GameModel.hs** - Modelo de Datos del Juego
Estructuras fundamentales para representar el estado del juego:

- **`GameEnvironment`**: Mapa de objetos del juego con sus propiedades
- **`ObjectData`**: Datos de un objeto (elementos, sentencias, código de desbloqueo, tipo)
- **`BlockMap`**: Mapa de estados de bloqueo para objetos destino
- **`ObjectStack`**: Pila de navegación (historial de objetos visitados)
- **`Sigma`**: Estado completo (bloqueos + pila de navegación)
- **`InputCommand`**: Comandos del usuario (select, unlock, back, use)

### 4. **GameStateMonad.hs** - Sistema de Mónadas
Implementa las mónadas necesarias para ejecutar el juego:

- **`GameState`**: Mónada principal que encapsula el estado y manejo de excepciones
- **`GameStateError`**: Clase para lanzar excepciones
- **`MonadGameIO`**: Clase para operaciones de entrada/salida
- **`GameStateObjectsMonad`**: Clase para operaciones sobre objetos
- **`GameStateNavigationStackMonad`**: Clase para navegación
- **`buildEnvironment`**: Construye el entorno inicial desde la definición del juego
- **`buildObjectData`**: Construye datos de objetos individuales

### 5. **GameExec.hs** - Motor de Ejecución
Contiene la lógica de ejecución del juego:

- **`runGame`**: Loop principal del juego
- **`processUserInput`**: Procesa comandos del usuario
- **`execute`**: Ejecuta sentencias del juego
- **`executeCmd`**: Ejecuta comandos individuales
- **`evalCond`**: Evalúa condiciones (estados de bloqueo)
- Soporte para comandos condicionales (`if-then`)

### 6. **ExpressionValidator.hs** - Validación
Valida la correctitud del programa antes de ejecutar:

- **`validateGameDefinition`**: Valida la definición completa del juego
- **`validateDeclarations`**: Valida declaraciones de objetos
- **`validateSentences`**: Valida sentencias
- **`validateCommand`**: Valida comandos individuales
- **`validateConditions`**: Valida condiciones
- Genera excepciones para errores (objetos desconocidos, tipos incorrectos, etc.)

### 7. **PrettyPrinter.hs** - Formateo de Salida
Controla cómo se presenta la información al usuario:

- **`ppMessage`**: Imprime mensajes simples
- **`ppUserError`**: Formatea errores de usuario
- **`ppElements`**: Muestra lista de elementos
- **`ppCurrentObject`**: Muestra objeto actual
- **`ppShowMenu`**: Muestra menú de comandos disponibles
- **`ppObjList`**: Formatea listas de objetos

### 8. **Stack.hs** - Estructura de Datos Auxiliar
Implementación genérica de pila:

```haskell
class Stack m where
  push :: a -> m a -> m a
  pop  :: m a -> m a
  peek :: m a -> Maybe a
```

### 9. **Main.hs** - Punto de Entrada
Ejecutable principal que:

1. Lee un archivo `.escape` desde la línea de comandos
2. Lo parsea usando el lexer y parser
3. Valida la definición del juego
4. Ejecuta el juego interactivamente

## 🎮 Archivos y Módulos

| Archivo | Propósito | Funciones Clave |
|---------|-----------|-----------------|
| `AST.hs` | Define estructuras de datos | `GameDefinition`, `Definition`, `Command`, `Conditions` |
| `GameModel.hs` | Estructuras de estado | `GameEnvironment`, `ObjectData`, `BlockMap` |
| `GameStateMonad.hs` | Sistema de mónadas | `GameState`, `buildEnvironment` |
| `GameExec.hs` | Lógica de ejecución | `runGame`, `execute`, `evalCond` |
| `ExpressionValidator.hs` | Validación | `validateGameDefinition`, `validateCommand` |
| `PrettyPrinter.hs` | Salida formateada | `ppMessage`, `ppUserError`, `ppShowMenu` |
| `Parser.y` | Gramática | Reglas de parseo |
| `Lexer.x` | Tokens | Definición de palabras clave y símbolos |
| `Main.hs` | Punto de entrada | `main`, `buildAndStartGame` |

## 🚀 Uso

### Compilar el Proyecto

```bash
# Con Stack
stack build

# O con Cabal
cabal build
```

### Ejecutar un Juego

```bash
# Con Stack
stack run EscapeDSL-exe -- examples/Success/flashlight.escape

# O directamente
./dist-newstyle/build/.../EscapeDSL-exe-0.1.0.0/x/EscapeDSL-exe/build/EscapeDSL-exe examples/Success/flashlight.escape
```

## 📝 Sintaxis del Lenguaje EscapeDSL

### Estructura Básica

```escape
game {
  objeto1, objeto2, objeto3
}

target nombre_objeto {
  unlock: 1234
  elements: element1, element2
  onuse: [
    if locked show "Message"
    show objeto_element
  ]
}

item nombre_item {
  elements: subelement1
  onuse: [
    show "Un mensaje"
  ]
}
```

### Palabras Clave

- **`game`**: Define los objetos raíz del juego
- **`target`**: Objeto bloqueado que se puede desbloquear
- **`item`**: Objeto sin bloqueo
- **`unlock`**: Código de desbloqueo
- **`elements`**: Sub-objetos disponibles
- **`onuse`**: Comportamiento al usar el objeto
- **`if`**: Condicional
- **`locked`/`unlocked`**: Estados
- **`and`/`or`**: Operadores lógicos
- **`show`**: Comando para mostrar

## 📚 Ejemplos

Consulta la carpeta `examples/` para ver:

### Ejemplos Válidos (Success)
- `flashlight.escape`: Linterna en un juego de escape
- `clock.escape`: Puzzle de reloj
- `booknumbers.escape`: Puzzle de números en libros
- `blockfigures.escape`: Puzzle de figuras bloqueadas

### Ejemplos con Errores (Error)
- `badcondition.escape`: Condiciones inválidas
- `unknownobject.escape`: Referencia a objetos inexistentes
- `unlockstatementonitem.escape`: Intento de desbloquear item
- `checkinglockstatusonitem.escape`: Revisar bloqueo en item

## 🛠️ Dependencias

El proyecto utiliza:

- **Haskell Stack**: Gestor de dependencias
- **GHC 9.6.7**: Compilador de Haskell
- **mtl**: Transformadores de mónadas
- **containers**: Mapas y conjuntos
- **array**: Para arrays
- **happy**: Generador de parsers
- **alex**: Generador de lexers

## 📄 Licencia

BSD-3-Clause - Ver archivo `LICENSE`

## 📞 Información de Contacto

Autor: Author name here  
Email: example@example.com
