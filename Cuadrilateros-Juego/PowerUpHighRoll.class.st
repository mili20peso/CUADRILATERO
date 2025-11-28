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
    "Agrega la instancia del PowerUp a los efectos activos del jugador."
    aPlayer addPowerUp: self.
]

{ #category : #configuration }
PowerUpHighRoll >> applyDiceModifierTo: aDictionary [
    "Adds the '>3' key for reroll logic if result <= 3."
    aDictionary at: '>3' put: true.
]
