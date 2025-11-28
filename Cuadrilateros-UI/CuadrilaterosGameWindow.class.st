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
		'ghostMorph',
		'powerUpLabel',
		'playerStatsMorph'
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
        
    diceLabel := StringMorph new contents: 'DADOS: ...';
        font: (TextStyle default fontOfSize: 18).
    messageLabel := TextMorph new contents: 'Bienvenido'; extent: 200@100; wrapFlag: true.
    infoPanel addMorph: (StringMorph new contents: 'ESTADO DEL JUEGO'; font: (TextStyle default fontOfSize: 14)).
    infoPanel addMorph: diceLabel.
    infoPanel addMorph: messageLabel.

    "--- NUEVO: Panel de Estadísticas de Jugadores ---"
    infoPanel addMorph: (StringMorph new contents: 'ESTADÍSTICAS'; font: (TextStyle default fontOfSize: 14)). 
    playerStatsMorph := Morph new
        layoutPolicy: TableLayout new;
        listDirection: #topToBottom;
        color: Color transparent;
        hResizing: #spaceFill;
        vResizing: #shrinkWrap;
        cellInset: 5;
        yourself.
    infoPanel addMorph: playerStatsMorph.
    "-------------------------------------------------"

    "--- NUEVO: BOTÓN DE SALTAR TURNO ---"
    skipButton := SimpleButtonMorph new.
    skipButton label: 'SALTAR TURNO (-1 Vida)'.
    skipButton color: (Color red alpha: 0.7).
    skipButton target: self.           "El botón le avisa a la Ventana"
    skipButton actionSelector: #skipTurnAction.
    "Llama a este método"
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
    ].
]

{ #category : #events }
CuadrilaterosGameWindow >> cellClicked: anEvent from: aCell [ 
    | clickedPoint success player |
    
    game isGameOver ifTrue: [ ^ self ].
    clickedPoint := aCell col @ aCell row.
    
    player := game currentPlayer. 
    success := game attemptPlaceShape: currentDiceRoll at: clickedPoint.
    
    success ifTrue: [
        
        "*** LLAMADA AL OVERLAY (Pausa y efecto visual) ***"
        self showPowerUpOverlayFor: player.
        
        messageLabel contents: '¡Jugada exitosa! Turno siguiente.'.
        
        self updateDisplay. 
        self world displayWorld. 
        
        "*** LIMPIEZA SELECTIVA: Se eliminan PowerUps instantáneos del jugador actual ***"
        player activeEffects removeAllSuchThat: [ :pu |
            (pu isKindOf: PowerUpExtraLife) or: [ pu isKindOf: PowerUpRandomBlock ]
        ].
        
        game nextTurn. 
        
        self rollDiceForNextTurn.
        self updateDisplay. 
        self checkVictory.
    ] ifFalse: [
        messageLabel contents: 'Movimiento INVÁLIDO.
        Revisa adyacencia o espacio.'. 
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

{ #category : #accessing }
CuadrilaterosGameWindow >> infoPanel [ 
    "Devuelve el panel de información (Morph) para su manipulación."
    ^ infoPanel

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

{ #category : #drawing }
CuadrilaterosGameWindow >> showPowerUpOverlayFor: aPlayer [ 
    "Muestra un overlay grande y blanco con los PowerUps recién adquiridos, y pausa la ejecución."
    | acquiredPUs msgText playerColor overlayMorph textMorph targetRect playerStatsMorph |
    
    aPlayer activeEffects ifEmpty: [ ^ self ].
    
    "1. Obtener la lista de PowerUps y generar el texto grande"
    acquiredPUs := aPlayer activeEffects.
    
    "Usamos String streamContents: para compatibilidad total con el entorno"
    msgText := String streamContents: [ :stream |
        acquiredPUs withIndexDo: [ :pu :i |
            stream nextPutAll: (self textForPowerUp: pu) , ' (Ganado)'.
            i < acquiredPUs size ifTrue: [ stream cr ] 
        ]
    ].
    
    "Obtenemos el color del jugador para el texto"
    playerColor := CuadrilaterosCellMorph colorForPlayerId: aPlayer id. 
    
    textMorph := TextMorph new 
        contents: '¡POTENCIADOR ADQUIRIDO!' , Character cr asString , msgText;
        font: (TextStyle default fontOfSize: 36);
        color: playerColor; 
        yourself.
        
    "2. Crear el Overlay: Calculamos el rectángulo blanco centrado"
    targetRect := (self bounds center - (200@150)) extent: (400@300).
    
    overlayMorph := Morph new
        color: Color white;
        borderWidth: 2; 
        borderColor: Color black;
        yourself.
        
    "3. Asignar Bounds y Centrar"
    overlayMorph bounds: targetRect. 
    
    overlayMorph addMorph: textMorph.
    textMorph center: overlayMorph bounds center.
    
    self addMorph: overlayMorph.
    self world displayWorld. 
    
    "4. Pausar el hilo de ejecución por 1.5 segundos"
    (Delay forSeconds: 1.5) wait.
    
    "5. Eliminar el overlay"
    self removeMorph: overlayMorph.
    self world displayWorld.
    
    self infoPanel changed.
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

{ #category : #utilities }
CuadrilaterosGameWindow >> textForPowerUp: aPowerUp [ 
    "Retorna una descripción en texto para un PowerUp activo."
    (aPowerUp isKindOf: PowerUpPlusOne) ifTrue: [ ^ '¡Más 1 en siguiente tirada! :) ' ].
    (aPowerUp isKindOf: PowerUpMinusOne) ifTrue: [ ^ '¡Menos 1 en siguiente tirada! :O' ].
    (aPowerUp isKindOf: PowerUpLowRoll) ifTrue: [ ^ '¡Próxima tirada obtendrá highroll!>' ].
    (aPowerUp isKindOf: PowerUpHighRoll) ifTrue: [ ^ 'Próxima tirada obtendrá lowroll!' ].
    (aPowerUp isKindOf: PowerUpRandomBlock) ifTrue: [ ^ '¡Bloque Aleatorio Extra!' ].
    (aPowerUp isKindOf: PowerUpExtraLife) ifTrue: [ ^ '¡+1 Vida!' ].
    ^ 'Potenciador Desconocido'
]

{ #category : #'game logic' }
CuadrilaterosGameWindow >> updateDisplay [
    | content playerString |
    "Eliminamos rows, cols y cell que no se usaban"
    
    "Actualizar cada celda"
    boardMorph submorphs do: [ :m |
        (m isKindOf: CuadrilaterosCellMorph) ifTrue: [
            content := game board contentAt: (m col @ m row).
            m updateStateFrom: content.
        ].
    ].

    "--- NUEVO: Actualizar Panel de Estadísticas de Jugadores ---"
    playerStatsMorph removeAllMorphs.
    game players do: [ :p |
        playerString := String streamContents: [ :stream |
            stream 
                nextPutAll: 'JUGADOR ', p id asString;
                nextPutAll: ' (';
                nextPutAll: p lives asString;
                nextPutAll: ' Vidas) | Área: ';
                "Usamos printShowingDecimalPlaces para mostrar correctamente puntajes decimales"
                nextPutAll: (p areaCovered printShowingDecimalPlaces: 2). 
        ].
        playerStatsMorph addMorph: (StringMorph new contents: playerString).
    ].
    "----------------------------------------------------------"

    "Actualizar Etiquetas de Turno"
    diceLabel contents: 'JUGADOR ', game currentPlayer id asString, 
                        ' |
Dados: ', currentDiceRoll x asString, ' x ', currentDiceRoll y asString.
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
