"
Clase abstracta de potenciador, se encarga d egenerar un potenciador al azar. 
"
Class {
	#name : #Potenciador,
	#superclass : #Object,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
Potenciador class >> subclaseAleatoria [ 
    "Devuelve una de las subclases (los tipos de powerups) al azar"
    
    "devuelve una colección con todas las subclases y selecciona una"
    ^ self subclasses atRandom

]

{ #category : #'as yet unclassified' }
Potenciador >> activarEn: unJugador juego: unJuego [ [
    self subclassResponsibility
"Como es una clase abstracta, delega la responsabilidad de tener una activacion a una clase hija"
]
]

{ #category : #'as yet unclassified' }
Potenciador >> aplicarModificadorDadoA: unDiccionario [ 
    "Metodo por defecto, solo va a sobreescribirse en los potenciadores que afecten a los dados"
    ^ unDiccionario

]

