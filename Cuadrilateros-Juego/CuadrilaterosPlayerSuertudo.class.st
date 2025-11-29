"
Subclase de jugador
--SUERTUDO--
*Tiene menos vida (2)
*Poder Suertudo: Si una tirada tiene los dos numeros menores a 3, suertudo vuelve a tirar los dados
"
Class {
	#name : #CuadrilaterosPlayerSuertudo,
	#superclass : #CuadrilaterosPlayer,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #initiali }
CuadrilaterosPlayerSuertudo >> initialize [
    super initialize.
    "Inicia con 2 vidas"
    lives := 2.
]

{ #category : #'game logic' }
CuadrilaterosPlayerSuertudo >> rollDiceWith: aDice [
    "Sobreescribe para implementar la regla del reroll si ambos dados son menores a 3."
    | resultPoint |

    "Si tiene LowRoll, para que no se quede en un bucle, suertudo pierde su habilidad caracteristica."
    (self hasPowerUp: PowerUpLowRoll) ifTrue: [
        "Realiza la tirada normal."
        ^ aDice roll: self diceConfiguration.
    ].
    [
        "Tira el dado, usando la configuración de efectos del jugador"
        resultPoint := aDice roll: self diceConfiguration.
        "Chequea la condición de reroll (X<=2 y Y<=2)"
        (resultPoint x <= 2 and: [ resultPoint y <= 2 ])
    ] whileTrue: [ 
        "Si la condición se cumple, el bucle repite la tirada"
    ].
    
    ^ resultPoint
]
