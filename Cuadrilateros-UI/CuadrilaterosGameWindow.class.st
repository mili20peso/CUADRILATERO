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
    | mainContainer skipButton |
    
    mainContainer := Morph new 
        layoutPolicy: TableLayout new;
        listDirection: #leftToRight;
        color: Color transparent;
        hResizing: #spaceFill;
        vResizing: #spaceFill;
        cellInset: 10.
        
    self addMorph: mainContainer frame: (0@0 extent: 1@1).
    
    "1. Tablero"
    boardMorph := Morph new
        color: Color darkGray;
        borderColor: Color black;
        borderWidth: 2.
        
    "2. Panel de Información"
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
    
    "--- NUEVO: BOTÓN DE SALTAR TURNO ---"
    skipButton := SimpleButtonMorph new.
    skipButton label: 'SALTAR TURNO (-1 Vida)'.
    skipButton color: (Color red alpha: 0.7).
    skipButton target: self.           "El botón le avisa a la Ventana"
    skipButton actionSelector: #skipTurnAction. "Llama a este método"
    skipButton extent: 200@40.
    
    infoPanel addMorph: skipButton.
    "------------------------------------"
    
    mainContainer addMorph: boardMorph.
    mainContainer addMorph: infoPanel.
    
    self createGridCells.
]

{ #category : #events }
CuadrilaterosGameWindow >> cellClicked: anEvent [ "CREO QUE ESTE METODO HAY QUE BORRARLO"
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
	| winner winnerColor victoryMorph text winnerId |
	game isGameOver
		ifFalse: [ ^ self ].
        
	winner := game getWinner.
    winnerId := winner id.
    
    "Llamada al método de CLASE en CuadrilaterosCellMorph para obtener el color de forma centralizada"
	winnerColor := CuadrilaterosCellMorph colorForPlayerId: winnerId. 
    
    "1. Actualizar etiquetas inferiores (GAME OVER)"
    messageLabel contents: 'GAME OVER. Ganador: Jugador ', winnerId asString.
    diceLabel contents: '---'.
    
    "2. Crear el Morph de victoria que cubrirá toda la ventana"
    victoryMorph := Morph new
        color: (Color black alpha: 0.8); "Fondo oscuro semi-transparente"
        bounds: self bounds; "Abarca toda la ventana"
        yourself.

    "3. Texto grande y coloreado"
    text := 'El GANADOR es el JUGADOR ', winnerId asString.

    victoryMorph addMorph: (TextMorph new 
        contents: text;
        font: (TextStyle default fontOfSize: 48); "Fuente grande para prominencia"
        color: winnerColor; "Color del jugador ganador"
        yourself).
        
    "4. Centrar el texto en la pantalla y añadir el morph a la ventana"
    victoryMorph submorphs first center: victoryMorph center.
    self addMorph: victoryMorph.
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


    "3. Crear el Fantasma visual"
    ghostMorph := BorderedMorph new.
    ghostMorph color: (Color purple alpha: 0.5). "Semi-transparente"
    ghostMorph borderColor: Color purple.
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

{ #category : #events }
CuadrilaterosGameWindow >> skipTurnAction [
    "Lógica al presionar el botón de saltar turno"
    
    game isGameOver ifTrue: [ ^ self ].
    
    game currentPlayer loseLife.
    messageLabel contents: 'Te rendiste. Pierdes 1 vida.'.
    
    "Pasamos turno y actualizamos todo"
    game nextTurn.
    self rollDiceForNextTurn.
    self updateDisplay.
    self checkVictory.
]

{ #category : #stepping }
CuadrilaterosGameWindow >> step [
    "En cada ciclo del reloj, actualizamos la posición del fantasma"
    self updateGhostPosition.
]

{ #category : #stepping }
CuadrilaterosGameWindow >> stepTime [
    ^ 20
]

{ #category : #events }
CuadrilaterosGameWindow >> takeKeyboardFocus [
    "Obliga a Pharo a enviar las teclas a esta ventana"
    self activeHand newKeyboardFocus: self.
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

{ #category : #events }
CuadrilaterosGameWindow >> updateGhostPosition [
    "Busca la posición actual del mouse y actualiza el fantasma"
    | globalMousePos localPoint col row targetX targetY |
    
    game isGameOver ifTrue: [ ^ self ].
    ghostMorph ifNil: [ ^ self ].
    
    "1. Obtenemos la posición del mouse directamente de la 'Mano' activa"
    globalMousePos := self activeHand position.
    
    "2. Solo movemos si el mouse está DENTRO del tablero"
    (boardMorph containsPoint: globalMousePos) ifFalse: [ ^ self ].
    
    "3. Matemática de coordenadas (igual que antes)"
    localPoint := globalMousePos - boardMorph position.
    
    col := (localPoint x / cellSize) floor.
    row := (localPoint y / cellSize) floor.
    
    targetX := col * cellSize.
    targetY := row * cellSize.
    
    "4. Mover el fantasma"
    ghostMorph position: boardMorph position + (targetX @ targetY).
]

{ #category : #drawing }
CuadrilaterosGameWindow >> updateGhostSize [
    "Si el fantasma existe, actualizamos su tamaño (Ancho de dados * celda)"
    ghostMorph ifNotNil: [
        ghostMorph extent: (currentDiceRoll x * cellSize) @ (currentDiceRoll y * cellSize).
    ].
]

{ #category : #stepping }
CuadrilaterosGameWindow >> wantsSteps [
    ^ true
]
