"
Representa al JugadorTanque 
"
Class {
	#name : #JugadorTanque,
	#superclass : #Jugador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
JugadorTanque >> agregarArea: unEntero [ 
    "Al tener mas vida, el tanque gana menos puntaje respecto al area cubierta."
    areaCubierta := areaCubierta + (unEntero * 0.80).


]

{ #category : #initialization }
JugadorTanque >> initialize [ 
    super initialize.
    "Inicia con 5 vidas (3 base + 2 extra)"
    vidas := 5.

]
