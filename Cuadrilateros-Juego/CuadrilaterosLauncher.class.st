"
Esta clase esta hecha para poder facilitar el arranque del juego y no depender de un script lanzador
"
Class {
	#name : #CuadrilaterosLauncher,
	#superclass : #Object,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #initialization }
CuadrilaterosLauncher class >> playerRoles [
	"Mapeo de la clase de jugador a su descripción."
    ^ Dictionary new
        at: CuadrilaterosPlayer put: 'Base: Balanceado';
        at: CuadrilaterosPlayerTanque put: 'Tanque: Mucha vida / - Puntuación';
        at: CuadrilaterosPlayerFragil put: 'Frágil: + Puntuación / 1 Vida';
        at: CuadrilaterosPlayerSuertudo put: 'Suertudo: Mejores Tiradas / -Vida';
        at: CuadrilaterosPlayerSteve put: 'STEVE: Solo hace cuadrados';
        yourself
]

{ #category : #initialization }
CuadrilaterosLauncher class >> roleChoices [
	"Genera la lista de formato (NombreClase: Descripción)"
    | dict |
    dict := self playerRoles.
    ^ dict keys collect: [ :class | 
        class name , ': ' , (dict at: class) 
    ]

]

{ #category : #initialization }
CuadrilaterosLauncher class >> roleValues [ 
	"Genera la lista de Clases reales (los valores) que se devolverán al seleccionar."
    ^ self playerRoles keys
]

{ #category : #initialization }
CuadrilaterosLauncher class >> start [
    "Ejecuta toda la inicializacion del juego."
    | playerCount size playerClasses game window roles |
    
    "1. Elegir cantidad de jugadores"
    playerCount := UIManager default  
        chooseFrom: #('2 Jugadores' '3 Jugadores' '4 Jugadores')  
        values: #(2 3 4)  
        title: 'Seleccione cantidad de jugadores'.

    playerCount ifNil: [ ^ self ]. "Si cancela, sale"

    "2. Elegir tamaño del tablero"
    size := UIManager default  
        chooseFrom: #('Pequeño (16x16)' 'Mediano (20x20)' 'Grande (24x24)')  
        values: #(16 20 24)  
        title: 'Seleccione tamaño del tablero'.

    size ifNil: [ ^ self ].
    
    "3. Elegir clase/rol para cada jugador"
    roles := self roleChoices.
    playerClasses := OrderedCollection new.
    
    1 to: playerCount do: [ :i |
        | selectedRoleClass titleString |

        titleString := String streamContents: [ :stream |
            stream nextPutAll: 'Jugador '.
            stream nextPutAll: i asString.
            stream nextPutAll: ': Seleccione su Clase/Rol'
        ].
        
        "Pregunta al jugador actual por su clase"
        selectedRoleClass := UIManager default
            chooseFrom: roles
            values: self roleValues
            title: titleString.
            
        selectedRoleClass ifNil: [ ^ self ]. "Si cancela, sale"
        playerClasses add: selectedRoleClass.
    ].

    "4. Inicializar Lógica con las elecciones"
    game := CuadrilaterosGAME new.
    game initializeWithPlayerClasses: playerClasses boardSize: size.

    "5. Abrir Ventana"
    window := CuadrilaterosGameWindow new.
    window initializeWithGame: game.
    window openInWorld.
]
