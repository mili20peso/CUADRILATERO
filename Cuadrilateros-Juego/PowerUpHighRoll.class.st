"
Potenciador dados mas altos
"
Class {
	#name : #PowerUpHighRoll,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpHighRoll >> activateOn: aPlayer game: aGame [
    aPlayer addEffect: #forceHighRoll.
]
