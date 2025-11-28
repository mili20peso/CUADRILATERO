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
    "Agrega la instancia del PowerUp a los efectos activos del jugador."
    aPlayer addPowerUp: self.
]

{ #category : #configuration }
PowerUpLowRoll >> applyDiceModifierTo: aDictionary [
    "Adds the '<3' key for reroll logic if result >= 3."
    aDictionary at: '<3' put: true.
]
