Class {
	#name : 'CollectingFullBlockClosureResult',
	#superclass : 'ProtoObject',
	#instVars : [
		'collectorTypes',
		'realValue'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _addCcollectorType: anObject [

	collectorTypes add: anObject
]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _assigned [

	collectorTypes do: [ :each | each markAsUsed ].
	^ realValue isReadOnlyObject  
		ifFalse: [ self becomeForward: realValue. ]
		ifTrue: [ self becomeForward: realValue copyHash: false ]
	

]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _collectorTypes [

	^ collectorTypes
]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _collectorTypes: anObject [

	collectorTypes := anObject
]

{ #category : 'accessing' }
CollectingFullBlockClosureResult >> _initialize [ 

	super initialize.
	collectorTypes := OrderedCollection new.
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
