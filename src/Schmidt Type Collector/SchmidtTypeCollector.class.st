Class {
	#name : 'SchmidtTypeCollector',
	#superclass : 'Object',
	#instVars : [
		'methodCollectors',
		'slotTypes'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> finish [ 

	methodCollectors do: [ :each | each remove ].
	MetaLink uninstallAll.
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> generate [ 

	methodCollectors do: [ :collector |
		| pragmaManager |
		pragmaManager := (SchmidtTypeCollectorPragmaManager for: collector method).

		self generateReturnTypesIn: collector manager: pragmaManager.
		self generateArgTypesIn: collector manager: pragmaManager.
		self generateTempTypesIn: collector manager: pragmaManager.
		self generateBlockArgTypesIn: collector manager: pragmaManager.
	].

	self generateSlotTypes.
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> generateArgTypesIn: collector manager: pragmaManager [

	"keep the order"
	collector method argumentNames do: [ :argName |
		collector collectedArgClasses at: argName ifPresent: [ :types |
			pragmaManager replacePragma: #arg:type:generated: argument: argName with: ('<arg: {1} type: {2} generated: true>' format: { argName storeString. self typeStringFor: types  }).
		] 
	].
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> generateBlockArgTypesIn: collector manager: pragmaManager [

	collector collectedBlockArgClasses keys sorted do: [ :argName |
		| types |
		types := collector collectedBlockArgClasses at: argName.
		pragmaManager replacePragma: #blockArg:type:generated: argument: argName with: ('<blockArg: {1} type: {2} generated: true>' format: { argName storeString. self typeStringFor: types  }).
	] 

]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> generateReturnTypesIn: collector manager: pragmaManager [

	collector collectedReturnClasses ifNotEmpty: [ 		
		pragmaManager replacePragma: #returns:generated: with: ('<returns: {1} generated: true>' format: { self typeStringFor: collector collectedReturnClasses  }).
	]
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> generateSlotTypes [

	slotTypes keysAndValuesDo: [ :class :slotDict |
		| descriptionMethod pragmaManager | 
		descriptionMethod := self typeDescriptionMethodIn: class.
		pragmaManager := (SchmidtTypeCollectorPragmaManager for: descriptionMethod).
		slotDict keysAndValuesDo: [ :key :types |
			pragmaManager replacePragma: #slot:type:generated: argument: key with: ('<slot: {1} type: {2} generated: true>' format: { key storeString. self typeStringFor: types  }).			
		]
	].
	
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> generateTempTypesIn: collector manager: pragmaManager [

	collector method tempNames do: [ :tempName |
		collector collectedTempClasses at: tempName ifPresent: [ :types |
			pragmaManager replacePragma: #var:type:generated: argument: tempName with: ('<var: {1} type: {2} generated: true>' format: { tempName storeString. self typeStringFor: types  }).
		] 
	].

]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> initialize [ 

	super initialize.
	
	slotTypes := Dictionary new.
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> installOnPackageNamed: packageName mode: mode [

	"mode: #variables, #returnValues"

	methodCollectors := packageName asPackage methods collect: [ :method |
		(SchmidtTypeCollectorForMethod forMethod: method)
			collector: self;
			mode: mode;
			yourself
	].

	methodCollectors do: [ :each | each install ].
	
	

	
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> recordSlotWrite: slotName inClass: aClass type: aType [ 

	((slotTypes at: aClass ifAbsentPut: [ Dictionary new ])
		at: slotName ifAbsentPut: [ Set new ])
			add: aType
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> typeDescriptionMethodIn: aClass [

	| methodName |
	
	methodName := self typeDescriptionMethodName.
		
	(aClass includesSelector: methodName)
		ifFalse: [
			aClass compile: methodName, '
	' ].

	 ^ aClass >> methodName  
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> typeDescriptionMethodName [

	^ '_slotTypes' asSymbol
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector >> typeStringFor: aTypeOrTypes [ 

	aTypeOrTypes isCollection ifFalse: [ 
		^ aTypeOrTypes typeString ].

	aTypeOrTypes size = 1 ifTrue: [ 
		^ aTypeOrTypes anyOne typeString ].

	^ String streamContents: [ :str | 
		str << '#('.
		(aTypeOrTypes asArray sorted do: [ :cls | str << cls typeString << ' ' ]).
		str << ')']
	
]
