Class {
	#name : #PowerUpRandomBlock,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpRandomBlock >> activateOn: aPlayer game: aGame [
    aGame board placeRandomBlockFor: aPlayer. 
    aPlayer addPowerUp: self.
]
