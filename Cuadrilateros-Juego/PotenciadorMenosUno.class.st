"
Resta -1 al numero recibido por los dados en la proxima tirada 
"
Class {
	#name : #PotenciadorMenosUno,
	#superclass : #Potenciador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PotenciadorMenosUno >> activarEn: unJugador juego: unJuego [ 
    "Agrega la instancia del Potenciador a los efectos activos del jugador."
    unJugador agregarPotenciador: self.

]

{ #category : #'as yet unclassified' }
PotenciadorMenosUno >> aplicarModificadorDadoA: unDiccionario [ 
    "Guarda la regla '-1' en el diccionario para luego ser activada por el dado."
    unDiccionario at: '-1' put: true.

]

