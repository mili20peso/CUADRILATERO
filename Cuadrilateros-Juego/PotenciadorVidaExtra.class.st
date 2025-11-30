"
Representa al PotenciadorVidaextra 
"
Class {
	#name : #PotenciadorVidaExtra,
	#superclass : #Potenciador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
PotenciadorVidaExtra >> activarEn: unJugador juego: unJuego [
    "1. Aplica el efecto instantáneo (agregar la vida)"
    unJugador agregarVida.
    
    "2. Crucial: Agrega el potenciador a la lista de efectos activos temporalmente, para que la UI lo detecte y muestre el overlay."
    unJugador agregarPotenciador: self. 
]
