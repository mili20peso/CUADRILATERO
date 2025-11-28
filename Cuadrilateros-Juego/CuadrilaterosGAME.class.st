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
    "Intenta colocar la figura. Retorna booleano si pudo o no"
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

        "Activamos PowerUps adquiridos, añadiéndolos a activeEffects (si son de dado) o aplicando su efecto instantáneo"
        acquiredPowerUps do: [ :powerUp |
            powerUp activateOn: player game: self. 
        ].].
        

    ^ success
]

{ #category : #accesing }
CuadrilaterosGAME >> board [
    ^ board
]

{ #category : #accesing }
CuadrilaterosGAME >> currentPlayer [
    "Devuelve el Jugador al que le toca ahora"
    ^ players at: currentPlayerIndex.
]

{ #category : #accesing }
CuadrilaterosGAME >> getWinner [
    "Realiza un ordenamiento para poner como primer elemento el jugador con mas puntos."
    ^ (players asSortedCollection: [ :a :b |
        (a areaCovered > b areaCovered) or: [
            (a areaCovered = b areaCovered) and: [ a figuresPlaced > b figuresPlaced ]
        ] "Si tienen los mismos puntos ordena segun figuras colocadas como desempate."
    ]) asArray first. "asArray para que entienda first"

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
		
		"Empieza a colocar a cada jugador en una esquina segun la cantidad que exista."
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
	players size = 4
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
    
    "1.Verificar si el juego terminó"
    (players select: [:p | p isAlive]) isEmpty ifTrue: [ 
        isGameOver := true. 
        ^ self 
    ].

    "2. Avanzar el índice"
    currentPlayerIndex := (currentPlayerIndex \\ players size) + 1.
    nextPlayer := self currentPlayer.

    "3. CASO A: El jugador está MUERTO"
    nextPlayer isAlive ifFalse: [ 
        ^ self nextTurn "Saltamos al siguiente"
    ].

    "3. CASO B: Jugador válido. Comienza su turno."
    
    nextPlayer recordTurn.
    
    (3 atRandom) = 1 ifTrue: [ board spawnRandomPowerUp ].
	"Generar PowerUp en el mapa (33%)"

    "4. Iniciar turno del nuevo jugador"
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
    | player result |
    player := self currentPlayer.
    
    "Ejecuta la tirada, si tiene powerups los usa."
    result := player rollDiceWith: dice. 
    
    "Limpieza de powerups."
    player activeEffects removeAll.	
    ^ result
]
