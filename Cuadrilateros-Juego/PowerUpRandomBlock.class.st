"
Este potenciador al ser recogido genera una figura 1x1 en cualquier lugar del mapa para el jugador que lo obtiene
"
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
