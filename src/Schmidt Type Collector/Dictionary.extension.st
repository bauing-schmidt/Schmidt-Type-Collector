Extension { #name : 'Dictionary' }

{ #category : '*Schmidt Type Collector' }
Dictionary >> asPdmTypeCollectorType [ 

	^ SchmidtTypeCollectorDictionaryType fromDictionary: self
]
