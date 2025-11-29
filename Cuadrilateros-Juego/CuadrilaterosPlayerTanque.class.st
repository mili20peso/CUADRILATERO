"
Subclase de jugador
--TANQUE--
*Tiene mas vida (5)
*Acumula un menor puntaje respecto al area cubierta (80%)
"
Class {
	#name : #CuadrilaterosPlayerTanque,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #acccessing }
CuadrilaterosPlayerTanque >> addArea: anInteger [
    "Al tener mas vida, el tanque gana menos puntaje respecto al area cubierta."
    areaCovered := areaCovered + (anInteger * 0.80).
]

{ #category : #initialization }
CuadrilaterosPlayerTanque >> initialize [
    super initialize.
    "Inicia con 5 vidas (3 base + 2 extra)"
    lives := 5.
]
