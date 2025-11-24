"
Potenciador colocar figuras sin restriccion enemiga
"
Class {
	#name : #PowerUpOverwrite,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpOverwrite >> activateOn: aPlayer game: aGame [
    "Habilita el modo 'sobrescribir' en el jugador para este turno"
    aPlayer addPowerUp: #canOverwrite.
]
