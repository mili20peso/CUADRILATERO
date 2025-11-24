"
Potenciador bloque 1x1 aleatorio
"
Class {
	#name : #PowerUpRandomBlock,
	#superclass : #CuadrilaterosPowerUp,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
PowerUpRandomBlock >> activateOn: aPlayer game: aGame [
    "Le pide al juego/tablero que coloque un bloque 1x1 en una posición libre para este jugador"
    CuadrilaterosBoard placeRandomBlockFor: aPlayer.
]
