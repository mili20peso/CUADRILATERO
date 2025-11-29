"
Fuerza a que la proxima tirada no de numeros mayores a 3
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
    "Guarda la regla '<3' en el diccionario para luego ser activada por el dado."
    aDictionary at: '<3' put: true.
]
