"
Representa al Jugador 
"
Class {
	#name : #Jugador,
	#superclass : #Object,
	#instVars : [
		'identificador',
		'vidas',
		'areaCubierta',
		'figurasColocadas',
		'efectosActivos'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
Jugador >> agregarArea: unEntero [ 
    "Recibe el area de la figura colocada (base * altura) y le suma esa cantidad al total del jugador."
    areaCubierta := areaCubierta + unEntero.

]

{ #category : #'as yet unclassified' }
Jugador >> agregarPotenciador: unPotenciador [ 
    "Agrega un potenciador a la lista de efectos activos. Recibe una instancia subclase de Potenciador."
    efectosActivos add: unPotenciador.

]

{ #category : #'as yet unclassified' }
Jugador >> agregarVida [ 
vidas:= vidas + 1
"Metodo utilizado para el potenciador vida extra"

]

{ #category : #accessing }
Jugador >> areaCubierta [ 
    "Devuelve el área total cubierta por el jugador (puntaje)"
    ^ areaCubierta

]

{ #category : #'as yet unclassified' }
Jugador >> configuracionDado [ 
    "Genera el diccionario con las reglas esperadas por la clase dado.
     Utiliza polimorfismo, delegando la responsabilidad a cada potenciador."
    | configuracion |
    configuracion := Dictionary new.
    
    efectosActivos do: [ :efecto |
        "Envia el mensaje a los potenciadores, solo los potenciadores que afectan a los dados podran modificar el diccionario."
        efecto aplicarModificadorDadoA: configuracion.
    ].
    ^ configuracion

]

{ #category : #accessing }
Jugador >> efectosActivos [ 
    "Devuelve la colección de efectos activos"
    ^ efectosActivos

]

{ #category : #'as yet unclassified' }
Jugador >> estaVivo [ 
    "Devuelve true si el jugador tiene más de 0 vidas, false si perdió."
    ^ vidas > 0

]

{ #category : #accessing }
Jugador >> figurasColocadas [ 
    "Devuelve la cantidad de figuras colocadas (Sirve para el desempate)."
    ^ figurasColocadas

]

{ #category : #accessing }
Jugador >> identificador [ 
    "Devuelve el identificador del jugador (1 a 4)"
    ^ identificador

]

{ #category : #accessing }
Jugador >> identificador: unObjeto [ 
    "Establece el id del jugador"
    identificador := unObjeto

]

{ #category : #initialization }
Jugador >> initialize [ 
    "Inicializa las variables con los valores por defecto del juego"
    super initialize.
    vidas := 3.              "Comienzan con 3 vidas"
    areaCubierta := 0.        "0 superficie cubierta al inicio"
    efectosActivos := OrderedCollection new. "Lista vacía para guardar potenciadores"
	 figurasColocadas := 0. "Ninguna figura colocada"


]

{ #category : #'as yet unclassified' }
Jugador >> perderVida [ 
    "Resta una vida al jugador. Se invoca cuando el jugador decide saltar turno."
    vidas := vidas - 1.

]

{ #category : #'as yet unclassified' }
Jugador >> registrarFiguraColocada [ 
    "Incrementa el contador de figuras colocadas exitosamente."
    figurasColocadas := figurasColocadas + 1.

]

{ #category : #'as yet unclassified' }
Jugador >> registrarTurno [ 
    "Placeholder para registrar que comenzó un turno (puede expandirse después)"

]

{ #category : #'as yet unclassified' }
Jugador >> tienePotenciador: unaClasePotenciador [ 
    "Recorre la lista y busca si alguno es del tipo que pedimos. 
		Utiliza isKindOf para buscar la clase particular"
    ^ efectosActivos anySatisfy: [ :efecto | efecto isKindOf: unaClasePotenciador ]

]

{ #category : #'as yet unclassified' }
Jugador >> tirarDadoCon: unDado [ 
    "Usa el dado para generar la tirada con la configuración de efectos actuales."
    ^ unDado tirar: self configuracionDado

]

{ #category : #accessing }
Jugador >> vidas [ 
    "Devuelve la cantidad actual de vidas"
    ^ vidas

]
