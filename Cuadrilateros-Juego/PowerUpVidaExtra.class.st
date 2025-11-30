"
Powerup Vidaextra
"
Class {
	#name : #PowerUpVidaExtra,
	#superclass : #PotenciadorCuadrilateros,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpVidaExtra >> activarEn: unJugador juego: unJuego [
    unJugador agregarVida.
]

{ #category : #'as yet unclassified' }
PowerUpVidaExtra >> esEfectoInstantaneo [
    "Permite que la interfaz de usuario sepa que este PowerUp debe eliminarse inmediatamente después de su activación."
    ^ true
]
