"
Representa al JugadorSuertudo 
"
Class {
	#name : #JugadorSuertudo,
	#superclass : #Jugador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #initialization }
JugadorSuertudo >> initialize [ [
    super initialize.
    "Inicia con 2 vidas"
    vidas := 2.
]
]

{ #category : #'as yet unclassified' }
JugadorSuertudo >> tirarDadoCon: unDado [ 
    "Sobreescribe para implementar la regla del reroll si ambos dados son menores a 3."
    | resultadoPunto |

    "Si tiene TiradaBaja, para que no se quede en un bucle, suertudo pierde su habilidad caracteristica."
    (self tienePotenciador: PotenciadorTiradaBaja) ifTrue: [
        "Realiza la tirada normal."
        ^ unDado tirar: self configuracionDado.
    ].
    [
        "Tira el dado, usando la configuración de efectos del jugador"
        resultadoPunto := unDado tirar: self configuracionDado.
        "Chequea la condición de reroll (X<=2 y Y<=2)"
        (resultadoPunto x <= 2 and: [ resultadoPunto y <= 2 ])
    ] whileTrue: [ 
        "Si la condición se cumple, el bucle repite la tirada"
    ].
    
    ^ resultadoPunto

]
