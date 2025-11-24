"
Clase abstracta de potenciadores
"
Class {
	#name : #CuadrilaterosPowerUp,
	#superclass : #Object,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #creation }
CuadrilaterosPowerUp class >> randomSubclass [
    "Devuelve una de las subclases (los tipos de powerups) al azar"
    
    "devuelve una colección con: PowerUpBlockTurn, PowerUpPlusOne, etc."
    ^ self subclasses atRandom
]

{ #category : #activation }
CuadrilaterosPowerUp >> activateOn: aPlayer game: aGame [
    self subclassResponsibility
]
