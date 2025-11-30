"
Este potenciador al ser recogido genera una figura 1x1 en cualquier lugar del mapa para el jugador que lo obtiene 
"
Class {
	#name : #PotenciadorBloqueAleatorio,
	#superclass : #Potenciador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PotenciadorBloqueAleatorio >> activarEn: unJugador juego: unJuego [ 
    unJuego tablero posicionarBloqueoAleatorioParaJugador: unJugador. 
    unJugador agregarPotenciador: self.

]

