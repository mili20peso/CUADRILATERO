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
    (aPowerUp isKindOf: PowerUpBlockTurn) ifTrue: [ ^ '⛔' ].
    (aPowerUp isKindOf: PowerUpPlusOne) ifTrue: [ ^ '+1' ].
    (aPowerUp isKindOf: PowerUpMinusOne) ifTrue: [ ^ '-1' ].
    (aPowerUp isKindOf: PowerUpLowRoll) ifTrue: [ ^ '⬇' ].
    (aPowerUp isKindOf: PowerUpHighRoll) ifTrue: [ ^ '⬆' ].
    (aPowerUp isKindOf: PowerUpOverwrite) ifTrue: [ ^ '⚔️' ].
    (aPowerUp isKindOf: PowerUpRandomBlock) ifTrue: [ ^ '🎲' ].
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
	self submorphs removeAll.
	aValue isNil
		ifTrue: [ self color: Color white.
			^ self ].
	aValue isNumber
		ifTrue: [ self color: (self colorForPlayer: aValue).
			^ self ].
	(aValue isKindOf: CuadrilaterosPowerUp)
		ifFalse: [ ^ self ].
	self color: Color lightGray.
	self
		addMorph:
			(StringMorph new
				contents: (self iconForPowerUp: aValue);
				color: Color black;
				yourself).
	self submorphs first center: self center
]
