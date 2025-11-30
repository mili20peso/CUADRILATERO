"
Powerup Tiradabaja
"
Class {
	#name : #PowerUpTiradaBaja,
	#superclass : #PotenciadorCuadrilateros,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpTiradaBaja >> activarEn: unJugador juego: unJuego [
    "Agrega la instancia del Potenciador a los efectos activos del jugador."
    unJugador agregarPotenciador: self.
]

{ #category : #'as yet unclassified' }
PowerUpTiradaBaja >> aplicarModificadorDadoA: unDiccionario [
    "Guarda la regla '<3' en el diccionario para luego ser activada por el dado."
    unDiccionario at: '<3' put: true.
]
