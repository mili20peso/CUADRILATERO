"
Clase abstracta de potenciadores
"
Class {
	#name : #CuadrilaterosPowerUp,
	#superclass : #Object,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #activation }
CuadrilaterosPowerUp >> activateOn: aPlayer game: aGame [
    self subclassResponsibility
]

{ #category : #'context activation' }
CuadrilaterosPowerUp >> randomSubclass [
    "Devuelve una de las subclases concretas al azar.
     Usa 'subclasses' que devuelve una colección con los hijos de esta clase."
    
    ^ self subclasses atRandom
]
