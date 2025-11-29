"
Subclase de jugador
--STEVE--
*Tiene la misma vida
*Solo pone figuras cuadradas (base = altura)
"
Class {
	#name : #CuadrilaterosPlayerSteve,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'game logic' }
CuadrilaterosPlayerSteve >> rollDiceWith: aDice [
    "Sobreescribe el metodo para forzar que X=Y, solo tiramos el dado una vez."
    | val |
    
    "Tiramos el dado aplicando los modificadores de efectos."
    val := aDice generator: self diceConfiguration.
    
    "El resultado es un Point (X@Y) donde X e Y son iguales"
    ^ val @ val
]
