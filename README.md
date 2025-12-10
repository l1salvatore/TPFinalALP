# EscapeDSL - Domain Specific Language para Juegos de Escape

Un lenguaje de dominio específico (DSL) textual implementado en Haskell para facilitar el modelado de la lógica de juegos de escape y actividades similares de resolución de problemas. Este proyecto implementa las cinco fases semánticas necesarias para la validación y ejecución de programas EscapeDSL.

## Introducción

EscapeDSL es un lenguaje textual diseñado para modelar la lógica de escape rooms virtuales. A diferencia de herramientas visuales como Unity, este DSL permite especificar de forma clara y concisa:

- **Definición de objetos** en una habitación de escape
- **Relaciones entre objetos** (qué contiene qué)
- **Códigos de desbloqueo** para objetos bloqueados
- **Comportamientos condicionales** al usar objetos
- **Pistas y mensajes** basados en el estado del juego

## Características

- **Parser generado con Happy**: Análisis sintáctico de programas EscapeDSL
- **Lexer generado con Alex**: Tokenización automática del código fuente
- **Validación estática**: Detección de errores semánticos antes de ejecutar el juego
- **Ejecución interactiva**: Sistema de comandos de usuario (select, unlock, use, back)
- **Sistema de estados**: Manejo completo del estado del juego con mónadas
- **Condiciones complejas**: Soporte para condiciones anidadas con operadores `and`/`or`
- **Objetos con memoria**: Estados de bloqueo que persisten durante la ejecución

## Estructura del Proyecto

```
TPFinalALP/
├── app/                              # Ejecutable principal
│   └── Main.hs                       # Punto de entrada
├── src/                              # Código fuente de la librería
│   ├── AST.hs                        # Árbol sintáctico abstracto
│   ├── GameModel.hs                  # Estructuras de datos del modelo
│   ├── GameStateMonad.hs             # Sistema de mónadas GameState
│   ├── Lib.hs                        # Funciones auxiliares
│   ├── PrettyPrinter.hs              # Formateo de salida
│   ├── Stack.hs                      # Pila genérica
│   ├── Parser/                       # Análisis léxico y sintáctico
│   │   ├── Lexer.hs                  # Lexer generado (alex)
│   │   ├── Lexer.x                   # Definición del lexer
│   │   ├── Parser.hs                 # Parser generado (happy)
│   │   └── Parser.y                  # Definición de la gramática
│   └── Steps/                        # Fases semánticas del análisis
│       ├── Step1/
│       │   └── EnvironmentBuilder.hs # Construcción del entorno (Punto 1)
│       ├── Step2/
│       │   └── ExpressionValidator.hs # Validación estática (Punto 2)
│       ├── Step3/
│       │   └── Conditions.hs         # Evaluación de condiciones (Punto 3)
│       ├── Step4/
│       │   └── ObjectSentences.hs    # Ejecución small-step (Punto 4)
│       └── Step5/
│           └── GameExec.hs           # Transiciones del usuario (Punto 5)
├── test/                             # Suite de pruebas
│   └── Spec.hs                       # Pruebas unitarias
├── examples/                         # Archivos de ejemplo
│   ├── Success/                      # Programas válidos
│   │   ├── flashlight.escape
│   │   ├── clock.escape
│   │   ├── booknumbers.escape
│   │   └── blockfigures.escape
│   └── Error/                        # Programas con errores de validación
│       ├── badcondition.escape
│       ├── checkinglockstatusonitem.escape
│       ├── unknownobject.escape
│       └── unlockstatementonitem.escape
├── EscapeDSL.cabal                   # Configuración Cabal
├── package.yaml                      # Configuración Stack
├── stack.yaml                        # Resolución de dependencias
└── README.md                         # Este archivo
```

## Uso

### Compilar

```bash
stack build
```

### Ejecutar un Juego

```bash
stack run EscapeDSL-exe -- examples/Success/flashlight.escape
```

### Comandos Interactivos

Durante la ejecución:
- `select <nombre>` - Seleccionar un objeto
- `use` - Usar el objeto actual
- `unlock <codigo>` - Intentar desbloquear
- `back` - Volver atrás
- `help` - Mostrar ayuda
- `quit` - Salir del juego

## Ejemplos

### Ejemplos Válidos (Success/)

Todos los siguientes ejemplos están correctamente estructurados y pueden ejecutarse:

- **flashlight.escape**: Puzzle básico con linterna
- **clock.escape**: Puzzle de reloj con múltiples objetos
- **booknumbers.escape**: Búsqueda de números en libros
- **blockfigures.escape**: Puzzle de figuras bloqueadas

### Ejemplos con Errores (Error/)

Estos archivos demuestran errores de validación:

- **badcondition.escape**: Condiciones inválidas
- **unknownobject.escape**: Referencia a objeto no definido
- **unlockstatementonitem.escape**: Intento de unlock en item
- **checkinglockstatusonitem.escape**: Revisar estado en item

## Dependencias

```
- GHC 9.6.7
- Stack (gestor de dependencias)
- base >= 4.7 && < 5
- containers (Map, Set)
- mtl (transformadores de mónadas)
- array (arrays)
- happy (parser generator)
- alex (lexer generator)
```