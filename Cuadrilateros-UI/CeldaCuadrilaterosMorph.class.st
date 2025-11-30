"
celdacuadrilateros
"
Class {
	#name : #CeldaCuadrilaterosMorph,
	#superclass : #BorderedMorph,
	#instVars : [
		'fila',
		'columna'
	],
	#category : #'Cuadrilateros-UI'
}

{ #category : #'as yet unclassified' }
CeldaCuadrilaterosMorph >> actualizarEstadoDesde: unValor [
    "Actualiza la visualización de la celda según el contenido del tablero"
    
    "--- CORRECCIÓN ---"
    self removeAllMorphs.
    "------------------"
    
    "1. Caso Vacío"
    unValor isNil ifTrue: [ 
        self color: Color white.
        ^ self 
    ].
    
    "2. Caso Jugador (Número)"
    unValor isNumber ifTrue: [ 
        self color: (self class colorParaJugadorId: unValor). "Llamada al método de CLASE"
        ^ self 
    ].
    
    "3. Caso Potenciador"
    (unValor isKindOf: PotenciadorCuadrilateros) ifFalse: [ ^ self ].
    
    "Dibujar Potenciador"
    self color: Color lightGray.
    self addMorph: (StringMorph new
                contents: (self iconoParaPowerUp: unValor);
                color: Color black;
                yourself).
    
    "Centrar el ícono recién agregado"
    self submorphs notEmpty ifTrue: [ 
        self submorphs first center: self center]
]

{ #category : #'as yet unclassified' }
CeldaCuadrilaterosMorph >> colorParaJugadorId: unId [
    "Método de CLASE para mapear un ID de jugador a un Color."
    unId = 1 ifTrue: [ ^ Color red ].
    unId = 2 ifTrue: [ ^ Color blue ].
    unId = 3 ifTrue: [ ^ Color green ].
    unId = 4 ifTrue: [ ^ Color yellow ].
    ^ Color gray
]

{ #category : #accessing }
CeldaCuadrilaterosMorph >> columna [
    ^ columna
]

{ #category : #accessing }
CeldaCuadrilaterosMorph >> fila [
    ^ fila
]

{ #category : #'as yet unclassified' }
CeldaCuadrilaterosMorph >> fila: r columna: c [
    fila := r.
    columna := c.
]

{ #category : #'as yet unclassified' }
CeldaCuadrilaterosMorph >> iconoParaPowerUp: unPowerUp [
    "Retorna un string/emoji segun la clase"
    "NOTA: El PowerUpBlockTurn (Ø) no estaba en tu código fuente, por lo que lo omitimos."
    (unPowerUp isKindOf: PowerUpMasUno) ifTrue: [ ^ '+1' ].
    (unPowerUp isKindOf: PowerUpMenosUno) ifTrue: [ ^ '-1' ].
    (unPowerUp isKindOf: PowerUpTiradaBaja) ifTrue: [ ^ '<3' ].
    (unPowerUp isKindOf: PowerUpTiradaAlta) ifTrue: [ ^ '>3' ].
    (unPowerUp isKindOf: PowerUpBloqueAleatorio) ifTrue: [ ^ 'RB' ].
    (unPowerUp isKindOf: PowerUpVidaExtra) ifTrue: [ ^ 'V' ].
    ^ '?'
    "* 
    ↕ ↖ ↗ ↘ ↙ ▶ ↓ ↔ ← → ↑ ⇐ ⇑ ⇒ ⇓ ◄ ►  ◀ ▲ ▼ 
    ∞ ∫ ≤ ≠ ‰ π ± √ ∑ ×"
]
