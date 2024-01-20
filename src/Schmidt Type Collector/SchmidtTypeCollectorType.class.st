Class {
	#name : 'SchmidtTypeCollectorType',
	#superclass : 'Object',
	#instVars : [
		'typeClass'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'accessing' }
SchmidtTypeCollectorType >> <= b [ 

	^ typeClass name <= b typeClass name
]

{ #category : 'accessing' }
SchmidtTypeCollectorType >> = anObject [

	^ self class = anObject class
		and: [ typeClass = anObject typeClass ]
]

{ #category : 'accessing' }
SchmidtTypeCollectorType >> arrayStringFrom: classes [

	| sorted | 
	
	sorted := classes asArray sorted: [ :a :b | a name <= b name ].

	^ String streamContents: [ :s |
		s << '#('.
		sorted do: [ :cls | s << cls name << ' ' ].
		s << ')'.
		 ]
]

{ #category : 'accessing' }
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

	^ typeClass name storeString
]
