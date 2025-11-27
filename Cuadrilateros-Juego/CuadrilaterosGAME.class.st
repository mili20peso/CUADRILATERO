"
Classe contenedora de juego
"
Class {
	#name : #CuadrilaterosGAME,
	#superclass : #Object,
	#instVars : [
		'board',
		'players',
		'dice',
		'currentPlayerIndex',
		'isGameOver'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'control flow instructions' }
CuadrilaterosGAME >> attemptPlaceShape: aPointDimensions at: originPoint [
    "Intenta colocar la figura. Retorna true si tuvo éxito, false si falló.
     aPointDimensions: (ancho @ alto) que salieron en los dados.
     originPoint: Coordenada (x @ y) donde el jugador quiere poner la esq. sup. izq."
    
    | player success |
    player := self currentPlayer.
    
    "1. Preguntar al tablero si es válido"
    success := board canPlaceShape: originPoint 
                     width: aPointDimensions x 
                     height: aPointDimensions y 
                     player: player.
                     
    success ifTrue: [
        "2. Si es válido: Colocar y aplicar efectos"
        board placeShape: originPoint 
              width: aPointDimensions x 
              height: aPointDimensions y 
              player: player.
              
        "Revisar si tenía el PowerUp RandomBlock y ejecutarlo ahora"
        (player hasPowerUp: PowerUpRandomBlock) ifTrue: [
             board placeRandomBlockFor: player.
        ].
    ] ifFalse: [
        "3. Si no es válido: El método retorna false.
         NOTA: Aquí NO quitamos vida. La vida se quita si NO HAY NINGÚN movimiento posible.
         Este método solo dice si ESTE movimiento específico es válido."
    ].

    ^ success
]

{ #category : #extra }
CuadrilaterosGAME >> blockNextPlayer [
    "Busca al siguiente jugador en la ronda y le agrega el efecto de bloqueo"
    
    | nextIndex nextPlayer blockingEffect |
    
    "1. Calculamos el índice del siguiente jugador (Matemática circular)"
    nextIndex := (currentPlayerIndex \\ players size) + 1.
    
    "2. Obtenemos al jugador víctima"
    nextPlayer := players at: nextIndex.
    
    "3. Creamos una instancia del bloqueo para usarla como 'marca'"
    blockingEffect := PowerUpBlockTurn new.
    
    "4. Se la enchufamos al enemigo en sus efectos activos"
    nextPlayer addPowerUp: blockingEffect.
    
]

{ #category : #accesing }
CuadrilaterosGAME >> board [
    ^ board
]

{ #category : #accesing }
CuadrilaterosGAME >> currentPlayer [
    "Devuelve el objeto Jugador al que le toca jugar ahora"
    ^ players at: currentPlayerIndex.
]

{ #category : #accesing }
CuadrilaterosGAME >> getWinner [
    ^ players asSortedCollection: [ :a :b | 
        (a areaCovered > b areaCovered) or: [ 
            (a areaCovered = b areaCovered) and: [ a turnsPlayed > b turnsPlayed ]
        ]
    ] first.
]

{ #category : #initialization }
CuadrilaterosGAME >> initializeWithPlayerClasses: playerClasses boardSize: size [
	| p startPos |
	self initialize.
	board := CuadrilaterosBoard new.
	board initializeSize: size.
	dice := CuadrilaterosDice new.
	isGameOver := false.
	currentPlayerIndex := 1.
	players := OrderedCollection new.
	playerClasses
		withIndexDo: [ :playerClass :i | 
			p := playerClass new.
			p id: i.
			players add: p ].
	players size >= 1
		ifTrue: [ board
				placeShape: 1 @ 1
				width: 1
				height: 1
				player: (players at: 1) ].
	players size >= 2
		ifTrue: [ startPos := size @ size.
			board
				placeShape: startPos
				width: 1
				height: 1
				player: (players at: 2) ].
	players size >= 3
		ifTrue: [ startPos := size @ 1.
			board
				placeShape: startPos
				width: 1
				height: 1
				player: (players at: 3) ].
	players size >= 4
		ifFalse: [ ^ self ].
	startPos := 1 @ size.
	board
		placeShape: startPos
		width: 1
		height: 1
		player: (players at: 4)
]

{ #category : #accesing }
CuadrilaterosGAME >> isGameOver [
    ^ isGameOver
]

{ #category : #'control flow instructions' }
CuadrilaterosGAME >> nextTurn [
    "Avanza al siguiente jugador, saltando a los muertos y a los BLOQUEADOS"
    | nextPlayer |
    
    "1. Verificar si el juego terminó (chequeo rápido)"
    (players select: [:p | p isAlive]) isEmpty ifTrue: [ 
        isGameOver := true. 
        ^ self 
    ].
    
    "2. Limpiar efectos del jugador que acaba de terminar (el actual)"
    self currentPlayer clearTurnEffects.
    
    "3. Avanzar el índice matemáticamente"
    currentPlayerIndex := (currentPlayerIndex \\ players size) + 1.
    nextPlayer := self currentPlayer.
    
    "--- LÓGICA DE SALTO ---"
    
    "4. CASO A: El jugador está MUERTO"
    nextPlayer isAlive ifFalse: [ 
        ^ self nextTurn "Recursividad: Saltamos al siguiente inmediatamente"
    ].

    "5. CASO B: El jugador está VIVO pero BLOQUEADO"
    (nextPlayer hasPowerUp: PowerUpBlockTurn) ifTrue: [
        "Le quitamos el bloqueo (se consume)"
        nextPlayer activeEffects removeAllSuchThat: [:e | e isKindOf: PowerUpBlockTurn].
        
        Transcript show: 'Saltando turno de Jugador ', nextPlayer id asString; cr.
        
        ^ self nextTurn "Recursividad: Lo saltamos y buscamos al siguiente"
    ].

    "6. CASO C: Jugador válido. Comienza su turno."
    "Generar probabilidad de PowerUp en el mapa (ej: 20%)"
    
    nextPlayer recordTurn.
    
    (3 atRandom) = 1 ifTrue: [ board spawnRandomPowerUp ].

    "7. Iniciar turno del nuevo jugador"
    nextPlayer recordTurn.
]

{ #category : #control }
CuadrilaterosGAME >> playerCannotMove [
    "El jugador pierde una vida y se pasa el turno"
    self currentPlayer loseLife.
    self nextTurn.
]

{ #category : #'control flow instructions' }
CuadrilaterosGAME >> rollDiceForCurrentPlayer [
    | player |
    player := self currentPlayer.
    
    ^ player rollDiceWith: dice
]
