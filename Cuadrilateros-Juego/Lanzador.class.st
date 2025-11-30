"
Representa al Lanzador 
"
Class {
	#name : #Lanzador,
	#superclass : #Object,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
Lanzador class >> iniciar [ 
    "Ejecuta toda la inicializacion del juego."
    | cantidadJugadores tamanio clasesJugadores juego ventana roles |
    
    "1. Elegir cantidad de jugadores"
    cantidadJugadores := UIManager default  
        chooseFrom: #('2 Jugadores' '3 Jugadores' '4 Jugadores')  
        values: #(2 3 4)  
        title: 'Seleccione cantidad de jugadores'.

    cantidadJugadores ifNil: [ ^ self ]. "Si cancela, sale"

    "2. Elegir tamaño del tablero"
    tamanio := UIManager default  
        chooseFrom: #('Pequeño (16x16)' 'Mediano (20x20)' 'Grande (24x24)')  
        values: #(16 20 24)  
        title: 'Seleccione tamaño del tablero'.

    tamanio ifNil: [ ^ self ].
    
    "3. Elegir clase/rol para cada jugador"
    roles := self opcionesRoles.
    clasesJugadores := OrderedCollection new.
    
    1 to: cantidadJugadores do: [ :i |
        | claseRolSeleccionada cadenaTitulo |

        cadenaTitulo := String streamContents: [ :flujo |
            flujo nextPutAll: 'Jugador '.
            flujo nextPutAll: i asString.
            flujo nextPutAll: ': Seleccione su Clase/Rol'
        ].
        
        "Pregunta al jugador actual por su clase"
        claseRolSeleccionada := UIManager default
            chooseFrom: roles
            values: self valoresRoles
            title: cadenaTitulo.
            
        claseRolSeleccionada ifNil: [ ^ self ]. "Si cancela, sale"
        clasesJugadores add: claseRolSeleccionada.
    ].

    "4. Inicializar Lógica con las elecciones"
    juego := Juego new.
    juego inicializarConClasesJugadores: clasesJugadores tamanioTablero: tamanio.

    "5. Abrir Ventana"
    ventana := VentanaJuego new.
    ventana inicializarConJuego: juego.
    ventana openInWorld.

]

{ #category : #'as yet unclassified' }
Lanzador class >> opcionesRoles [ 
	"Genera la lista de formato (NombreClase: Descripción)"
    | diccionario |
    diccionario := self rolesJugadores.
    ^ diccionario keys collect: [ :clase | 
        clase name , ': ' , (diccionario at: clase) 
    ]


]

{ #category : #'as yet unclassified' }
Lanzador class >> rolesJugadores [ 
	"Mapeo de la clase de jugador a su descripción."
    ^ Dictionary new
        at: Jugador put: 'Base: Balanceado';
        at: JugadorTanque put: 'Tanque: Mucha vida / - Puntuación';
        at: JugadorFragil put: 'Frágil: + Puntuación / 1 Vida';
        at: JugadorSuertudo put: 'Suertudo: Mejores Tiradas / -Vida';
        at: JugadorSteve put: 'STEVE: Solo hace cuadrados';
        yourself

]

{ #category : #'as yet unclassified' }
Lanzador class >> valoresRoles [ 
	"Genera la lista de Clases reales (los valores) que se devolverán al seleccionar."
    ^ self rolesJugadores keys


]
