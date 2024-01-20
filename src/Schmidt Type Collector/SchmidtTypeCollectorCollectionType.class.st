"
Describes a non-keyed collection type.
"
Class {
	#name : 'SchmidtTypeCollectorCollectionType',
	#superclass : 'SchmidtTypeCollectorType',
	#instVars : [
		'itemClasses'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
SchmidtTypeCollectorCollectionType class >> fromClass: aClass itemClasses: itemClasses [

	^ self new 
		typeClass: aClass;
		itemClasses: itemClasses;
		yourself.
]

{ #category : 'comparing' }
SchmidtTypeCollectorCollectionType >> = anObject [

	^ super = anObject
		and: [ itemClasses = anObject itemClasses ]
]

{ #category : 'comparing' }
SchmidtTypeCollectorCollectionType >> hash [

	^ super hash bitXor: itemClasses hash
]

{ #category : 'accessing' }
SchmidtTypeCollectorCollectionType >> itemClasses [

	^ itemClasses
]

{ #category : 'accessing' }
SchmidtTypeCollectorCollectionType >> itemClasses: anObject [

	itemClasses := anObject
]

{ #category : 'accessing' }
SchmidtTypeCollectorCollectionType >> typeString [ 

	| classesString |
	
	classesString := itemClasses size = 1
		ifTrue: [ itemClasses anyOne name ]
		ifFalse: [ (self arrayStringFrom: itemClasses) ].

	^ String streamContents: [ :str | 
		str << '#(' << typeClass name << ' of ' << classesString << ')']
]
