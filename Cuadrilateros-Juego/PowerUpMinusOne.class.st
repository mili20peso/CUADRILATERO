"
Potenciador dado menos 1
"
Class {
	#name : #PowerUpMinusOne,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpMinusOne >> activateOn: aPlayer game: aGame [
    aPlayer addEffect: #minusOne.
]
