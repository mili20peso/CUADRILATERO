"
Potenciador 
"
Class {
	#name : #PotenciadorCuadrilateros,
	#superclass : #Object,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PotenciadorCuadrilateros >> activarEn: unJugador juego: unJuego [
    self subclassResponsibility
    "Como es una clase abstracta, delega la responsabilidad de tener una activacion a una clase hija"
]

{ #category : #'as yet unclassified' }
PotenciadorCuadrilateros >> aplicarModificadorDadoA: unDiccionario [
    "Metodo por defecto, solo va a sobreescribirse en los potenciadores que afecten a los dados"
    ^ unDiccionario
]

{ #category : #'as yet unclassified' }
PotenciadorCuadrilateros >> subclaseAleatoria [
    "Devuelve una de las subclases (los tipos de powerups) al azar"
    
    "devuelve una colección con todas las subclases y selecciona una"
    ^ self subclasses atRandom
]
