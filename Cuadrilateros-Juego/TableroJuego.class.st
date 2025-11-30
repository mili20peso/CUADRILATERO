"
Representa al Tablerojuego
"
Class {
	#name : #TableroJuego,
	#superclass : #Object,
	#instVars : [
		'cuadricula',
		'filas',
		'columnas'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #accessing }
TableroJuego >> columnas [ 
    "Devuelve la cantidad de columnas del tablero"
    ^ columnas

]

{ #category : #'as yet unclassified' }
TableroJuego >> contenidoEn: unPunto [ 
    "Devuelve el contenido de la celda: nil, un ID de jugador o un Potenciador"
    (self esCoordenadaValida: unPunto) 
        ifTrue: [ ^ cuadricula at: unPunto y at: unPunto x ] 
        ifFalse: [ ^ nil ].

]

{ #category : #'as yet unclassified' }
TableroJuego >> esCoordenadaValida: unPunto [ 
    "Verifica que el punto x y esté dentro del tablero"
    ^ (unPunto x between: 1 and: columnas) and: [ unPunto y between: 1 and: filas ]

]

{ #category : #accessing }
TableroJuego >> filas [ 
    "Devuelve la cantidad de filas del tablero"
    ^ filas

]

{ #category : #'as yet unclassified' }
TableroJuego >> generarPotenciadorAleatorio [ 
    "Intenta colocar un Potenciador en una celda vacía"
    | f c intentos maximoIntentos |

    intentos := 0.
    maximoIntentos := 20. "Para evitar bucles infinitos, establecemos un maximo de intentos"
    
    [ intentos < maximoIntentos ] whileTrue: [
        f := (1 to: filas) atRandom.
        c := (1 to: columnas) atRandom.
        
        (cuadricula at: f at: c) isNil ifTrue: [
            "Si está vacío, ponemos un Potenciador random"
            cuadricula at: f at: c put: (Potenciador subclaseAleatoria new).
            ^ self "Salimos del método"
        ].
        intentos := intentos + 1.
    ].

]

{ #category : #'as yet unclassified' }
TableroJuego >> inicializarTamanio: unEntero [ 
    "Crea un tablero cuadrado de el valor de entrada tanto de alto como ancho.
     Puede ser 16, 20 o 24 según la eleccion."
    
    self initialize.
    filas := unEntero.
    columnas := unEntero.
    
    "Creamos una Matriz vacía"
    cuadricula := Array2D new: filas tabulate: [ :f :c | nil ].

]

{ #category : #'as yet unclassified' }
TableroJuego >> posicionarBloqueoAleatorioParaJugador: unJugador [ 
    "Busca una celda vacía de forma aleatoria y se la asigna al jugador.
     Si el azar falla muchas veces, busca linealmente."
    
    | x y intentos maximoIntentos |
    
    maximoIntentos := 50. "Intentamos 50 veces encontrar un lugar al azar"
    intentos := 0.
    
    "INTENTO ALEATORIO"
    [ intentos < maximoIntentos ] whileTrue: [
        x := (1 to: columnas) atRandom.
        y := (1 to: filas) atRandom.
        
        "Si la celda es nil, la ocupamos y terminamos"
        (cuadricula at: y at: x) isNil ifTrue: [
            cuadricula at: y at: x put: unJugador identificador.
            unJugador agregarArea: 1.
            ^ self "Salimos del método"
        ].
        
        intentos := intentos + 1.
    ].

    "INTENTO LINEAL"
    "Si el azar falla, para garantizar que el poder funcione, recorremos todo linealmente."
    
    1 to: filas do: [ :f |
        1 to: columnas do: [ :c |
            (cuadricula at: f at: c) isNil ifTrue: [
                cuadricula at: f at: c put: unJugador identificador.
                unJugador agregarArea: 1.
                ^ self "Encontrado por búsqueda lineal"
            ].
        ].
    ].
    
    "Si llega hasta esta instancia, el tablero está 100% lleno y no se hace nada."

]

{ #category : #'as yet unclassified' }
TableroJuego >> posicionarForma: puntoOrigen ancho: ancho alto: alto jugador: unJugador [  
    "Dibuja la figura en el tablero, consume potenciadores y actualiza el puntaje"
    
    | inicioX inicioY finX finY contenidoCelda potenciadoresAdquiridos |
    potenciadoresAdquiridos := OrderedCollection new. "Lista para guardar potenciadores"
    inicioX := puntoOrigen x.
    inicioY := puntoOrigen y.
    finX := inicioX + ancho - 1.
    finY := inicioY + alto - 1.
    
    inicioX to: finX do: [ :x |
        inicioY to: finY do: [ :y |
            contenidoCelda := cuadricula at: y at: x.
            
            "Nill no puede procesar isKindOf, por lo que creamos una guarda"
            contenidoCelda ifNotNil: [ 
                (contenidoCelda isKindOf: Potenciador) ifTrue: [
                    potenciadoresAdquiridos add: contenidoCelda.
                ]
            ].
            
            "Marcamos la celda con el ID del jugador"
            cuadricula at: y at: x put: unJugador identificador.
        ].
    ].

    unJugador agregarArea: (ancho * alto).
    unJugador registrarFiguraColocada.

    ^ potenciadoresAdquiridos "Devolvemos los potenciadores encontrados"


]

{ #category : #'as yet unclassified' }
TableroJuego >> puedePosicionarForma: puntoOrigen ancho: ancho alto: alto jugador: unJugador [ 
    "Valida límites, superposición y adyacencia"
    
    | inicioX inicioY finX finY contenidoCelda |
    inicioX := puntoOrigen x.
    inicioY := puntoOrigen y.
    finX := inicioX + ancho - 1.
    finY := inicioY + alto - 1.

    "Validar Límites"
    ((self esCoordenadaValida: puntoOrigen) and: [ self esCoordenadaValida: finX@finY ]) 
        ifFalse: [ ^ false ].

    "Validar Superposición"  

    inicioX to: finX do: [ :x |
        inicioY to: finY do: [ :y |
            contenidoCelda := cuadricula at: y at: x.
            
            contenidoCelda ifNotNil: [
                
                "Si es un Potenciador, siempre se puede pisar"
                (contenidoCelda isKindOf: Potenciador) 
                    ifFalse: [
                        "Si NO es un Potenciador, esta ocupado."
                         ^ false ]
                    ].
            ].
        ].

    "Validar Adyacencia"
    ^ self verificarAdyacenciaPara: puntoOrigen ancho: ancho alto: alto jugador: unJugador.

]

{ #category : #'as yet unclassified' }
TableroJuego >> verificarAdyacenciaPara: puntoOrigen ancho: ancho alto: alto jugador: unJugador [ 
    "Revisa si existe adyacencia entre las figuras del jugador y esta nueva figura."
    
    | inicioX inicioY finX finY vecinos |
    inicioX := puntoOrigen x.
    inicioY := puntoOrigen y.
    finX := inicioX + ancho - 1.
    finY := inicioY + alto - 1.


    "Recorremos toda la figura (no es 100% eficiente pero es poco el trabajo extra)"
    inicioX to: finX do: [ :x |
        inicioY to: finY do: [ :y |
            "Para cada celda, miramos sus 4 vecinos (Arriba, Abajo, Izq, Der)"
            vecinos := { (x@y) + (0@1) . (x@y) - (0@1) . (x@y) + (1@0) . (x@y) - (1@0) }.
            
            vecinos do: [ :n |
                (self esCoordenadaValida: n) ifTrue: [
                    "Si un vecino tiene el ID del jugador, es válido"
                    ((self contenidoEn: n) = unJugador identificador) ifTrue: [ ^ true ].
						  "Con encontrar uno sale directamente devolviendo true"
                ].
            ].
        ].
    ].
    ^ false

]
