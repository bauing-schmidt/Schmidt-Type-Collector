Extension { #name : 'Collection' }

{ #category : '*Schmidt Type Collector' }
Collection >> asSchmidtTypeCollectorTypeIn: aCollectorForMethod [ 

	| itemClasses |
	
	itemClasses := self collect: [ :each | each class ] as: IdentitySet.

	^ SchmidtTypeCollectorCollectionType fromClass: self class itemClasses: itemClasses
]
