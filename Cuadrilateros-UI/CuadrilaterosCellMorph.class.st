"
Esta clase representa un cuadradito en la pantalla. Sabe de qué color pintarse y qué ícono de PowerUp mostrar.
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

{ #category : #accesing }
CuadrilaterosCellMorph >> col [
    ^ col
]

{ #category : #drawing }
CuadrilaterosCellMorph >> colorForPlayer: anId [
    "Mapa de colores simple"
    anId = 1 ifTrue: [ ^ Color red ].
    anId = 2 ifTrue: [ ^ Color blue ].
    anId = 3 ifTrue: [ ^ Color green ].
    anId = 4 ifTrue: [ ^ Color yellow ].
    ^ Color gray
]

{ #category : #drawing }
CuadrilaterosCellMorph >> iconForPowerUp: aPowerUp [
    "Retorna un string/emoji segun la clase"
    (aPowerUp isKindOf: PowerUpBlockTurn) ifTrue: [ ^ 'Ø' ].
    (aPowerUp isKindOf: PowerUpPlusOne) ifTrue: [ ^ '+1' ].
    (aPowerUp isKindOf: PowerUpMinusOne) ifTrue: [ ^ '-1' ].
    (aPowerUp isKindOf: PowerUpLowRoll) ifTrue: [ ^ '☺' ].
    (aPowerUp isKindOf: PowerUpHighRoll) ifTrue: [ ^ '☻' ].
    (aPowerUp isKindOf: PowerUpOverwrite) ifTrue: [ ^ 'λ' ].
    (aPowerUp isKindOf: PowerUpRandomBlock) ifTrue: [ ^ '◙' ].
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
    
    "--- CORRECCIÓN ---"
    self removeAllMorphs. "Esta es la forma correcta de limpiar una celda en Morphic"
    "------------------"

    "1. Caso Vacío"
    aValue isNil ifTrue: [ 
        self color: Color white.
        ^ self 
    ].

    "2. Caso Jugador (Número)"
    aValue isNumber ifTrue: [ 
        self color: (self colorForPlayer: aValue).
        ^ self 
    ].

    "3. Caso PowerUp"
    (aValue isKindOf: CuadrilaterosPowerUp) ifFalse: [ ^ self ].
    
    "Dibujar PowerUp"
    self color: Color lightGray.
    self addMorph: (StringMorph new
                contents: (self iconForPowerUp: aValue);
                color: Color black;
                yourself).
                
    "Centrar el ícono recién agregado"
    self submorphs notEmpty ifTrue: [ 
        self submorphs first center: self center 
    ].
]
