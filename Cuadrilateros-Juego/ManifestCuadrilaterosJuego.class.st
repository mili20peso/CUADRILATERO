"
???
"
Class {
	#name : #ManifestCuadrilaterosJuego,
	#superclass : #PackageManifest,
	#category : #'Cuadrilateros-Juego'
}

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBBadMessageRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosBoard #canPlaceShape:width:height:player: #false)) #'2025-11-24T10:34:20.238443-03:00') #(#(#RGMethodDefinition #(#CuadrilaterosGAME #nextTurn #false)) #'2025-11-24T12:01:14.627443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBCascadedNextPutAllsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosGAME #nextTurn #false)) #'2025-11-24T12:01:01.171443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBConsistencyCheckRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosGAME #initializeWithPlayerClasses:boardSize: #false)) #'2025-11-28T19:36:21.446045-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBInconsistentMethodClassificationRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosPlayerFragil #addArea: #false)) #'2025-11-27T15:22:43.616443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBNoClassCommentRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#CuadrilaterosPowerUp)) #'2025-11-21T10:53:01.86801-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBUnclassifiedMethodsRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#PowerUpOverwrite)) #'2025-11-24T10:33:35.244443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#PowerUpOverwrite)) #'2025-11-24T10:33:39.126443-03:00') )
]

{ #category : #'code-critics' }
ManifestCuadrilaterosJuego class >> ruleRBWhileTrueRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#CuadrilaterosBoard #spawnRandomPowerUp #false)) #'2025-11-21T17:29:34.43801-03:00') #(#(#RGMethodDefinition #(#CuadrilaterosBoard #placeRandomBlockFor: #false)) #'2025-11-21T17:34:55.01501-03:00') )
]
