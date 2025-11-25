"
Esta es la interfaz completa. Maneja los eventos de teclado y mouse.
"
Class {
	#name : #CuadrilaterosGameWindow,
	#superclass : #SystemWindow,
	#instVars : [
		'game',
		'boardMorph',
		'infoPanel',
		'diceLabel',
		'messageLabel',
		'currentDiceRoll',
		'cellSize',
		'ghostMorph'
	],
	#category : #'Cuadrilateros-UI'
}

{ #category : #building }
CuadrilaterosGameWindow >> buildUI [
    | mainContainer |
    
    "Panel principal"
    mainContainer := Morph new 
        layoutPolicy: TableLayout new;
        listDirection: #leftToRight;
        color: Color transparent;
        hResizing: #spaceFill;
        vResizing: #spaceFill;
        cellInset: 10.
        
    self addMorph: mainContainer frame: (0@0 extent: 1@1).
    
    "1. Crear el Tablero Visual (SIN layoutPolicy, posicionamiento manual)"
    boardMorph := Morph new
        color: Color darkGray;
        borderColor: Color black;
        borderWidth: 2.
        
    "2. Crear el Panel de Info"
    infoPanel := Morph new
        layoutPolicy: TableLayout new;
        listDirection: #topToBottom;
        color: Color white;
        width: 250;
        vResizing: #spaceFill;
        cellInset: 10;
        layoutInset: 10.
        
    diceLabel := StringMorph new contents: 'DADOS: ...'; font: (TextStyle default fontOfSize: 18).
    messageLabel := TextMorph new contents: 'Bienvenido'; extent: 200@100; wrapFlag: true.
    
    infoPanel addMorph: (StringMorph new contents: 'ESTADO DEL JUEGO'; font: (TextStyle default fontOfSize: 14)).
    infoPanel addMorph: diceLabel.
    infoPanel addMorph: messageLabel.
    infoPanel addMorph: (StringMorph new contents: 'Presiona "R" para Rendirte/Saltar').
    
    mainContainer addMorph: boardMorph.
    mainContainer addMorph: infoPanel.
    
    "Generar la grilla"
    self createGridCells.
	self on: #mouseEnter send: #takeKeyboardFocus to: self.
]

{ #category : #events }
CuadrilaterosGameWindow >> cellClicked: anEvent [
    "Cuando el usuario hace click en una celda, intenta poner la figura"
    | cell clickedPoint success |
    
    game isGameOver ifTrue: [ ^ self ].
    
    cell := anEvent receiver.
    clickedPoint := cell col @ cell row. "Ojo: Pharo usa x@y, que es col@row"
    
    "Intentamos colocar la figura con las dimensiones de los dados actuales"
    success := game attemptPlaceShape: currentDiceRoll at: clickedPoint.
    
    success ifTrue: [
        messageLabel contents: '¡Jugada exitosa! Turno siguiente.'.
        game nextTurn.
        self rollDiceForNextTurn.
        self updateDisplay.
        self checkVictory.
    ] ifFalse: [
        messageLabel contents: 'Movimiento INVÁLIDO. Revisa adyacencia o espacio.'.
        (game currentPlayer hasPowerUp: PowerUpOverwrite) ifTrue: [
             messageLabel contents: messageLabel contents, ' (Tienes Overwrite activo)'.
        ].
    ].
]

{ #category : #events }
CuadrilaterosGameWindow >> cellClicked: anEvent from: aCell [
    "Ahora recibimos la celda directamente como segundo argumento"
    | clickedPoint success |
    
    game isGameOver ifTrue: [ ^ self ].
    
    "Ya no necesitamos anEvent receiver, usamos aCell directamente"
    clickedPoint := aCell col @ aCell row. 
    
    "Intentamos colocar la figura"
    success := game attemptPlaceShape: currentDiceRoll at: clickedPoint.
    
    success ifTrue: [
        messageLabel contents: '¡Jugada exitosa! Turno siguiente.'.
        game nextTurn.
        self rollDiceForNextTurn.
        self updateDisplay.
        self checkVictory.
    ] ifFalse: [
        messageLabel contents: 'Movimiento INVÁLIDO. Revisa adyacencia o espacio.'.
        (game currentPlayer hasPowerUp: PowerUpOverwrite) ifTrue: [
             messageLabel contents: messageLabel contents, ' (Tienes Overwrite activo)'.
        ].
    ].
]

{ #category : #'game logic' }
CuadrilaterosGameWindow >> checkVictory [
	| winner |
	game isGameOver
		ifFalse: [ ^ self ].
	winner := game getWinner.
	UIManager default
		inform: '¡JUEGO TERMINADO! El ganador es el JUGADOR ' , winner id asString.
	messageLabel
		contents: 'GAME OVER. Ganador: Jugador ' , winner id asString.
	diceLabel contents: '---'
]

{ #category : #drawing }
CuadrilaterosGameWindow >> createGridCells [
    | rows cols cell |
    rows := game board rows.
    cols := game board columns.
    
    boardMorph removeAllMorphs.
    boardMorph extent: (cols * cellSize) @ (rows * cellSize).
    
    "1. Crear las celdas normales"
    1 to: rows do: [ :r |
        1 to: cols do: [ :c |
            cell := CuadrilaterosCellMorph new.
            cell extent: cellSize@cellSize.
            cell position: boardMorph position + (((c - 1) * cellSize) @ ((r - 1) * cellSize)).
            cell row: r col: c.
            cell on: #mouseDown send: #cellClicked:from: to: self.
            boardMorph addMorph: cell.
        ].
    ].

    "2. Configurar evento de movimiento del mouse"
    boardMorph on: #mouseMove send: #updateGhostPosition: to: self.

    "3. Crear el Fantasma visual"
    ghostMorph := BorderedMorph new.
    ghostMorph color: (Color blue alpha: 0.3). "Semi-transparente"
    ghostMorph borderColor: Color blue.
    ghostMorph borderWidth: 2.
    ghostMorph lock. "CRUCIAL: Hace que los clicks atraviesen el fantasma y lleguen a la celda"
    
    boardMorph addMorph: ghostMorph.
    
    "Ajustar tamaño inicial"
    self updateGhostSize.
]

{ #category : #events }
CuadrilaterosGameWindow >> handlesKeyboard [
    ^ true
]

{ #category : #initialization }
CuadrilaterosGameWindow >> initializeWithGame: aGame [
    self initialize.
    game := aGame.
    cellSize := 25. "Tamaño en pixeles de cada celda"
    
    self setLabel: 'Cuadriláteros - Pharo Game'.
    self extent: 800@650.
    
    "Configuramos el dado inicial"
    currentDiceRoll := game rollDiceForCurrentPlayer.
    
    self buildUI.
    self updateDisplay.
]

{ #category : #events }
CuadrilaterosGameWindow >> keyStroke: anEvent [
	game isGameOver
		ifTrue: [ ^ self ].
	anEvent keyCharacter = Character space
		ifFalse: [ ^ self ].
	game currentPlayer loseLife.
	messageLabel contents: '¡TE RENDISTE! Pierdes 1 vida y pasas turno.'.
	game nextTurn.
	self rollDiceForNextTurn.
	self updateDisplay.
	self checkVictory
]

{ #category : #'game logic' }
CuadrilaterosGameWindow >> rollDiceForNextTurn [
	game isGameOver
		ifTrue: [ ^ self ].
	currentDiceRoll := game rollDiceForCurrentPlayer.
	self updateGhostSize	"ajusta el tamaño de la figura fantasma"
]

{ #category : #'game logic' }
CuadrilaterosGameWindow >> updateDisplay [
    | content | "Eliminamos rows, cols y cell que no se usaban"
    
    "Actualizar cada celda"
    boardMorph submorphs do: [ :m | 
        (m isKindOf: CuadrilaterosCellMorph) ifTrue: [
            content := game board contentAt: (m col @ m row).
            m updateStateFrom: content.
        ].
    ].

    "Actualizar Etiquetas"
    diceLabel contents: 'JUGADOR ', game currentPlayer id asString, 
                        ' | Dados: ', currentDiceRoll x asString, ' x ', currentDiceRoll y asString.
]

{ #category : #drawing }
CuadrilaterosGameWindow >> updateGhostSize [
    "Si el fantasma existe, actualizamos su tamaño (Ancho de dados * celda)"
    ghostMorph ifNotNil: [
        ghostMorph extent: (currentDiceRoll x * cellSize) @ (currentDiceRoll y * cellSize).
    ].
]
