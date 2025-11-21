"
Dados mas 1
"
Class {
	#name : #PowerUpPlusOne,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpPlusOne >> activateOn: aPlayer game: aGame [
    aPlayer addEffect: #plusOne.
]
