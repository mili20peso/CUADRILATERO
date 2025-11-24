"
Potenciados dados mas bajos
"
Class {
	#name : #PowerUpLowRoll,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpLowRoll >> activateOn: aPlayer game: aGame [
    aPlayer addPowerUp: #forceLowRoll.
]
