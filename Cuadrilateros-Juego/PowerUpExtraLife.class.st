Class {
	#name : #PowerUpExtraLife,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpExtraLife >> activateOn: aPlayer game: aGame [
    aPlayer addLife.
]
