"
Clase Jugador de Cuadrilateros
"
Class {
	#name : #CuadrilaterosPlayer,
	#superclass : #Object,
	#instVars : [
		'id',
		'lives',
		'areaCovered',
		'turnsPlayed',
		'activeEffects'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #accessing }
CuadrilaterosPlayer >> activeEffects [
    "Devuelve la colección de efectos activos actualmente"
    ^ activeEffects
]

{ #category : #accessing }
CuadrilaterosPlayer >> addArea: anInteger [
    "Suma una cantidad de unidades cuadradas al total del jugador.
     anInteger: es el resultado de base * altura de la figura colocada."
    areaCovered := areaCovered + anInteger.
]

{ #category : #accessing }
CuadrilaterosPlayer >> addPowerUp: aPowerUp [
    "Agrega un potenciador a la lista de efectos activos.
     aPowerUp: es una instancia de una subclase de PowerUp."
    activeEffects add: aPowerUp.
]

{ #category : #accessing }
CuadrilaterosPlayer >> areaCovered [
    "Devuelve el área total cubierta por el jugador"
    ^ areaCovered
]

{ #category : #accessing }
CuadrilaterosPlayer >> clearTurnEffects [
    "Borra todos los efectos acumulados. 
     Se debe llamar al FINAL del turno para que los efectos como 
     +1 dado o Sobrescribir no se queden para siempre."
    activeEffects removeAll.
]

{ #category : #'game logic' }
CuadrilaterosPlayer >> diceConfiguration [
    "Genera el diccionario con las claves exactas que espera tu método rollMod:"
    | config |
    config := Dictionary new.
    
    activeEffects do: [ :effect | 
        "Traducimos los PowerUps a tus Strings claves"
        
        (effect isKindOf: PowerUpPlusOne)  ifTrue: [ config at: '+1' put: true ].
        (effect isKindOf: PowerUpMinusOne) ifTrue: [ config at: '-1' put: true ].
        (effect isKindOf: PowerUpLowRoll)  ifTrue: [ config at: '<3' put: true ].
        (effect isKindOf: PowerUpHighRoll) ifTrue: [ config at: '>3' put: true ].
    ].

    ^ config
]

{ #category : #accessing }
CuadrilaterosPlayer >> hasPowerUp: aPowerUpClass [
    "Recorre la lista y busca si alguno es del tipo (Clase) que pedimos"
    ^ activeEffects anySatisfy: [ :effect | effect isKindOf: aPowerUpClass ]
]

{ #category : #accessing }
CuadrilaterosPlayer >> id [
    "Devuelve el identificador del jugador (ej: 'Jugador 1' o #Blue)"
    ^ id
]

{ #category : #accessing }
CuadrilaterosPlayer >> id: anObject [
    "Establece el identificador del jugador"
    id := anObject
]

{ #category : #initialization }
CuadrilaterosPlayer >> initialize [
    "Inicializa las variables con los valores por defecto del juego"
    super initialize.
    lives := 3.              "Comienzan con 3 vidas"
    areaCovered := 0.        "0 superficie cubierta al inicio"
    turnsPlayed := 0.        "0 turnos jugados"
    activeEffects := OrderedCollection new. "Lista vacía para guardar potenciadores"

]

{ #category : #accessing }
CuadrilaterosPlayer >> isAlive [
    "Devuelve true si el jugador tiene más de 0 vidas, false si perdió."
    ^ lives > 0
]

{ #category : #accessing }
CuadrilaterosPlayer >> lives [
    "Devuelve la cantidad actual de vidas"
    ^ lives
]

{ #category : #accessing }
CuadrilaterosPlayer >> loseLife [
    "Resta una vida al jugador. Se invoca cuando no puede colocar figura."
    lives := lives - 1.
]

{ #category : #accessing }
CuadrilaterosPlayer >> recordTurn [
    "Incrementa el contador de turnos jugados. 
     Se debe llamar al inicio de cada turno de este jugador."
    turnsPlayed := turnsPlayed + 1.
]

{ #category : #'game logic' }
CuadrilaterosPlayer >> rollDiceWith: aDice [ 
    "Usa el dado para generar la tirada con la configuración de efectos actual.
     Este método se sobrescribe en subclases con lógica especial (ej: Suertudo, Steve)."
    ^ aDice roll: self diceConfiguration
]

{ #category : #accessing }
CuadrilaterosPlayer >> turnsPlayed [
    "Devuelve la cantidad de turnos que el jugador ha sobrevivido"
    ^ turnsPlayed
]
