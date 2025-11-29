"
Clase de jugador, contiene la informacion propia de cada usuario del juego, maneja logicas propias de su clase y ademas su ID se utiliza como indice para realizar otros metodos en clases distintas
"
Class {
	#name : #CuadrilaterosPlayer,
	#superclass : #Object,
	#instVars : [
		'id',
		'lives',
		'areaCovered',
		'figuresPlaced',
		'activeEffects'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #accessing }
CuadrilaterosPlayer >> activeEffects [
    "Devuelve la colección de efectos activos"
    ^ activeEffects
]

{ #category : #accessing }
CuadrilaterosPlayer >> addArea: anInteger [
    "Recibe el area de la figura colocada (base * altura) y le suma esa cantidad al total del jugador."
    areaCovered := areaCovered + anInteger.
]

{ #category : #adding }
CuadrilaterosPlayer >> addLife [
lives:= lives + 1
"Metodo utilizado para el potenciador vida extra"
]

{ #category : #accessing }
CuadrilaterosPlayer >> addPowerUp: aPowerUp [
    "Agrega un potenciador a la lista de efectos activos. Recibe una instancia subclase de PowerUp."
    activeEffects add: aPowerUp.
]

{ #category : #accessing }
CuadrilaterosPlayer >> areaCovered [
    "Devuelve el área total cubierta por el jugador (puntaje)"
    ^ areaCovered
]

{ #category : #'game logic' }
CuadrilaterosPlayer >> diceConfiguration [
    "Genera el diccionario con las reglas esperadas por la clase dado.
     Utiliza polimorfismo, delegando la responsabilidad a cada potenciador."
    | config |
    config := Dictionary new.
    
    activeEffects do: [ :effect |
        "Envia el mensaje a los potenciadores, solo los potenciadores que afectan a los dados podran modificar el diccionario."
        effect applyDiceModifierTo: config.
    ].
    ^ config
]

{ #category : #'game logic' }
CuadrilaterosPlayer >> figuresPlaced [
    "Devuelve la cantidad de figuras colocadas (Sirve para el desempate)."
    ^ figuresPlaced
]

{ #category : #accessing }
CuadrilaterosPlayer >> hasPowerUp: aPowerUpClass [
    "Recorre la lista y busca si alguno es del tipo que pedimos. 
		Utiliza isKindOf para buscar la clase particular"
    ^ activeEffects anySatisfy: [ :effect | effect isKindOf: aPowerUpClass ]
]

{ #category : #accessing }
CuadrilaterosPlayer >> id [
    "Devuelve el identificador del jugador (1 a 4)"
    ^ id
]

{ #category : #accessing }
CuadrilaterosPlayer >> id: anObject [
    "Establece el id del jugador"
    id := anObject
]

{ #category : #initialization }
CuadrilaterosPlayer >> initialize [
    "Inicializa las variables con los valores por defecto del juego"
    super initialize.
    lives := 3.              "Comienzan con 3 vidas"
    areaCovered := 0.        "0 superficie cubierta al inicio"
    activeEffects := OrderedCollection new. "Lista vacía para guardar potenciadores"
	 figuresPlaced := 0. "Ninguna figura colocada"

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
    "Resta una vida al jugador. Se invoca cuando el jugador decide saltar turno."
    lives := lives - 1.
]

{ #category : #'game logic' }
CuadrilaterosPlayer >> recordFigurePlaced [
    "Incrementa el contador de figuras colocadas exitosamente."
    figuresPlaced := figuresPlaced + 1.
]

{ #category : #'game logic' }
CuadrilaterosPlayer >> rollDiceWith: aDice [ 
    "Usa el dado para generar la tirada con la configuración de efectos actuales."
    ^ aDice roll: self diceConfiguration
]
