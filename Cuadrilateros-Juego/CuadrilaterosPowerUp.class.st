"
Clase abstracta de potenciador, se encarga d egenerar un potenciador al azar.
"
Class {
	#name : #CuadrilaterosPowerUp,
	#superclass : #Object,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #creation }
CuadrilaterosPowerUp class >> randomSubclass [
    "Devuelve una de las subclases (los tipos de powerups) al azar"
    
    "devuelve una colección con todas las subclases y selecciona una"
    ^ self subclasses atRandom
]

{ #category : #activation }
CuadrilaterosPowerUp >> activateOn: aPlayer game: aGame [
    self subclassResponsibility
"Como es una clase abstracta, delega la responsabilidad de tener una activacion a una clase hija"
]

{ #category : #configuration }
CuadrilaterosPowerUp >> applyDiceModifierTo: aDictionary [
    "Metodo por defecto, solo va a sobreescribirse en los potenciadores que afecten a los dados"
    ^ aDictionary
]
