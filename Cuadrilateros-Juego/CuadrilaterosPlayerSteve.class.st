Class {
	#name : #CuadrilaterosPlayerSteve,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'game logic' }
CuadrilaterosPlayerSteve >> rollDiceWith: aDice [
    "Sobreescribe para forzar que X=Y, usando solo el primer resultado de la tirada con modificadores."
    | val |
    
    "Tiramos el dado una sola vez, aplicando los modificadores de efectos.
     Se usa 'generator:' para obtener un único valor con todos los efectos aplicados."
    val := aDice generator: self diceConfiguration.
    
    "El resultado es un Point (X@Y) donde X y Y son iguales"
    ^ val @ val
]
