Class {
	#name : 'SchmidtTypeCollectorDictionaryType',
	#superclass : 'SchmidtTypeCollectorType',
	#instVars : [
		'keyClasses',
		'itemClasses'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
SchmidtTypeCollectorDictionaryType class >> fromClass: aClass itemClasses: itemClasses keyClasses: keyClasses [

	^ self new 
		typeClass: aClass;
		itemClasses: itemClasses;
		keyClasses: keyClasses;
		yourself.
]

{ #category : 'instance creation' }
SchmidtTypeCollectorDictionaryType class >> fromDictionary: anObject [ 

	"there are several distinct Dictionary classes so rather make the conversion on onePlace"

	| itemClasses keyClasses |
	
	itemClasses := anObject values collect: [ :each | each class ] as: IdentitySet.
	keyClasses := anObject keys collect: [ :each | each class ] as: IdentitySet.

	^ self fromClass: anObject class itemClasses: itemClasses keyClasses: keyClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorDictionaryType >> = anObject [

	^ super = anObject
		and: [ itemClasses = anObject itemClasses 
			and: keyClasses = anObject keyClasses ]
]

{ #category : 'accessing' }
SchmidtTypeCollectorDictionaryType >> hash [

	^ (super hash bitXor: itemClasses hash) bitXor: keyClasses hash
]

{ #category : 'accessing' }
SchmidtTypeCollectorDictionaryType >> itemClasses [ 

	^ itemClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorDictionaryType >> itemClasses: anObject [

	itemClasses := anObject
]

{ #category : 'accessing' }
SchmidtTypeCollectorDictionaryType >> keyClasses [

	^ keyClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorDictionaryType >> keyClasses: anObject [

	keyClasses := anObject
]

{ #category : 'accessing' }
SchmidtTypeCollectorDictionaryType >> typeString [ 

	| itemsString keysString |
	
	itemsString := itemClasses size = 1
		ifTrue: [ itemClasses anyOne name ]
		ifFalse: [ (self arrayStringFrom: itemClasses) ].

	keysString := keyClasses size = 1
		ifTrue: [ keyClasses anyOne name ]
		ifFalse: [ (self arrayStringFrom: keyClasses) ].

	^ String streamContents: [ :str |
		str << '#(' << typeClass name << ' of ' << itemsString << ' keys ' << keysString << ')']
]
