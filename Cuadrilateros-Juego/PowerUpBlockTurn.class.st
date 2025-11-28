"
Potenciador bloquear turno enemigo
"
Class {
	#name : #PowerUpBlockTurn,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpBlockTurn >> activateOn: aPlayer game: aGame [
    "El jugador actual obtuvo el item, así que le decimos al juego
     que se encargue de bloquear al SIGUIENTE enemigo."
    
    aGame blockNextPlayer.
]
