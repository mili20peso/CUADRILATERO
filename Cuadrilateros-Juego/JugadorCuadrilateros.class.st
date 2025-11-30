"
jugador cuadrilatero
"
Class {
	#name : #JugadorCuadrilateros,
	#superclass : #Object,
	#instVars : [
		'id',
		'vidas',
		'areaAbarcada',
		'figurasColocadas',
		'efectosActivos'
	],
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> agregarArea: unEntero [ 
	"Recibe el area de la figura colocada (base * altura) y le suma esa cantidad al total del jugador."
	areaAbarcada := areaAbarcada + unEntero.

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> agregarPotenciador: unPotenciador [ 
	"Agrega un potenciador a la lista de efectos activos. Recibe una instancia subclase de PowerUp."
	efectosActivos add: unPotenciador.

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> agregarVida [ 
	vidas:= vidas + 1
	"Metodo utilizado para el potenciador vida extra"

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> configuracionDado [ 
	"Genera el diccionario con las reglas esperadas por la clase dado.
     Utiliza polimorfismo, delegando la responsabilidad a cada potenciador."
	| config |
	config := Dictionary new.

	efectosActivos do: [ :efecto |

	"Envia el mensaje a los potenciadores, solo los potenciadores que afectan a los dados podran modificar el diccionario."
	efecto aplicarModificadorDadoA: config.
	].
^ config

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> estaVivo [ 
	"Devuelve true si el jugador tiene más de 0 vidas, false si perdió."
	^ vidas > 0

]

{ #category : #accessing }
JugadorCuadrilateros >> id [ 
	"Devuelve el identificador del jugador (1 a 4)"
	^ id

]

{ #category : #accessing }
JugadorCuadrilateros >> id: unObjeto [ 
	"Establece el id del jugador"
	id := unObjeto

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> inicializar [ 
	"Inicializa las variables con los valores por defecto del juego"
	super initialize.
	vidas := 3."Comienzan con 3 vidas"
	areaAbarcada := 0."0 superficie cubierta al inicio"
	efectosActivos := OrderedCollection new. "Lista vacía para guardar potenciadores"
	figurasColocadas := 0. "Ninguna figura colocada"

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> obtenerAreaAbarcada [ 
	"Devuelve el área total cubierta por el jugador (puntaje)"
	^ areaAbarcada

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> obtenerEfectosActivos [ 
     "Devuelve la colección de efectos activos"
   ^ efectosActivos

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> obtenerFigurasColocadas [ 
	"Devuelve la cantidad de figuras colocadas (Sirve para el desempate)."
	^ figurasColocadas

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> obtenerVidas [ 
	"Devuelve la cantidad actual de vidas"
	^ vidas

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> perderVida [ 
	"Resta una vida al jugador. Se invoca cuando el jugador decide saltar turno."
	vidas := vidas - 1.

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> registrarFiguraColocada [ 
	"Incrementa el contador de figuras colocadas exitosamente."
	figurasColocadas := figurasColocadas + 1.

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> tienePotenciador: clasePotenciador [ 
	"Recorre la lista y busca si alguno es del tipo que pedimos. 
	Utiliza isKindOf para buscar la clase particular"
	^ efectosActivos anySatisfy: [ :efecto | efecto isKindOf: clasePotenciador ]

]

{ #category : #'as yet unclassified' }
JugadorCuadrilateros >> tirarDadosCon: unDado [ 
	"Usa el dado para generar la tirada con la configuración de efectos actuales."
	^ unDado tirar: self configuracionDado

]
