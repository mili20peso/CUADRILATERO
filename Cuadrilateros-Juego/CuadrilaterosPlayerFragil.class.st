"
Subclase de jugador
--FRAGIL--
*Tiene una sola vida
*Acumula un puntaje mayor respecto a su area cubierta (125%)
"
Class {
	#name : #CuadrilaterosPlayerFragil,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #accesing }
CuadrilaterosPlayerFragil >> addArea: anInteger [ 
    "Aplica el multiplicador de 1.25 al área o puntaje."
    areaCovered := areaCovered + (anInteger * 1.25).
]

{ #category : #initialization }
CuadrilaterosPlayerFragil >> initialize [
    super initialize.
    "Inicia con solo una vida"
    lives := 1.
]
