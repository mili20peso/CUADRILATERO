"
Subclase de jugador: Suertudo
Sus tiradas NUNCA seran de figuras pequeñas
"
Class {
	#name : #CuadrilaterosPlayerSuertudo,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #initiali }
CuadrilaterosPlayerSuertudo >> initialize [
    super initialize.
    "Inicializa con 2 vidas"
    lives := 2.
]

{ #category : #'game logic' }
CuadrilaterosPlayerSuertudo >> rollDiceWith: aDice [
    "Sobreescribe para implementar la regla del reroll si ambos dados son <= 2"
    | resultPoint |
    [
        "Primero tira el dado normalmente, usando la configuración de efectos del jugador"
        resultPoint := aDice roll: self diceConfiguration.
        
        "Chequea la condición de reroll (X<=2 y Y<=2)"
        (resultPoint x <= 2 and: [ resultPoint y <= 2 ])
    ] whileTrue: [ 
        Transcript show: 'Jugador ', self id asString, ': ¡Reroll Suertudo!' ; cr.
        "Si la condición se cumple, el bucle repite la tirada"
    ].
    
    ^ resultPoint
]
