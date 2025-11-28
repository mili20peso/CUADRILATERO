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

{ #category : #configuration }
CuadrilaterosPowerUp >> applyDiceModifierTo: aDictionary [
    "Default: PowerUps that do not affect the dice do not modify the dictionary.
     Subclasses must override this to inject a modifier."
    ^ aDictionary
]
