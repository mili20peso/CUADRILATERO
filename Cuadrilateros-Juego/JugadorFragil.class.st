"
Representa al JugadorFragil 
"
Class {
	#name : #JugadorFragil,
	#superclass : #Jugador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
JugadorFragil >> agregarArea: unEntero [ 
    "Aplica el multiplicador de 1.25 al área o puntaje."
    areaCubierta := areaCubierta + (unEntero * 1.25).

]

{ #category : #initialization }
JugadorFragil >> initialize [ 
    super initialize.
    "Inicia con solo una vida"
    vidas := 1.

]
