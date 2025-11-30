"
Representa al PotenciadorTiradabaja 
"
Class {
	#name : #PotenciadorTiradaBaja,
	#superclass : #Potenciador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PotenciadorTiradaBaja >> activarEn: unJugador juego: unJuego [ 
    "Agrega la instancia del Potenciador a los efectos activos del jugador."
    unJugador agregarPotenciador: self.

]

{ #category : #'as yet unclassified' }
PotenciadorTiradaBaja >> aplicarModificadorDadoA: unDiccionario [ 
    "Guarda la regla '<3' en el diccionario para luego ser activada por el dado."
    unDiccionario at: '<3' put: true.

]
