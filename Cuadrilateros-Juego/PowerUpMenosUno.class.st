"
Powerup Menosuno
"
Class {
	#name : #PowerUpMenosUno,
	#superclass : #PotenciadorCuadrilateros,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpMenosUno >> activarEn: unJugador juego: unJuego [
    "Agrega la instancia del Potenciador a los efectos activos del jugador."
    unJugador agregarPotenciador: self.
]

{ #category : #'as yet unclassified' }
PowerUpMenosUno >> aplicarModificadorDadoA: unDiccionario [
    "Guarda la regla '-1' en el diccionario para luego ser activada por el dado."
    unDiccionario at: '-1' put: true.
]
