Class {
	#name : #PowerUpPlusOne,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpPlusOne >> activateOn: aPlayer game: aGame [
    "Agrega la instancia del PowerUp a los efectos activos del jugador."
    aPlayer addPowerUp: self.
]

{ #category : #configuration }
PowerUpPlusOne >> applyDiceModifierTo: aDictionary [
    "Adds the '+1' key to the modifiers dictionary."
    aDictionary at: '+1' put: true.
]
