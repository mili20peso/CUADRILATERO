"
Suma +1 al numero recibido por los dados en la proxima tirada
"
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
    "AGuarda la regla '+1' en el diccionario para luego ser activada por el dado."
    aDictionary at: '+1' put: true.
]
