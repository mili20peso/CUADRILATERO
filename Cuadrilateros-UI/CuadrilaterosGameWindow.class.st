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
		'cellSize'
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
]

{ #category : #drawing }
CuadrilaterosGameWindow >> ccreateGridCells [
    | rows cols cell |
    rows := game board rows.
    cols := game board columns.
    
    "--- CORRECCIÓN AQUÍ ---"
    boardMorph removeAllMorphs. 
    "-----------------------"
    
    boardMorph extent: (cols * cellSize) @ (rows * cellSize).
    
    1 to: rows do: [ :r |
        1 to: cols do: [ :c |
            cell := CuadrilaterosCellMorph new.
            cell extent: cellSize@cellSize.
            cell position: boardMorph position + (((c - 1) * cellSize) @ ((r - 1) * cellSize)).
            cell row: r col: c.
            cell on: #mouseDown send: #cellClicked: to: self.
            boardMorph addMorph: cell.
        ].
    ].
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
    
    "--- CORRECCIÓN IMPORTANTE ---"
    boardMorph removeAllMorphs.  "Usar esto en lugar de submorphs removeAll"
    "-----------------------------"
    
    "Calculamos tamaño total"
    boardMorph extent: (cols * cellSize) @ (rows * cellSize).
    
    1 to: rows do: [ :r |
        1 to: cols do: [ :c |
            cell := CuadrilaterosCellMorph new.
            cell extent: cellSize@cellSize.
            
            "Posicionamiento manual"
            cell position: boardMorph position + (((c - 1) * cellSize) @ ((r - 1) * cellSize)).
            
            cell row: r col: c.
            cell on: #mouseDown send: #cellClicked: to: self.
            boardMorph addMorph: cell.
        ].
    ].
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
	('rR' includes: anEvent keyCharacter)
		ifFalse: [ ^ self ].
	game currentPlayer loseLife.
	messageLabel contents: 'Te rendiste en este turno. Pierdes 1 vida.'.
	game nextTurn.
	self rollDiceForNextTurn.
	self updateDisplay.
	self checkVictory
]

{ #category : #'game logic' }
CuadrilaterosGameWindow >> rollDiceForNextTurn [
    "Tira los dados para el jugador que le toca AHORA"
    game isGameOver ifFalse: [
        currentDiceRoll := game rollDiceForCurrentPlayer.
    ].
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
