"
Dados mas 1
"
Class {
	#name : #PowerUpPlusOne,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpPlusOne >> activateOn: aPlayer game: aGame [
    aPlayer addPowerUp: #plusOne.
]
