"
Ventana juego
"
Class {
	#name : #VentanaJuego,
	#superclass : #SystemWindow,
	#instVars : [
		'juego',
		'morfTablero',
		'panelInformacion',
		'etiquetaDados',
		'etiquetaMensaje',
		'tiradaDadoActual',
		'tamanioCelda',
		'morfFantasma',
		'morfEstadisticasJugadores'
	],
	#category : #'Cuadrilateros-UI'
}

{ #category : #'as yet unclassified' }
VentanaJuego >> accionSaltarTurno [ 
    "Lógica al presionar el botón de saltar turno"
    
    juego juegoTerminado ifTrue: [ ^ self ].
    
    juego jugadorActual perderVida.
    etiquetaMensaje contents: 'Te rendiste. Pierdes 1 vida.'.
    
    "Pasamos turno y actualizamos todo"
    juego siguienteTurno.
    self tirarDadoParaSiguienteTurno.
    self actualizarVisualizacion.
    self verificarVictoria.

]

{ #category : #'as yet unclassified' }
VentanaJuego >> actualizarPosicionFantasma [ 
    "Busca la posición actual del mouse y actualiza el fantasma"
    | posicionMouseGlobal puntoLocal columna fila objetivoX objetivoY |
    
    juego juegoTerminado ifTrue: [ ^ self ].
    morfFantasma ifNil: [ ^ self ].
    
    "1. Obtenemos la posición del mouse directamente de la 'Mano' activa"
    posicionMouseGlobal := self activeHand position.
    
    "2. Solo movemos si el mouse está DENTRO del tablero"
    (morfTablero containsPoint: posicionMouseGlobal) ifFalse: [ ^ self ].
    
    "3. Matemática de coordenadas (igual que antes)"
    puntoLocal := posicionMouseGlobal - morfTablero position.
    
    columna := (puntoLocal x / tamanioCelda) floor.
    fila := (puntoLocal y / tamanioCelda) floor.
    
    objetivoX := columna * tamanioCelda.
    objetivoY := fila * tamanioCelda.
    
    "4. Mover el fantasma"
    morfFantasma position: morfTablero position + (objetivoX @ objetivoY).

]

{ #category : #'as yet unclassified' }
VentanaJuego >> actualizarTamanioFantasma [ 
    "Si el fantasma existe, actualizamos su tamaño (Ancho de dados * celda)"
    morfFantasma ifNotNil: [
        morfFantasma extent: (tiradaDadoActual x * tamanioCelda) @ (tiradaDadoActual y * tamanioCelda).
    ].

]

{ #category : #'as yet unclassified' }
VentanaJuego >> actualizarVisualizacion [ 
    | contenido cadenaJugador |
    "Eliminamos filas, columnas y celda que no se usaban"
    
    "Actualizar cada celda"
    morfTablero submorphs do: [ :m |
        (m isKindOf: MorfCeldaJuego) ifTrue: [
            contenido := juego tablero contenidoEn: (m columna @ m fila).
            m actualizarEstadoDesde: contenido.
        ].
    ].

    "--- NUEVO: Actualizar Panel de Estadísticas de Jugadores ---"
    morfEstadisticasJugadores removeAllMorphs.
    juego jugadores do: [ :j |
        cadenaJugador := String streamContents: [ :flujo |
            flujo 
                nextPutAll: 'JUGADOR ', j identificador asString;
                nextPutAll: ' (';
                nextPutAll: j vidas asString;
                nextPutAll: ' Vidas) | Área: ';
                "Usamos printShowingDecimalPlaces para mostrar correctamente puntajes decimales"
                nextPutAll: (j areaCubierta printShowingDecimalPlaces: 2). 
        ].
        morfEstadisticasJugadores addMorph: (StringMorph new contents: cadenaJugador).
    ].
    "----------------------------------------------------------"

    "Actualizar Etiquetas de Turno"
    etiquetaDados contents: 'JUGADOR ', juego jugadorActual identificador asString, 
                        ' |
Dados: ', tiradaDadoActual x asString, ' x ', tiradaDadoActual y asString.

]

{ #category : #'as yet unclassified' }
VentanaJuego >> celdaClicada: unEvento desde: unaCelda [ 
    | puntoClicado exito jugador |
    
    juego juegoTerminado ifTrue: [ ^ self ].
    puntoClicado := unaCelda columna @ unaCelda fila.
    
    jugador := juego jugadorActual. 
    exito := juego intentarPosicionarForma: tiradaDadoActual en: puntoClicado.
    
    exito ifTrue: [
        
        "*** LLAMADA AL OVERLAY (Pausa y efecto visual) ***"
        self mostrarOverlayPotenciadorPara: jugador.
        
        etiquetaMensaje contents: '¡Jugada exitosa! Turno siguiente.'.
        
        self actualizarVisualizacion. 
        self world displayWorld. 
        
        "*** LIMPIEZA SELECTIVA: Se eliminan Potenciadores instantáneos del jugador actual ***"
        jugador efectosActivos removeAllSuchThat: [ :pot |
            (pot isKindOf: PotenciadorVidaExtra) or: [ pot isKindOf: PotenciadorBloqueAleatorio ]
        ].
        
        juego siguienteTurno. 
        
        self tirarDadoParaSiguienteTurno.
        self actualizarVisualizacion. 
        self verificarVictoria.
    ] ifFalse: [
        etiquetaMensaje contents: 'Movimiento INVÁLIDO.
        Revisa adyacencia o espacio.'. 
        ].
 

]

{ #category : #'as yet unclassified' }
VentanaJuego >> construirInterfaz [ 
    | contenedorPrincipal botonSaltar |
    
    contenedorPrincipal := Morph new 
        layoutPolicy: TableLayout new;
        listDirection: #leftToRight;
        color: Color transparent;
        hResizing: #spaceFill;
        vResizing: #spaceFill;
        cellInset: 10.
        
    self addMorph: contenedorPrincipal frame: (0@0 extent: 1@1).
    "1. Tablero"
    morfTablero := Morph new
        color: Color darkGray;
        borderColor: Color black;
        borderWidth: 2.
        
    "2. Panel de Información"
    panelInformacion := Morph new
        layoutPolicy: TableLayout new;
        listDirection: #topToBottom;
        color: Color white;
        width: 250;
        vResizing: #spaceFill;
        cellInset: 10;
        layoutInset: 10.
        
    etiquetaDados := StringMorph new contents: 'DADOS: ...';
        font: (TextStyle default fontOfSize: 18).
    etiquetaMensaje := TextMorph new contents: 'Bienvenido'; extent: 200@100; wrapFlag: true.
    panelInformacion addMorph: (StringMorph new contents: 'ESTADO DEL JUEGO'; font: (TextStyle default fontOfSize: 14)).
    panelInformacion addMorph: etiquetaDados.
    panelInformacion addMorph: etiquetaMensaje.

    "--- NUEVO: Panel de Estadísticas de Jugadores ---"
    panelInformacion addMorph: (StringMorph new contents: 'ESTADÍSTICAS'; font: (TextStyle default fontOfSize: 14)). 
    morfEstadisticasJugadores := Morph new
        layoutPolicy: TableLayout new;
        listDirection: #topToBottom;
        color: Color transparent;
        hResizing: #spaceFill;
        vResizing: #shrinkWrap;
        cellInset: 5;
        yourself.
    panelInformacion addMorph: morfEstadisticasJugadores.
    "-------------------------------------------------"

    "--- NUEVO: BOTÓN DE SALTAR TURNO ---"
    botonSaltar := SimpleButtonMorph new.
    botonSaltar label: 'SALTAR TURNO (-1 Vida)'.
    botonSaltar color: (Color red alpha: 0.7).
    botonSaltar target: self.           "El botón le avisa a la Ventana"
    botonSaltar actionSelector: #accionSaltarTurno.
    "Llama a este método"
    botonSaltar extent: 200@40.
    
    panelInformacion addMorph: botonSaltar.
    "------------------------------------"
    
    contenedorPrincipal addMorph: morfTablero.
    contenedorPrincipal addMorph: panelInformacion.
    
    self crearCeldasCuadricula.

]

{ #category : #'as yet unclassified' }
VentanaJuego >> crearCeldasCuadricula [ 
    | filas columnas celda |
    filas := juego tablero filas.
    columnas := juego tablero columnas.
    
    morfTablero removeAllMorphs.
    morfTablero extent: (columnas * tamanioCelda) @ (filas * tamanioCelda).
    
    "1. Crear las celdas normales"
    1 to: filas do: [ :f |
        1 to: columnas do: [ :c |
            celda := MorfCeldaJuego new.
            celda extent: tamanioCelda@tamanioCelda.
            celda position: morfTablero position + (((c - 1) * tamanioCelda) @ ((f - 1) * tamanioCelda)).
            celda fila: f columna: c.
            celda on: #mouseDown send: #celdaClicada:desde: to: self.
            morfTablero addMorph: celda.
        ].
    ].


    "3. Crear el Fantasma visual"
    morfFantasma := BorderedMorph new.
    morfFantasma color: (Color purple alpha: 0.5). "Semi-transparente"
    morfFantasma borderColor: Color purple.
    morfFantasma borderWidth: 2.
    morfFantasma lock. "CRUCIAL: Hace que los clicks atraviesen el fantasma y lleguen a la celda"
    
    morfTablero addMorph: morfFantasma.
    
    "Ajustar tamaño inicial"
    self actualizarTamanioFantasma.


]

{ #category : #'as yet unclassified' }
VentanaJuego >> inicializarConJuego: unJuego [ 
    self initialize.
    juego := unJuego.
    tamanioCelda := 25. "Tamaño en pixeles de cada celda"
    
    self setLabel: 'Cuadriláteros - Pharo Game'.
    self extent: 800@650.
    
    "Configuramos el dado inicial"
    tiradaDadoActual := juego tirarDadoParaJugadorActual.
    
    self construirInterfaz.
    self actualizarVisualizacion.

]

{ #category : #'as yet unclassified' }
VentanaJuego >> mostrarOverlayPotenciadorPara: unJugador [  
    "Muestra un overlay grande y blanco con los Potenciadores recién adquiridos, y pausa la ejecución."
    | potenciadoresAdquiridos textoMensaje colorJugador morfOverlay morfTexto rectanguloObjetivo |
    
    unJugador efectosActivos ifEmpty: [ ^ self ].
    
    "1. Obtener la lista de Potenciadores y generar el texto grande"
    potenciadoresAdquiridos := unJugador efectosActivos.
    
    "Usamos String streamContents: para compatibilidad total con el entorno"
    textoMensaje := String streamContents: [ :flujo |
        potenciadoresAdquiridos withIndexDo: [ :pot :i |
            flujo nextPutAll: (self textoParaPotenciador: pot) , ' (Obtenido)'.
            i < potenciadoresAdquiridos size ifTrue: [ flujo cr ] 
        ]
    ].
    
    "Obtenemos el color del jugador para el texto"
    colorJugador := MorfCeldaJuego colorParaIdentificadorJugador: unJugador identificador. 
    
    morfTexto := TextMorph new 
        contents: '¡POTENCIADOR ADQUIRIDO!' , Character cr asString , textoMensaje;
        font: (TextStyle default fontOfSize: 36);
        color: colorJugador; 
        yourself.
        
    "2. Crear el Overlay: Calculamos el rectángulo blanco centrado"
    rectanguloObjetivo := (self bounds center - (200@150)) extent: (400@300).
    
    morfOverlay := Morph new
        color: Color white;
        borderWidth: 2; 
        borderColor: Color black;
        yourself.
        
    "3. Asignar Bounds y Centrar"
    morfOverlay bounds: rectanguloObjetivo. 
    
    morfOverlay addMorph: morfTexto.
    morfTexto center: morfOverlay bounds center.
    
    self addMorph: morfOverlay.
    self world displayWorld. 
    
    "4. Pausar el hilo de ejecución por 1.5 segundos"
    (Delay forSeconds: 1.5) wait.
    
    "5. Eliminar el overlay"
    self removeMorph: morfOverlay.
    self world displayWorld.
    
    self panelInformacion changed.

]

{ #category : #accessing }
VentanaJuego >> panelInformacion [ 
    "Devuelve el panel de información (Morph) para su manipulación."
    ^ panelInformacion

]

{ #category : #'stepping and presenter' }
VentanaJuego >> step [ 
    "En cada ciclo del reloj, actualizamos la posición del fantasma"
    self actualizarPosicionFantasma.

]

{ #category : #stepping }
VentanaJuego >> stepTime [ 
    ^ 20


]

{ #category : #'as yet unclassified' }
VentanaJuego >> textoParaPotenciador: unPotenciador [  
    "Retorna una descripción en texto para un Potenciador activo."
    (unPotenciador isKindOf: PotenciadorMasUno) ifTrue: [ ^ '¡Más 1 en siguiente tirada! :) ' ].
    (unPotenciador isKindOf: PotenciadorMenosUno) ifTrue: [ ^ '¡Menos 1 en siguiente tirada! :O' ].
    (unPotenciador isKindOf: PotenciadorTiradaBaja) ifTrue: [ ^ '¡Próxima tirada obtendrá lowroll!' ].
    (unPotenciador isKindOf: PotenciadorTiradaAlta) ifTrue: [ ^ 'Próxima tirada obtendrá high!' ].
    (unPotenciador isKindOf: PotenciadorBloqueAleatorio) ifTrue: [ ^ '¡Bloque Aleatorio Extra!' ].
    (unPotenciador isKindOf: PotenciadorVidaExtra) ifTrue: [ ^ '¡+1 Vida!' ].
    ^ 'Potenciador Desconocido'

]

{ #category : #'as yet unclassified' }
VentanaJuego >> tirarDadoParaSiguienteTurno [ 
	juego juegoTerminado
		ifTrue: [ ^ self ].
	tiradaDadoActual := juego tirarDadoParaJugadorActual.
	self actualizarTamanioFantasma	"ajusta el tamaño de la figura fantasma"

]

{ #category : #'as yet unclassified' }
VentanaJuego >> verificarVictoria [ 
	| ganador colorGanador morfVictoria texto idGanador |
	juego juegoTerminado
		ifFalse: [ ^ self ].
        
	ganador := juego obtenerGanador.
    idGanador := ganador identificador.
    
    "Llamada al método de CLASE en MorfCeldaJuego para obtener el color de forma centralizada"
	colorGanador := MorfCeldaJuego colorParaIdentificadorJugador: idGanador. 
    
    "1. Actualizar etiquetas inferiores (GAME OVER)"
    etiquetaMensaje contents: 'GAME OVER. Ganador: Jugador ', idGanador asString.
    etiquetaDados contents: '---'.
    
    "2. Crear el Morph de victoria que cubrirá toda la ventana"
    morfVictoria := Morph new
        color: (Color black alpha: 0.8); "Fondo oscuro semi-transparente"
        bounds: self bounds; "Abarca toda la ventana"
        yourself.

    "3. Texto grande y coloreado"
    texto := 'El GANADOR es el JUGADOR ', idGanador asString.

    morfVictoria addMorph: (TextMorph new 
        contents: texto;
        font: (TextStyle default fontOfSize: 48); "Fuente grande para prominencia"
        color: colorGanador; "Color del jugador ganador"
        yourself).
        
    "4. Centrar el texto en la pantalla y añadir el morph a la ventana"
    morfVictoria submorphs first center: morfVictoria center.
    self addMorph: morfVictoria.


]

{ #category : #stepping }
VentanaJuego >> wantsSteps [ 
    ^ true

]
