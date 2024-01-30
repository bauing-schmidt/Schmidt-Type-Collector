Class {
	#name : 'CollectingFullBlockClosureResult',
	#superclass : 'ProtoObject',
	#instVars : [
		'collectorType',
		'realValue'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _assigned [

	collectorType markAsUsed.
	^ realValue isReadOnlyObject  
		ifFalse: [ self becomeForward: realValue. ]
		ifTrue: [ self becomeForward: realValue copyHash: false ]
	

]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _collectorType [

	^ collectorType
]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _collectorType: anObject [

	collectorType := anObject
]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _realValue [

	^ realValue
]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _realValue: anObject [

	realValue := anObject
]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> doesNotUnderstand: aMessage [

	| oldSelf |
	oldSelf := self.
	self _assigned.
	"oldSelf become realValue"
	^ oldSelf perform: aMessage selector withArguments: aMessage arguments
	
]
