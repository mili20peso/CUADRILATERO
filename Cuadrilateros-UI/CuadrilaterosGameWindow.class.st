"
Esta clase es la interfaz completa.
Se encarga de construir todos los elementos visuales (tablero, paneles, botones),
manejar la lógica de interacción (clicks, el 'fantasma' de la figura)
y actualizar la visualización de los datos del juego (dados, estadísticas, mensajes).
Es el controlador principal de la parte visual.
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
    "Generacion del tablero"
    boardMorph := Morph new
        color: Color darkGray;
        borderColor: Color black;
        borderWidth: 2.
        
    "Panel de Información"
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

    "Estadísticas de Jugadores"
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

    "BOTÓN DE SALTAR TURNO"
    skipButton := SimpleButtonMorph new.
    skipButton label: 'SALTAR TURNO (-1 Vida)'.
    skipButton color: (Color red alpha: 0.7).
    skipButton target: self.           "El botón le avisa a la Ventana"
    skipButton actionSelector: #skipTurnAction.
    "Llama a este método"
    skipButton extent: 200@40.
    
    infoPanel addMorph: skipButton.
    
    mainContainer addMorph: boardMorph.
    mainContainer addMorph: infoPanel.
    
    self createGridCells.
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
        
        "Se eliminan potenciadores instantáneos del jugador actual"
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
    
    "Llamada al método de clase en CuadrilaterosCellMorph para obtener el color del jugador"
	winnerColor := CuadrilaterosCellMorph colorForPlayerId: winnerId. 
    
    "Actualizar etiquetas inferiores (GAME OVER)"
    messageLabel contents: 'GAME OVER. Ganador: Jugador ', winnerId asString.
    diceLabel contents: '---'.
    
    "Crear la pantalla de victoria que cubrirá toda la ventana"
    victoryMorph := Morph new
        color: (Color black alpha: 0.8); "Fondo oscuro con transparencia"
        bounds: self bounds; "Abarca toda la ventana"
        yourself.

    "Texto grande y del color del jugador"
    text := 'El GANADOR es el JUGADOR ', winnerId asString.

    victoryMorph addMorph: (TextMorph new 
        contents: text;
        font: (TextStyle default fontOfSize: 48); "Fuente tamaño grande"
        color: winnerColor; "Color del jugador ganador"
        yourself).
        
    "Centrar el texto en la pantalla y añadir el morph a la ventana"
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

{ #category : #'game logic' }
CuadrilaterosGameWindow >> rollDiceForNextTurn [
	game isGameOver
		ifTrue: [ ^ self ].
	currentDiceRoll := game rollDiceForCurrentPlayer.
	self updateGhostSize	"ajusta el tamaño de la figura fantasma"
]

{ #category : #drawing }
CuadrilaterosGameWindow >> showPowerUpOverlayFor: aPlayer [ "Muestra una pantalla con el mensaje de potenciadores adquiridos"
    | acquiredPUs msgText playerColor overlayMorph textMorph targetRect|
    
    aPlayer activeEffects ifEmpty: [ ^ self ].
    
    "Obtiene la lista de potenciador y genera el mensaje grande"
    acquiredPUs := aPlayer activeEffects.
    
    "Usamos String streamContents: para compatibilidad con el entorno"
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
        
    "Crear el Overlay"
    targetRect := (self bounds center - (200@150)) extent: (400@300).
    
    overlayMorph := Morph new
        color: Color white;
        borderWidth: 2; 
        borderColor: Color black;
        yourself.
        
    "Asignar Bounds y Centrar"
    overlayMorph bounds: targetRect. 
    
    overlayMorph addMorph: textMorph.
    textMorph center: overlayMorph bounds center.
    
    self addMorph: overlayMorph.
    self world displayWorld. 
    
    "Pausar la ejecución por 1.5 segundos para mostrar el mensaje"
    (Delay forSeconds: 1.5) wait.
    
    "Eliminar el overlay"
    self removeMorph: overlayMorph.
    self world displayWorld.
    
    self infoPanel changed.
]

{ #category : #events }
CuadrilaterosGameWindow >> skipTurnAction [
    "Lógica al presionar el botón de saltar turno"
    
    game isGameOver ifTrue: [ ^ self ].
    
    game currentPlayer loseLife. "Activa el metodo para que el jugador pierda una vida"
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
    ^ 20 "Seteamos el stepping cada 20 milisegundos, para que el fantasma se vea de forma fluida"
]

{ #category : #utilities }
CuadrilaterosGameWindow >> textForPowerUp: aPowerUp [ 
    "Retorna una descripción en texto para un potenciador activo."
    (aPowerUp isKindOf: PowerUpPlusOne) ifTrue: [ ^ '¡Más 1 en siguiente tirada! :) ' ].
    (aPowerUp isKindOf: PowerUpMinusOne) ifTrue: [ ^ '¡Menos 1 en siguiente tirada! :O' ].
    (aPowerUp isKindOf: PowerUpLowRoll) ifTrue: [ ^ '¡Próxima tirada obtendrá lowroll!' ].
    (aPowerUp isKindOf: PowerUpHighRoll) ifTrue: [ ^ 'Próxima tirada obtendrá high!' ].
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

    "Actualizar Panel de Estadísticas de Jugadores"
    playerStatsMorph removeAllMorphs.
    game players do: [ :p |
        playerString := String streamContents: [ :stream |
            stream 
                nextPutAll: 'JUGADOR ', p id asString;
                nextPutAll: ' (';
                nextPutAll: p lives asString;
                nextPutAll: ' Vidas) | Área: ';
                "Usamos printShowingDecimalPlaces porque con las clases de tanque y fragil hay puntajes con coma"
                nextPutAll: (p areaCovered printShowingDecimalPlaces: 2). 
        ].
        playerStatsMorph addMorph: (StringMorph new contents: playerString).
    ].

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
    
    "Obtenemos la posición del mouse directamente de la 'Mano' activa"
    globalMousePos := self activeHand position.
    
    "Solo movemos si el mouse está DENTRO del tablero"
    (boardMorph containsPoint: globalMousePos) ifFalse: [ ^ self ].
    
    "3. Matemática de coordenadas (igual que antes)"
    localPoint := globalMousePos - boardMorph position.
    
    col := (localPoint x / cellSize) floor.
    row := (localPoint y / cellSize) floor.
    
    targetX := col * cellSize.
    targetY := row * cellSize.
    
    "Mover el fantasma"
    ghostMorph position: boardMorph position + (targetX @ targetY).
]

{ #category : #drawing }
CuadrilaterosGameWindow >> updateGhostSize [
    "Actualizamos el tamaño (Dimension de la figura * tamaño de celda)"
    ghostMorph ifNotNil: [
        ghostMorph extent: (currentDiceRoll x * cellSize) @ (currentDiceRoll y * cellSize).
    ].
]

{ #category : #stepping }
CuadrilaterosGameWindow >> wantsSteps [
    ^ true
]
