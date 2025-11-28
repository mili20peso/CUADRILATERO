Class {
	#name : #PowerUpMinusOne,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpMinusOne >> activateOn: aPlayer game: aGame [
    "Agrega la instancia del PowerUp a los efectos activos del jugador."
    aPlayer addPowerUp: self.
]

{ #category : #configuration }
PowerUpMinusOne >> applyDiceModifierTo: aDictionary [
    "Adds the '-1' key to the modifiers dictionary."
    aDictionary at: '-1' put: true.
]
