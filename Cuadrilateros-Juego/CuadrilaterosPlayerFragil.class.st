"
Subclase de jugador: STEVE
Mas puntos
Un error = Muerte
"
Class {
	#name : #CuadrilaterosPlayerFragil,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #accesing }
CuadrilaterosPlayerFragil >> addArea: anInteger [ 
    "Aplica el multiplicador de 1.25 al área ganada."
    areaCovered := areaCovered + (anInteger * 1.25).
]

{ #category : #initialization }
CuadrilaterosPlayerFragil >> initialize [
    super initialize.
    "Inicializa con 1 vida"
    lives := 1.
]
