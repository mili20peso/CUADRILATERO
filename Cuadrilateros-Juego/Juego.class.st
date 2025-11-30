"
Clase contenedora del juego, controla el flujo del mismo y contiene las clases principales (1 a 4 jugadores, tablero)
"
Class {
	#name : #Juego,
	#superclass : #Object,
	#instVars : [
		'tablero',
		'jugadores',
		'dado',
		'indiceJugadorActual',
		'juegoTerminado'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
Juego >> inicializarConClasesJugadores: clasesJugadores tamanioTablero: tamanio [ 
	| j posicionInicial |
	self initialize.
	tablero := TableroJuego new.
	tablero inicializarTamanio: tamanio.
	dado := Dado new.
	juegoTerminado := false.
	indiceJugadorActual := 1.
	jugadores := OrderedCollection new.
	
	clasesJugadores
		withIndexDo: [ :claseJugador :i | 
			j := claseJugador new.
			j identificador: i.
			jugadores add: j ].
		
		"Empieza a colocar a cada jugador en una esquina segun la cantidad que exista."
	jugadores size >= 1
		ifTrue: [ tablero
				posicionarForma: 1 @ 1
				ancho: 1
				alto: 1
				jugador: (jugadores at: 1) ].
	jugadores size >= 2
		ifTrue: [ posicionInicial := tamanio @ tamanio.
			tablero
				posicionarForma: posicionInicial
				ancho: 1
				alto: 1
				jugador: (jugadores at: 2) ].
	jugadores size >= 3
		ifTrue: [ posicionInicial := tamanio @ 1.
			tablero
				posicionarForma: posicionInicial
				ancho: 1
				alto: 1
				jugador: (jugadores at: 3) ].
	jugadores size = 4
		ifFalse: [ ^ self ].
	posicionInicial := 1 @ tamanio.
	tablero
		posicionarForma: posicionInicial
		ancho: 1
		alto: 1
		jugador: (jugadores at: 4)

]

{ #category : #'as yet unclassified' }
Juego >> intentarPosicionarForma: dimensionesPunto en: puntoOrigen [  
    "Intenta colocar la figura. Retorna booleano si pudo o no"
    | jugador exito potenciadoresAdquiridos | 
    jugador := self jugadorActual.
    
    exito := tablero puedePosicionarForma: puntoOrigen 
                     ancho: dimensionesPunto x 
                     alto: dimensionesPunto y 
                     jugador: jugador.

    exito ifTrue: [ 
        "Capturamos los Potenciadores y marcamos el tablero"
        potenciadoresAdquiridos := tablero posicionarForma: puntoOrigen 
              ancho: dimensionesPunto x 
              alto: dimensionesPunto y 
              jugador: jugador. 

        "Activamos Potenciadores adquiridos, añadiéndolos a efectosActivos (si son de dado) o aplicando su efecto instantáneo"
        potenciadoresAdquiridos do: [ :potenciador |
            potenciador activarEn: jugador juego: self. 
        ].].
        

    ^ exito

]

{ #category : #accessing }
Juego >> juegoTerminado [ 
    ^ juegoTerminado


]

{ #category : #'as yet unclassified' }
Juego >> jugadorActual [ 
    "Devuelve el Jugador al que le toca ahora"
    ^ jugadores at: indiceJugadorActual.


]

{ #category : #'as yet unclassified' }
Juego >> jugadorNoPuedeMoverse [ 
    "El jugador pierde una vida y se pasa el turno"
    self jugadorActual perderVida.
    self siguienteTurno.

]

{ #category : #accessing }
Juego >> jugadores [ 
    ^ jugadores

]

{ #category : #'as yet unclassified' }
Juego >> obtenerGanador [ 
    "Realiza un ordenamiento para poner como primer elemento el jugador con mas puntos."
    ^ (jugadores asSortedCollection: [ :a :b |
        (a areaCubierta > b areaCubierta) or: [
            (a areaCubierta = b areaCubierta) and: [ a figurasColocadas > b figurasColocadas ]
        ] "Si tienen los mismos puntos ordena segun figuras colocadas como desempate."
    ]) asArray first. "asArray para que entienda first"


]

{ #category : #'as yet unclassified' }
Juego >> siguienteTurno [ 
    "Avanza al siguiente jugador, saltando a los muertos y a los BLOQUEADOS"
    | siguienteJugador |
    
    "1.Verificar si el juego terminó"
    (jugadores select: [:j | j estaVivo]) isEmpty ifTrue: [ 
        juegoTerminado := true. 
        ^ self 
    ].

    "2. Avanzar el índice"
    indiceJugadorActual := (indiceJugadorActual \\ jugadores size) + 1.
    siguienteJugador := self jugadorActual.

    "3. CASO A: El jugador está MUERTO"
    siguienteJugador estaVivo ifFalse: [ 
        ^ self siguienteTurno "Saltamos al siguiente"
    ].

    "3. CASO B: Jugador válido. Comienza su turno."
    
    siguienteJugador registrarTurno.
    
    (3 atRandom) = 1 ifTrue: [ tablero generarPotenciadorAleatorio ].
	"Generar Potenciador en el mapa (33%)"

    "4. Iniciar turno del nuevo jugador"
    siguienteJugador registrarTurno.

]

{ #category : #accessing }
Juego >> tablero [ 
    ^ tablero

]

{ #category : #'as yet unclassified' }
Juego >> tirarDadoParaJugadorActual [ 
    | jugador resultado |
    jugador := self jugadorActual.
    
    "Ejecuta la tirada, si tiene powerups los usa."
    resultado := jugador tirarDadoCon: dado. 
    
    "Limpieza de powerups."
    jugador efectosActivos removeAll.	
    ^ resultado

]

