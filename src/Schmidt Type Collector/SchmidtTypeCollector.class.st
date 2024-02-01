"
Runtime Type Collector.
"
Class {
	#name : 'SchmidtTypeCollector',
	#superclass : 'Object',
	#instVars : [
		'methodCollectors',
		'slotTypes',
		'useBlockArgPrefix',
		'merging'
	],
	#category : 'Schmidt Type Collector',
	#package : 'Schmidt Type Collector'
}

{ #category : 'as yet unclassified' }
SchmidtTypeCollector class >> wellKnownNotReturningBlockMessages [

	^ #(do:)
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollector class >> wellKnownReturningBlockMessages [

	^ #(select: collect: reject:)
]

{ #category : 'API' }
SchmidtTypeCollector >> finish [ 

	methodCollectors do: [ :each | each remove ].
	MetaLink uninstallAll.
]

{ #category : 'API' }
SchmidtTypeCollector >> generate [ 

	methodCollectors do: [ :collector |
		| pragmaManager orderedBlocks |
		pragmaManager := (SchmidtTypeCollectorPragmaManager for: collector method).
		orderedBlocks := collector orderedBlocks.

		self generateReturnTypesIn: collector manager: pragmaManager.
		self generateArgTypesIn: collector manager: pragmaManager.
		self generateTempTypesIn: collector manager: pragmaManager.
		self generateBlockArgTypesIn: collector manager: pragmaManager.
		self generateBlockInformationIn: collector manager: pragmaManager blocks: orderedBlocks.
	].

	self generateSlotTypes.
]

{ #category : 'generation' }
SchmidtTypeCollector >> generateArgTypesIn: collector manager: pragmaManager [

	"keep the order"
	collector method argumentNames do: [ :argName |
		collector collectedArgClasses at: argName ifPresent: [ :types |
			pragmaManager replacePragma: #arg:type:generated: argument: argName with: ('<arg: {1} type: {2} generated: true>' format: { argName storeString. self typeStringFor: types  }).
		] 
	].
]

{ #category : 'generation' }
SchmidtTypeCollector >> generateBlockArgTypesIn: collector manager: pragmaManager [

	collector collectedBlockArgClasses keys sorted do: [ :argName |
		| types |
		types := collector collectedBlockArgClasses at: argName.
		pragmaManager replacePragma: #blockArg:type:generated: argument: argName with: ('<blockArg: {1} type: {2} generated: true>' format: { argName storeString. self typeStringFor: types  }).
	] 

]

{ #category : 'generation' }
SchmidtTypeCollector >> generateBlockInformationIn: collector manager: pragmaManager blocks: orderedBlocks [.

	orderedBlocks do: [ :assoc |
		| num type |
		num := assoc key.
		type := assoc value.
		type wasUsed 
			ifTrue: [ 
				pragmaManager replacePragma: #block: argument: num with: ('<block: {1} returnsValue: {2} generated: true>' format: { num storeString. type wasUsed storeString}) ]
			ifFalse: [ 
				pragmaManager ensureDeletePragma: #block: argument: num.
			]
		]
]

{ #category : 'generation' }
SchmidtTypeCollector >> generateReturnTypesIn: collector manager: pragmaManager [

	collector collectedReturnClasses ifNotEmpty: [ 		
		pragmaManager replacePragma: #returns:generated: with: ('<returns: {1} generated: true>' format: { self typeStringFor: collector collectedReturnClasses  }).
	]
]

{ #category : 'generation' }
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

{ #category : 'generation' }
SchmidtTypeCollector >> generateTempTypesIn: collector manager: pragmaManager [

	collector method tempNames do: [ :tempName |
		collector collectedTempClasses at: tempName ifPresent: [ :types |
			pragmaManager replacePragma: #var:type:generated: argument: tempName with: ('<var: {1} type: {2} generated: true>' format: { tempName storeString. self typeStringFor: types  }).
		] 
	].

]

{ #category : 'initialization' }
SchmidtTypeCollector >> initialize [ 

	super initialize.
	
	slotTypes := Dictionary new.
	useBlockArgPrefix := false.
	merging := true.
]

{ #category : 'API' }
SchmidtTypeCollector >> installOnPackageNamed: packageName mode: mode [

	"mode: #variables, #returnValues"
	
	| methods |
	
	methods := packageName asPackage methods.
	methods := methods reject: [ :each | each methodClass = Context ].

	methodCollectors := methods collect: [ :method |
		(SchmidtTypeCollectorForMethod forMethod: method)
			collector: self;
			mode: mode;
			yourself
	].

	merging ifTrue: [ 
		"not only defined classes but all classes"
		packageName asPackage classes do: [ :aClass |
		self readCurrentSlotTypesFromPragmasFor: aClass ]
	].

	methodCollectors do: [ :each | each install ].
	
	

	
]

{ #category : 'accessing' }
SchmidtTypeCollector >> merging [

	^ merging
]

{ #category : 'accessing' }
SchmidtTypeCollector >> merging: anObject [

	merging := anObject
]

{ #category : 'method collector cooperation' }
SchmidtTypeCollector >> readCurrentSlotTypesFromPragmasFor: aClass [

	| methodName |
	
	methodName := self typeDescriptionMethodName.
		
	(aClass includesSelector: methodName)
		ifFalse: [ ^ self ].
	
	(aClass >> methodName) pragmas do: [ :pragma | 
		(#(slot:type: slot:type:generated:) includes: pragma selector) 
			ifTrue: [ 
				((slotTypes at: aClass ifAbsentPut: [ Dictionary new ])
					at: pragma arguments first asSymbol ifAbsentPut: [ Set new ])
					addAll: (SchmidtTypeCollectorType fromLiteral: pragma arguments second).
		].
	]
]

{ #category : 'method collector cooperation' }
SchmidtTypeCollector >> recordSlotWrite: slotName inClass: aClass type: aType [ 

	((slotTypes at: aClass ifAbsentPut: [ Dictionary new ])
		at: slotName ifAbsentPut: [ Set new ])
			add: aType
]

{ #category : 'type description methods' }
SchmidtTypeCollector >> typeDescriptionMethodIn: aClass [

	| methodName |
	
	methodName := self typeDescriptionMethodName.
		
	(aClass includesSelector: methodName)
		ifFalse: [
			aClass compile: methodName, '
	' classified: '_TYPES'].

	 ^ aClass >> methodName  
]

{ #category : 'type description methods' }
SchmidtTypeCollector >> typeDescriptionMethodName [

	^ '_slotTypes' asSymbol
]

{ #category : 'utility' }
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

{ #category : 'accessing' }
SchmidtTypeCollector >> useBlockArgPrefix [

	^ useBlockArgPrefix
]

{ #category : 'accessing' }
SchmidtTypeCollector >> useBlockArgPrefix: anObject [

	useBlockArgPrefix := anObject
]
