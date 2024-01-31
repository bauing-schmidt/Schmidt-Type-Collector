"
Collected type description.
"
Class {
	#name : 'SchmidtTypeCollectorType',
	#superclass : 'Object',
	#instVars : [
		'typeClass'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'private' }
SchmidtTypeCollectorType class >> collectorTypesArrayFrom: aLiteral [

	aLiteral isArray ifFalse: [ 
		^ self collectorTypesSimpleFrom: aLiteral
	].

	^ aLiteral collect: [ :each |
		self collectorTypesSimpleFrom: each.
	] as: OrderedCollection.

]

{ #category : 'private' }
SchmidtTypeCollectorType class >> collectorTypesSimpleFrom: aLiteral [

	aLiteral isArray ifFalse: [ 
		^ { Smalltalk classNamed: aLiteral } asSet
	].

	^ aLiteral flatCollect: [ :each |
		self collectorTypesSimpleFrom: each.
	] as: Set.

]

{ #category : 'instance creation' }
SchmidtTypeCollectorType class >> fromLiteral: aLiteral [

	aLiteral isArray ifFalse: [ 
		aLiteral = #FullBlockClosure ifTrue: [ ^ SchmidtTypeCollectorBlockType fromClass: FullBlockClosure argumentClasses: #() returnClasses: #() ].
		^ { SchmidtTypeCollectorSimpleType fromClass: (Smalltalk classNamed: aLiteral) } asSet 
	].

	(aLiteral size = 1 and: [aLiteral first = #FullBlockClosure]) ifTrue: [ ^ SchmidtTypeCollectorBlockType fromClass: FullBlockClosure argumentClasses: #() returnClasses: #() ].

	(aLiteral size = 3 and: [ (aLiteral second = #of) ])
		ifTrue: [  ^ { SchmidtTypeCollectorCollectionType fromClass: (Smalltalk at: aLiteral first) itemClasses:  (self collectorTypesSimpleFrom: aLiteral third) }  asSet ].
		
	(aLiteral size = 5 and: [ (aLiteral second = #of) and: [aLiteral fourth = #keys] ])
		ifTrue: [ ^ { SchmidtTypeCollectorDictionaryType fromClass: (Smalltalk at: aLiteral first) itemClasses:  (self collectorTypesSimpleFrom: aLiteral third) keyClasses: (self collectorTypesSimpleFrom: aLiteral fifth) }  asSet ].

	"blocks"
	(aLiteral size = 5 and: [ (aLiteral second = #arguments) and: [aLiteral fourth = #returning] ])
		ifTrue: [ ^ { SchmidtTypeCollectorBlockType fromClass: (Smalltalk at: aLiteral first) argumentClasses:  (self collectorTypesArrayFrom: aLiteral third) returnClasses: (self collectorTypesSimpleFrom: aLiteral fifth) }  asSet ].

	(aLiteral size = 3 and: [ (aLiteral second = #arguments) ])
		ifTrue: [ ^ { SchmidtTypeCollectorBlockType fromClass: (Smalltalk at: aLiteral first) argumentClasses:  (self collectorTypesArrayFrom: aLiteral third) }  asSet ].

	(aLiteral size = 3 and: [ aLiteral second = #returning])
		ifTrue: [ ^ { SchmidtTypeCollectorBlockType fromClass: (Smalltalk at: aLiteral first) returnClasses: (self collectorTypesSimpleFrom: aLiteral third) }  asSet ].

	^ aLiteral flatCollect: [ :each |
		self fromLiteral: each.
	] as: Set

]

{ #category : 'comparing' }
SchmidtTypeCollectorType >> <= b [ 

	^ typeClass name <= b typeClass name
]

{ #category : 'comparing' }
SchmidtTypeCollectorType >> = anObject [

	^ self class = anObject class
		and: [ typeClass = anObject typeClass ]
]

{ #category : 'serialization' }
SchmidtTypeCollectorType >> arrayStringFrom: classes [

	| sorted | 
	
	sorted := classes asArray sorted: [ :a :b | a name <= b name ].

	^ String streamContents: [ :s |
		s << '#('.
		sorted do: [ :cls | 
			| name |
			name := cls name.
			name := (name includes: Character space) ifTrue: [ name storeString] ifFalse: [name].
			s << name << ' ' ].
		s << ')'.
		 ]
]

{ #category : 'serialization' }
SchmidtTypeCollectorType >> directOrArrayStringFrom: classes [

	classes size = 1 ifTrue: [ 
		| name |
		name := classes anyOne name.
		^ (name includes: Character space) ifTrue: [ name storeString] ifFalse: [name ]].
	
	^ self arrayStringFrom: classes 
]

{ #category : 'comparing' }
SchmidtTypeCollectorType >> hash [

	^ typeClass identityHash
]

{ #category : 'accessing' }
SchmidtTypeCollectorType >> typeClass [

	^ typeClass
]

{ #category : 'accessing' }
SchmidtTypeCollectorType >> typeClass: anObject [

	typeClass := anObject
]

{ #category : 'accessing' }
SchmidtTypeCollectorType >> typeString [ 

	^ typeClass name asSymbol storeString
]
