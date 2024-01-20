Class {
	#name : 'SchmidtTypeCollectorExample',
	#superclass : 'TestCase',
	#instVars : [
		'instVar'
	],
	#category : 'Schmidt Type Collector-Examples',
	#package : 'Schmidt Type Collector-Examples'
}

{ #category : 'examples' }
SchmidtTypeCollectorExample class >> exampe [ 

	<example>
	
	| collector |
	collector := SchmidtTypeCollector new.
	collector installOnPackageNamed: 'Schmidt Type Collector-Examples' mode: #variables.
	
	SchmidtTypeCollectorExample suite run.

	collector finish.
	collector generate.
	
	"now collect return values"

	collector := SchmidtTypeCollector new.
	collector installOnPackageNamed: 'Schmidt Type Collector-Examples' mode: #returnValues.
	
	SchmidtTypeCollectorExample suite run.

	collector finish.
	collector generate.
]

{ #category : 'as yet unclassified' }
SchmidtTypeCollectorExample >> _slotTypes [

		
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> arg1: arg1 arg2: arg2 [

	| tmp1 tmp2 |
	#start traceCr.
	tmp1 := arg1 + 1.
	tmp2 := (tmp1 + 2) asString.
	tmp2 yourself.
	#( 1 2 nil #someting ) do: [ :arg3 | arg3 yourself ].
	#beforeEnd traceCr.
	^ tmp1 - 44
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> testSomething2 [

	1 ifNotNil: [ :num |
		num.	
	 ].

	instVar := #var.
	self arg1: 42 arg2: #symbol.
	
	#(2) do: [ :x |
		#(3 4) withIndexDo: [ :y :index |
			x*y.
			]
	].
]
