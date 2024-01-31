Class {
	#name : 'SchmidtTypeCollectorBlockType',
	#superclass : 'SchmidtTypeCollectorType',
	#instVars : [
		'argumentClasses',
		'returnClasses',
		'wasUsed'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
SchmidtTypeCollectorBlockType class >> fromClass: aClass argumentClasses: argumentClasses [

	^ self new 
		typeClass: aClass;
		argumentClasses: argumentClasses;
		wasUsed: false;
		yourself.
]

{ #category : 'instance creation' }
SchmidtTypeCollectorBlockType class >> fromClass: aClass argumentClasses: argumentClasses returnClasses: returnClasses [

	^ self new 
		typeClass: aClass;
		argumentClasses: argumentClasses;
		returnClasses: returnClasses;
		wasUsed: true;
		yourself.
]

{ #category : 'instance creation' }
SchmidtTypeCollectorBlockType class >> fromClass: aClass returnClasses: returnClasses [

	^ self new 
		typeClass: aClass;
		returnClasses: returnClasses;
		wasUsed: true;
		yourself.
]

{ #category : 'comparing' }
SchmidtTypeCollectorBlockType >> = anObject [

	^ super = anObject
		and: [ argumentClasses = anObject argumentClasses 
			and: [ returnClasses = anObject returnClasses 
				and: wasUsed = anObject wasUsed ] ]
]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> addArgumentClasses: argClasses [ 

	argumentClasses size < argClasses size ifTrue: [
		| old |
		old := argumentClasses.
		argumentClasses := OrderedCollection ofSize: argClasses size.
		old withIndexDo: [ :val :index |
			argumentClasses at: index put: val 
		].
	].

	argClasses withIndexDo: [ :val :index |
		| set |
		set := argumentClasses at: index.
		set ifNil: [ 
			set := Set new.
			argumentClasses at: index put: set ].
		set add: val
	]

]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> addReturnClass: aClass [ 

	^ returnClasses add: aClass
]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> argumentClasses [

	^ argumentClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> argumentClasses: anObject [

	argumentClasses := anObject
]

{ #category : 'comparing' }
SchmidtTypeCollectorBlockType >> hash [

	^ ((super hash bitXor: argumentClasses hash)
	 bitXor: returnClasses hash)
	 bitXor: wasUsed hash
]

{ #category : 'initialization' }
SchmidtTypeCollectorBlockType >> initialize [ 

	super initialize.
	typeClass := FullBlockClosure.
	returnClasses := Set new.
	argumentClasses := OrderedCollection new.
	wasUsed := false.

]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> markAsUsed [

	wasUsed := true.
]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> returnClasses [

	^ returnClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> returnClasses: anObject [

	returnClasses := anObject
]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> typeString [ 

	| returnClassesString argumentClassesString |
	
	argumentClassesString := argumentClasses 
		ifEmpty: [ '' ]
		ifNotEmpty: [ '#(', ((argumentClasses collect: [:each | self directOrArrayStringFrom: each]) joinUsing: ' '), ')' ].	

	returnClassesString := returnClasses size = 1
		ifTrue: [ returnClasses anyOne name ]
		ifFalse: [ (self arrayStringFrom: returnClasses) ].

	^ String streamContents: [ :str | 
		str << '#(' << typeClass name.
		argumentClasses ifNotEmpty: [ 
			str << ' arguments ' << argumentClassesString ].
		(wasUsed and: [returnClasses notEmpty ]) ifTrue: [ 
		 	str << ' returning ' << returnClassesString].
		str << ')' ]
]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> wasUsed [

	^ wasUsed
]

{ #category : 'accessing' }
SchmidtTypeCollectorBlockType >> wasUsed: anObject [

	wasUsed := anObject
]
