"
Potenciador de vida estra, sumara una vida al jugador que lo posea
"
Class {
	#name : #PowerUpExtraLife,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpExtraLife >> activateOn: aPlayer game: aGame [
    aPlayer addLife.
]
