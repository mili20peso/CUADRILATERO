"
Fuerza a que la proxima tirada no de numeros menores a 3
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
    "Guarda la regla '>3' en el diccionario para luego ser activada por el dado."
    aDictionary at: '>3' put: true.
]
