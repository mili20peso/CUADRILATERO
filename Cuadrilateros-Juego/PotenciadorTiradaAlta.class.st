"
Fuerza a que la proxima tirada no de numeros menores a 3 
"
Class {
	#name : #PotenciadorTiradaAlta,
	#superclass : #Potenciador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PotenciadorTiradaAlta >> activarEn: unJugador juego: unJuego [ 
    "Agrega la instancia del Potenciador a los efectos activos del jugador."
    unJugador agregarPotenciador: self.


]

{ #category : #'as yet unclassified' }
PotenciadorTiradaAlta >> aplicarModificadorDadoA: unDiccionario [ 
    "Guarda la regla '>3' en el diccionario para luego ser activada por el dado."
    unDiccionario at: '>3' put: true.

]

