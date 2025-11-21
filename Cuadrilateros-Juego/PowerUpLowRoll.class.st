"
Potenciados dados mas bajos
"
Class {
	#name : #PowerUpLowRoll,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpLowRoll >> activateOn: aPlayer game: aGame [
    aPlayer addEffect: #forceLowRoll.
]
