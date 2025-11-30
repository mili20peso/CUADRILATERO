"
Subclase de jugador
--STEVE--
*Tiene la misma vida
*Solo pone figuras cuadradas (base = altura) 
"
Class {
	#name : #JugadorSteve,
	#superclass : #Jugador,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'as yet unclassified' }
JugadorSteve >> tirarDadoCon: unDado [ 
    "Sobreescribe el metodo para forzar que X=Y, solo tiramos el dado una vez."
    | valor |
    
    "Tiramos el dado aplicando los modificadores de efectos."
    valor := unDado generador: self configuracionDado.
    
    "El resultado es un Point (X@Y) donde X e Y son iguales"
    ^ valor @ valor

]

