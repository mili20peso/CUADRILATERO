"
Clase tablero, existe una por partida, tiene hasta 3 tamaños distintos y se encarga de la logica de colocado de figuras, ademas de la generacion y colocacion de potenciadores
"
Class {
	#name : #CuadrilaterosBoard,
	#superclass : #Object,
	#instVars : [
		'grid',
		'rows',
		'columns'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #initialization }
CuadrilaterosBoard >> canPlaceShape: originPoint width: w height: h player: aPlayer [
    "Valida límites, superposición  y adyacencia"
    
    | startX startY endX endY cellContent |
    startX := originPoint x.
    startY := originPoint y.
    endX := startX + w - 1.
    endY := startY + h - 1.

    "Validar Límites"
    ((self isValidCoordinate: originPoint) and: [ self isValidCoordinate: endX@endY ]) 
        ifFalse: [ ^ false ].

    "Validar Superposición"  

    startX to: endX do: [ :x |
        startY to: endY do: [ :y |
            cellContent := grid at: y at: x.
            
            cellContent ifNotNil: [
                
                "Si es un PowerUp, siempre se puede pisar"
                (cellContent isKindOf: CuadrilaterosPowerUp) 
                    ifFalse: [
                        "Si NO es un PowerUp, esta ocupado."
                         ^ false ]
                    ].
            ].
        ].

    "Validar Adyacencia"
    ^ self checkAdjacencyFor: originPoint width: w height: h player: aPlayer.
]

{ #category : #initialization }
CuadrilaterosBoard >> checkAdjacencyFor: originPoint width: w height: h player: aPlayer [
    "Revisa si existe adyacencia entre las figuras del jugador y esta nueva figura."
    
    | startX startY endX endY neighbors |
    startX := originPoint x.
    startY := originPoint y.
    endX := startX + w - 1.
    endY := startY + h - 1.


    "Recorremos toda la figura (no es 100% eficiente pero es poco el trabajo extra)"
    startX to: endX do: [ :x |
        startY to: endY do: [ :y |
            "Para cada celda, miramos sus 4 vecinos (Arriba, Abajo, Izq, Der)"
            neighbors := { (x@y) + (0@1) . (x@y) - (0@1) . (x@y) + (1@0) . (x@y) - (1@0) }.
            
            neighbors do: [ :n |
                (self isValidCoordinate: n) ifTrue: [
                    "Si un vecino tiene el ID del jugador, es válido"
                    ((self contentAt: n) = aPlayer id) ifTrue: [ ^ true ].
						  "Con encontrar uno sale directamente devolviendo true"
                ].
            ].
        ].
    ].
    ^ false
]

{ #category : #accesing }
CuadrilaterosBoard >> columns [
    "Devuelve la cantidad de columnas del tablero"
    ^ columns
]

{ #category : #initialization }
CuadrilaterosBoard >> contentAt: aPoint [
    "Devuelve el contenido de la celda: nil, un ID de jugador o un PowerUp"
    (self isValidCoordinate: aPoint) 
        ifTrue: [ ^ grid at: aPoint y at: aPoint x ] 
        ifFalse: [ ^ nil ].
]

{ #category : #initialization }
CuadrilaterosBoard >> initializeSize: anInteger [
    "Crea un tablero cuadrado de el valor de entrada tanto de alto como ancho.
     Puede ser 16, 20 o 24 según la eleccion."
    
    self initialize.
    rows := anInteger.
    columns := anInteger.
    
    "Creamos una Matriz vacía"
    grid := Array2D new: rows tabulate: [ :r :c | nil ].
]

{ #category : #initialization }
CuadrilaterosBoard >> isValidCoordinate: aPoint [
    "Verifica que el punto x y esté dentro del tablero"
    ^ (aPoint x between: 1 and: columns) and: [ aPoint y between: 1 and: rows ]
]

{ #category : #initialization }
CuadrilaterosBoard >> placeRandomBlockFor: aPlayer [
    "Busca una celda vacía de forma aleatoria y se la asigna al jugador.
     Si el azar falla muchas veces, busca linealmente."
    
    | x y attempts maxAttempts |
    
    maxAttempts := 50. "Intentamos 50 veces encontrar un lugar al azar"
    attempts := 0.
    
    "INTENTO ALEATORIO"
    [ attempts < maxAttempts ] whileTrue: [
        x := (1 to: columns) atRandom.
        y := (1 to: rows) atRandom.
        
        "Si la celda es nil, la ocupamos y terminamos"
        (grid at: y at: x) isNil ifTrue: [
            grid at: y at: x put: aPlayer id.
            aPlayer addArea: 1.
            ^ self "Salimos del método"
        ].
        
        attempts := attempts + 1.
    ].

    "INTENTO LINEAL"
    "Si el azar falla, para garantizar que el poder funcione, recorremos todo linealmente."
    
    1 to: rows do: [ :r |
        1 to: columns do: [ :c |
            (grid at: r at: c) isNil ifTrue: [
                grid at: r at: c put: aPlayer id.
                aPlayer addArea: 1.
                ^ self "Encontrado por búsqueda lineal"
            ].
        ].
    ].
    
    "Si llega hasta esta instancia, el tablero está 100% lleno y no se hace nada."
]

{ #category : #initialization }
CuadrilaterosBoard >> placeShape: originPoint width: w height: h player: aPlayer [ 
    "Dibuja la figura en el tablero, consume potenciadores y actualiza el puntaje"
    
    | startX startY endX endY cellContent acquiredPowerUps |
    acquiredPowerUps := OrderedCollection new. "Lista para guardar potenciadores"
    startX := originPoint x.
    startY := originPoint y.
    endX := startX + w - 1.
    endY := startY + h - 1.
    
    startX to: endX do: [ :x |
        startY to: endY do: [ :y |
            cellContent := grid at: y at: x.
            
            "Nill no puede procesar isKindOf, por lo que creamos una guarda"
            cellContent ifNotNil: [ 
                (cellContent isKindOf: CuadrilaterosPowerUp) ifTrue: [
                    acquiredPowerUps add: cellContent.
                ]
            ].
            
            "Marcamos la celda con el ID del jugador"
            grid at: y at: x put: aPlayer id.
        ].
    ].

    aPlayer addArea: (w * h).
    aPlayer recordFigurePlaced.

    ^ acquiredPowerUps "Devolvemos los potenciadores encontrados"

]

{ #category : #accesing }
CuadrilaterosBoard >> rows [
    "Devuelve la cantidad de filas del tablero"
    ^ rows
]

{ #category : #initialization }
CuadrilaterosBoard >> spawnRandomPowerUp [
    "Intenta colocar un PowerUp en una celda vacía"
    | r c attempts maxAttempts |

    attempts := 0.
    maxAttempts := 20. "Para evitar bucles infinitos, establecemos un maximo de intentos"
    
    [ attempts < maxAttempts ] whileTrue: [
        r := (1 to: rows) atRandom.
        c := (1 to: columns) atRandom.
        
        (grid at: r at: c) isNil ifTrue: [
            "Si está vacío, ponemos un PowerUp random"
            grid at: r at: c put: (CuadrilaterosPowerUp randomSubclass new).
            ^ self "Salimos del método"
        ].
        attempts := attempts + 1.
    ].
]
