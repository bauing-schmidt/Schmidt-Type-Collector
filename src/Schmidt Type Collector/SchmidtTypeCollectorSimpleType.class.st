Class {
	#name : 'SchmidtTypeCollectorSimpleType',
	#superclass : 'SchmidtTypeCollectorType',
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'instance creation' }
SchmidtTypeCollectorSimpleType class >> fromClass: aClass [ 

	^ self new 
		typeClass: aClass;
		yourself.
]
