"
Dados mas 1
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
