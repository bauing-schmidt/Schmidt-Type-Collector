Class {
	#name : 'CollectingFullBlockClosure',
	#superclass : 'FullBlockClosure',
	#type : 'variable',
	#instVars : [
		'collectorType'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
CollectingFullBlockClosure class >> from: aFullBlockClosure [
]

{ #category : 'accessing' }
CollectingFullBlockClosure >> collectorType [

	^ collectorType
]

{ #category : 'accessing' }
CollectingFullBlockClosure >> collectorType: anObject [

	collectorType := anObject
]

{ #category : 'evaluating' }
CollectingFullBlockClosure >> returnProxyFor: result [
	
	| proxy |

	collectorType addReturnClass: result class.
	proxy := CollectingFullBlockClosureResult basicNew 
		_collectorType: collectorType;
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
	collectorType addArgumentClasses: { arg class }.
	^ self returnProxyFor: result
]
