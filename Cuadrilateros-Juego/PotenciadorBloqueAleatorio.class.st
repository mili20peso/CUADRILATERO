"
Representa al PotenciadorBloquealeatorio 
"
Class {
	#name : #PotenciadorBloqueAleatorio,
	#superclass : #Potenciador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PotenciadorBloqueAleatorio >> activarEn: unJugador juego: unJuego [ [
    unJuego tablero posicionarBloqueoAleatorioParaJugador: unJugador. 
    unJugador agregarPotenciador: self.
]
]
