"
Potenciador dados mas altos
"
Class {
	#name : #PowerUpHighRoll,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpHighRoll >> activateOn: aPlayer game: aGame [
    aPlayer addPowerUp: #forceHighRoll.
]
