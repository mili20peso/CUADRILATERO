"
Potenciador dado menos 1
"
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
