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
    "Intenta colocar la figura. Retorna true si tuvo éxito, false si falló."
    | player success acquiredPowerUps | 
    player := self currentPlayer.
    
    success := board canPlaceShape: originPoint 
                     width: aPointDimensions x 
                     height: aPointDimensions y 
                     player: player.

    success ifTrue: [ 
        "Capturamos los PowerUps y marcamos el tablero"
        acquiredPowerUps := board placeShape: originPoint 
              width: aPointDimensions x 
              height: aPointDimensions y 
              player: player. 

        "Activamos PowerUps adquiridos, añadiéndolos a activeEffects (si son de turno) o aplicando su efecto instantáneo"
        acquiredPowerUps do: [ :powerUp |
            powerUp activateOn: player game: self. 
        ].
        
    ] ifFalse: [
        "..."
    ].

    ^ success
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
    "La conversion a asArray antes de enviar #first resuelve el problema de 'message not understood'."
    
    ^ (players asSortedCollection: [ :a :b |
        "Retorna TRUE si 'a' (el primer elemento) debe ser considerado mejor que 'b' (orden descendente)"
        (a areaCovered > b areaCovered) or: [
            (a areaCovered = b areaCovered) and: [ a figuresPlaced > b figuresPlaced ]
        ]
    ]) asArray first
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

    "5. CASO C: Jugador válido. Comienza su turno."
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

{ #category : #accesing }
CuadrilaterosGAME >> players [
    ^ players
]

{ #category : #'control flow instructions' }
CuadrilaterosGAME >> rollDiceForCurrentPlayer [ 
    | player |
    player := self currentPlayer.
    
    "* LIMPIAMOS los efectos persistentes del turno anterior *"
    player clearTurnEffects. 
    
    ^ player rollDiceWith: dice
]
