"
Representa visualmente una única celda dentro del tablero de juego.
Se encarga de dibujar el color del jugador que la ocupa o el ícono
del potenciador que contiene. Es la clase que contiene las coordenadas del click que se va a recibir
"
Class {
	#name : #CuadrilaterosCellMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'row',
		'col'
	],
	#category : #'Cuadrilateros-UI'
}

{ #category : #utilities }
CuadrilaterosCellMorph class >> colorForPlayerId: anId [
    "Método de clase. Mapea un ID de jugador a un Color."
    anId = 1 ifTrue: [ ^ Color red ].
    anId = 2 ifTrue: [ ^ Color blue ].
    anId = 3 ifTrue: [ ^ Color green ].
    anId = 4 ifTrue: [ ^ Color yellow ].
    ^ Color gray
]

{ #category : #accesing }
CuadrilaterosCellMorph >> col [
    ^ col
]

{ #category : #drawing }
CuadrilaterosCellMorph >> iconForPowerUp: aPowerUp [
    "Retorna un identificador grafico a cada powerup, de modo que se vean en el tablero"
    (aPowerUp isKindOf: PowerUpPlusOne) ifTrue: [ ^ '+1' ].
    (aPowerUp isKindOf: PowerUpMinusOne) ifTrue: [ ^ '-1' ].
    (aPowerUp isKindOf: PowerUpLowRoll) ifTrue: [ ^ '<3' ].
    (aPowerUp isKindOf: PowerUpHighRoll) ifTrue: [ ^ '>3' ].
    (aPowerUp isKindOf: PowerUpRandomBlock) ifTrue: [ ^ 'RB' ].
	 (aPowerUp isKindOf: PowerUpExtraLife) ifTrue: [ ^ 'V' ].
    ^ '?'
]

{ #category : #accesing }
CuadrilaterosCellMorph >> row [
    ^ row
]

{ #category : #accesing }
CuadrilaterosCellMorph >> row: r col: c [
    row := r.
    col := c.
]

{ #category : #drawing }
CuadrilaterosCellMorph >> updateStateFrom: aValue [
    "Actualiza la visualización de la celda según el contenido del tablero"
    
    self removeAllMorphs.

    "Celda Vacía"
    aValue isNil ifTrue: [ 
        self color: Color white.
        ^ self 
    ].

    "Caso Jugador (Número)"
    aValue isNumber ifTrue: [ 
        self color: (self class colorForPlayerId: aValue). "Llamada al método de CLASE, asigna un color a cada id de jugador"
        ^ self 
    ].

    "Caso potenciador"
    (aValue isKindOf: CuadrilaterosPowerUp) ifFalse: [ ^ self ].
    "Dibujar PowerUp"
    self color: Color lightGray.
    self addMorph: (StringMorph new
                contents: (self iconForPowerUp: aValue);
                color: Color black;
                yourself).
    "Centra el ícono recién agregado"
    self submorphs notEmpty ifTrue: [ 
        self submorphs first center: self center]
]
