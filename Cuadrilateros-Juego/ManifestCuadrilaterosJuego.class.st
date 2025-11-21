"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestCuadrilaterosJuego,
	#superclass : #PackageManifest,
	#category : #'Cuadrilateros-Juego-Manifest'
}

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBNoClassCommentRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#CuadrilaterosPowerUp)) #'2025-11-21T10:53:01.86801-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBWhileTrueRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosBoard #spawnRandomPowerUp #false)) #'2025-11-21T17:29:34.43801-03:00') #(#(#RGMethodDefinition #(#CuadrilaterosBoard #placeRandomBlockFor: #false)) #'2025-11-21T17:34:55.01501-03:00') )
]
