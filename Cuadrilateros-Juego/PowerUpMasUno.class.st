"
Powerup Masuno
"
Class {
	#name : #PowerUpMasUno,
	#superclass : #PotenciadorCuadrilateros,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpMasUno >> activarEn: unJugador juego: unJuego [
    "Agrega la instancia del Potenciador a los efectos activos del jugador."
    unJugador agregarPotenciador: self.
]

{ #category : #'as yet unclassified' }
PowerUpMasUno >> aplicarModificadorDadoA: unDiccionario [
    "Guarda la regla '+1' en el diccionario para luego ser activada por el dado."
    unDiccionario at: '+1' put: true.
]
