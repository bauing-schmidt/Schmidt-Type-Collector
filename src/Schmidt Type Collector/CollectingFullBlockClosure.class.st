Class {
	#name : 'CollectingFullBlockClosure',
	#superclass : 'FullBlockClosure',
	#type : 'variable',
	#instVars : [
		'collectorTypes'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
CollectingFullBlockClosure class >> from: aFullBlockClosure [
]

{ #category : 'accessing' }
CollectingFullBlockClosure >> addCollectorType: aCollectorType [ 

	^ self collectorTypes add: aCollectorType 
]

{ #category : 'evaluating' }
CollectingFullBlockClosure >> asPdmTypeCollectorType [

	"only register a new collector type"
	
	| collectorType |
	
	collectorType := SchmidtTypeCollectorBlockType new.
	collectorTypes add: collectorType.
	
	^ collectorType
	
]

{ #category : 'accessing' }
CollectingFullBlockClosure >> collectorTypes [

	^ collectorTypes ifNil: [ collectorTypes := OrderedCollection new ]
]

{ #category : 'accessing' }
CollectingFullBlockClosure >> collectorTypes: anObject [

	collectorTypes := anObject
]

{ #category : 'evaluating' }
CollectingFullBlockClosure >> returnProxyFor: result [
	
	| proxy |

	collectorTypes do: [ :type | type addReturnClass: result class ].
	proxy := CollectingFullBlockClosureResult basicNew _initialize 
		_collectorTypes: collectorTypes;
		_realValue: result.
	^ proxy 
]

{ #category : 'evaluating' }
CollectingFullBlockClosure >> value [ 

	| result |
	result := super value.
	^ self returnProxyFor: result
]

{ #category : 'evaluating' }
CollectingFullBlockClosure >> value: arg [

	| result |
	result := super value: arg.
	collectorTypes do: [ :type | type addArgumentClasses: { arg class } ].
	^ self returnProxyFor: result
]
