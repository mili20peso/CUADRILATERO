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
