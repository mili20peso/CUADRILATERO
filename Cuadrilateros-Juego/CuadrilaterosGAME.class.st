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

{ #category : #'as yet unclassified' }
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
        (player hasPowerUp: CuadrilaterosPowerUpRandomBlock) ifTrue: [
             board placeRandomBlockFor: player.
        ].
    ] ifFalse: [
        "3. Si no es válido: El método retorna false.
         NOTA: Aquí NO quitamos vida. La vida se quita si NO HAY NINGÚN movimiento posible.
         Este método solo dice si ESTE movimiento específico es válido."
    ].

    ^ success
]

{ #category : #'as yet unclassified' }
CuadrilaterosGAME >> board [
    ^ board
]

{ #category : #'as yet unclassified' }
CuadrilaterosGAME >> currentPlayer [
    "Devuelve el objeto Jugador al que le toca jugar ahora"
    ^ players at: currentPlayerIndex.
]

{ #category : #'as yet unclassified' }
CuadrilaterosGAME >> getWinner [
    ^ players asSortedCollection: [ :a :b | 
        (a areaCovered > b areaCovered) or: [ 
            (a areaCovered = b areaCovered) and: [ a turnsPlayed > b turnsPlayed ]
        ]
    ] first.
]

{ #category : #initialization }
CuadrilaterosGAME >> initializeWithPlayers: playerCount boardSize: size [
	| p startPos |
	self initialize. "decia super antes, por si falla"
	board := CuadrilaterosBoard new.
	board initializeSize: size.
	dice := CuadrilaterosDice new.
	isGameOver := false.
	currentPlayerIndex := 1.
	players := OrderedCollection new.
	1 to: playerCount do: [ :i | 
		p := CuadrilaterosPlayer new.
		p id: i.
		players add: p ].
	board
		placeShape: 1 @ 1
		width: 1
		height: 1
		player: (players at: 1).
	playerCount >= 2
		ifTrue: [ startPos := size @ size.
			board
				placeShape: startPos
				width: 1
				height: 1
				player: (players at: 2) ].
	playerCount >= 3
		ifTrue: [ startPos := size @ 1.
			board
				placeShape: startPos
				width: 1
				height: 1
				player: (players at: 3) ].
	playerCount >= 4
		ifFalse: [ ^ self ].
	startPos := 1 @ size.
	board
		placeShape: startPos
		width: 1
		height: 1
		player: (players at: 4)
]

{ #category : #'as yet unclassified' }
CuadrilaterosGAME >> isGameOver [
    ^ isGameOver
]

{ #category : #'as yet unclassified' }
CuadrilaterosGAME >> nextTurn [
    "Avanza al siguiente jugador vivo y gestiona eventos de turno"
    | activePlayers nextPlayer |
    
    "1. Verificar condición de fin de juego"
    activePlayers := players select: [ :p | p isAlive ].
    activePlayers isEmpty ifTrue: [ 
        isGameOver := true. 
        ^ self 
    ].
    
    "2. Limpiar efectos temporales del jugador que acaba de terminar"
    self currentPlayer clearTurnEffects.
    
    "3. Avanzar índice (Circular)"
    currentPlayerIndex := (currentPlayerIndex \\ players size) + 1.
    nextPlayer := self currentPlayer.
    
    "4. Si el siguiente está muerto, recursividad al siguiente"
    nextPlayer isAlive ifFalse: [ ^ self nextTurn ].

    "5. Si el siguiente está BLOQUEADO por un PowerUp"
    (nextPlayer hasPowerUp: CuadrilaterosPowerUpBlockTurn) ifTrue: [
        "Consumimos el bloqueo y saltamos turno"
        nextPlayer activeEffects removeAllSuchThat: [:e | e isKindOf: CuadrilaterosPowerUpBlockTurn ].
        ^ self nextTurn. 
    ].

    
    (3 atRandom) = 1 ifTrue: [ board spawnRandomPowerUp ].

    "7. Iniciar turno del nuevo jugador"
    nextPlayer recordTurn.
]

{ #category : #'as yet unclassified' }
CuadrilaterosGAME >> playerCannotMove [
    "El jugador pierde una vida y se pasa el turno"
    self currentPlayer loseLife.
    self nextTurn.
]

{ #category : #'as yet unclassified' }
CuadrilaterosGAME >> rollDiceForCurrentPlayer [
    "Tira los dados usando la configuración del jugador actual (si tiene potenciadores)"
    | player config resultX resultY |
    
    player := self currentPlayer.
    config := player diceConfiguration. "Obtiene reglas (ej: <3, +1)"
    
	 dice roll: config.
    resultX:= dice x.
	 resultY:= dice y.
    ^ resultX @ resultY "Devuelve un Point con (ancho @ alto)"
]
