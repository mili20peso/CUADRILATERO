"
Potenciador dado menos 1
"
Class {
	#name : #PowerUpMinusOne,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpMinusOne >> activateOn: aPlayer game: aGame [
    aPlayer addPowerUp: #minusOne.
]
