"
Powerup Bloqueo
"
Class {
	#name : #PowerUpBloqueAleatorio,
	#superclass : #PotenciadorCuadrilateros,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PowerUpBloqueAleatorio >> activarEn: unJugador juego: unJuego [
    unJuego tablero colocarBloqueAleatorioPara: unJugador. 
    unJugador agregarPotenciador: self.
]

{ #category : #'as yet unclassified' }
PowerUpBloqueAleatorio >> esEfectoInstantaneo [
    "Permite que la interfaz de usuario sepa que este PowerUp debe eliminarse inmediatamente después de su activación."
    ^ true
]
