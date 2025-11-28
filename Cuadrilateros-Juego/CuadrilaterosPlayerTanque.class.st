"
Subclase de jugador: Tanque
Mas vida
Menos puntaje
"
Class {
	#name : #CuadrilaterosPlayerTanque,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #acccessing }
CuadrilaterosPlayerTanque >> addArea: anInteger [
    "Aplica el multiplicador de 0.80 al área ganada."
    areaCovered := areaCovered + (anInteger * 0.80).
]

{ #category : #initialization }
CuadrilaterosPlayerTanque >> initialize [
    super initialize.
    "Inicializa con 5 vidas (3 base + 2 extra)"
    lives := 5.
]
