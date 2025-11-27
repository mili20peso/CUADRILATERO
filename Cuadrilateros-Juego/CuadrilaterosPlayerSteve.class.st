"
Subclase de jugador: STEVE
Sus tiradas SIEMPRE dan formas cuadradas
"
Class {
	#name : #CuadrilaterosPlayerSteve,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'game logic' }
CuadrilaterosPlayerSteve >> rollDiceWith: aDice [
    "Sobreescribe para forzar que X=Y, usando solo el primer resultado de rollMod:"
    | valX |
    
    "Tiramos el dado una sola vez, aplicando los modificadores de efectos"
    valX := aDice rollMod: self diceConfiguration.
    
    "El resultado es un Point (X@Y) donde X y Y son iguales"
    ^ valX @ valX
]
