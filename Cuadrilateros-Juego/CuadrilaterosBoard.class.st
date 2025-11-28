"
Clase tablero
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

    "1. Validar Límites (Esto nunca cambia)"
    ((self isValidCoordinate: originPoint) and: [ self isValidCoordinate: endX@endY ]) 
        ifFalse: [ ^ false ].

    "2. Validar Superposición"  

    startX to: endX do: [ :x |
        startY to: endY do: [ :y |
            cellContent := grid at: y at: x.
            
            "Analizamos qué hay en la celda"
            cellContent ifNotNil: [
                
                "Si es un PowerUp, siempre se puede pisar (para agarrarlo)"
                (cellContent isKindOf: CuadrilaterosPowerUp) 
                    ifFalse: [
                        "Si NO es un PowerUp, es un ID de jugador (ocupado)."
                         ^ false ]
                    ].
            ].
        ].

    "3. Validar Adyacencia (Obligatorio tocar territorio propio)"
    ^ self checkAdjacencyFor: originPoint width: w height: h player: aPlayer.
]

{ #category : #initialization }
CuadrilaterosBoard >> checkAdjacencyFor: originPoint width: w height: h player: aPlayer [
    "Revisa si alguna celda del perímetro de la nueva figura toca una celda propia.
     originPoint es x@y."
    
    | startX startY endX endY neighbors |
    startX := originPoint x.
    startY := originPoint y.
    endX := startX + w - 1.
    endY := startY + h - 1.


    "Iteramos sobre cada celda de la nueva figura propuesta"
    startX to: endX do: [ :x |
        startY to: endY do: [ :y |
            "Para cada celda, miramos sus 4 vecinos (Arriba, Abajo, Izq, Der)"
            neighbors := { (x@y) + (0@1) . (x@y) - (0@1) . (x@y) + (1@0) . (x@y) - (1@0) }.
            
            neighbors do: [ :n |
                (self isValidCoordinate: n) ifTrue: [
                    "Si el vecino tiene el ID del jugador, es válido"
                    ((self contentAt: n) = aPlayer id) ifTrue: [ ^ true ].
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
    "Devuelve lo que hay en esa celda: nil, un ID de jugador o un PowerUp"
    (self isValidCoordinate: aPoint) 
        ifTrue: [ ^ grid at: aPoint y at: aPoint x ] 
        ifFalse: [ ^ nil ].
]

{ #category : #initialization }
CuadrilaterosBoard >> initializeSize: anInteger [
    "Crea un tablero cuadrado de anInteger x anInteger.
     anInteger puede ser 16, 20 o 24 según la consigna."
    
    self initialize. "me lo cambiaron por self, antes era super, por si falla"
    rows := anInteger.
    columns := anInteger.
    
    "Creamos una Matriz llena de nils (vacía)"
    grid := Array2D new: rows tabulate: [ :r :c | nil ]. "antes d ecia matrix en vez de array2d, por si falla"
]

{ #category : #initialization }
CuadrilaterosBoard >> isValidCoordinate: aPoint [
    "Verifica que el punto (x@y) esté dentro de los límites del tablero"
    ^ (aPoint x between: 1 and: columns) and: [ aPoint y between: 1 and: rows ]
]

{ #category : #initialization }
CuadrilaterosBoard >> placeRandomBlockFor: aPlayer [
    "Busca una celda vacía de forma aleatoria y se la asigna al jugador.
     Si el azar falla muchas veces, busca linealmente."
    
    | x y attempts maxAttempts |
    
    maxAttempts := 50. "Intentamos 50 veces encontrar un lugar al azar"
    attempts := 0.
    
    "--- INTENTO ALEATORIO ---"
    [ attempts < maxAttempts ] whileTrue: [
        x := (1 to: columns) atRandom.
        y := (1 to: rows) atRandom.
        
        "Si la celda es nil (vacía), la ocupamos y terminamos"
        (grid at: y at: x) isNil ifTrue: [
            grid at: y at: x put: aPlayer id.
            aPlayer addArea: 1.
            ^ self "Salimos del método inmediatamente"
        ].
        
        attempts := attempts + 1.
    ].

    "--- INTENTO LINEAL ---"
    "Si el azar falla, para garantizar que el PowerUp funcione, recorremos todo linealmente."
    
    1 to: rows do: [ :r |
        1 to: columns do: [ :c |
            (grid at: r at: c) isNil ifTrue: [
                grid at: r at: c put: aPlayer id.
                aPlayer addArea: 1.
                ^ self "Encontrado por búsqueda lineal"
            ].
        ].
    ].
    
    "Si llega aquí, el tablero está 100% lleno y no se hace nada."
]

{ #category : #initialization }
CuadrilaterosBoard >> placeShape: originPoint width: w height: h player: aPlayer [
    "Dibuja la figura en el tablero, consume PowerUps y actualiza el área del jugador"
    
    | startX startY endX endY cellContent |
    startX := originPoint x.
    startY := originPoint y.
    endX := startX + w - 1.
    endY := startY + h - 1.
    
    startX to: endX do: [ :x |
        startY to: endY do: [ :y |
            cellContent := grid at: y at: x.
            
            "Si pisamos un PowerUp, se lo damos al jugador"
            (cellContent isKindOf: CuadrilaterosPowerUp) ifTrue: [
                aPlayer addPowerUp: cellContent.
            ].
            
            "Marcamos la celda con el ID del jugador"
            grid at: y at: x put: aPlayer id.
        ].
    ].

    "Sumamos el área al jugador (w * h)"
    aPlayer addArea: (w * h).
	aPlayer recordFigurePlaced.
]

{ #category : #accesing }
CuadrilaterosBoard >> rows [
    "Devuelve la cantidad de filas del tablero"
    ^ rows
]

{ #category : #initialization }
CuadrilaterosBoard >> spawnRandomPowerUp [
    "Intenta colocar un PowerUp aleatorio en una celda vacía"
    | r c attempts maxAttempts |
    
    "Usamos random para elegir fila y columna"
    attempts := 0.
    maxAttempts := 20. "Para evitar bucles infinitos si el tablero está lleno"
    
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
