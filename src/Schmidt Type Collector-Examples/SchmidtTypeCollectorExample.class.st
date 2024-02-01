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
SchmidtTypeCollectorExample class >> example [ 

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

		<slot: #instVar type: #ByteSymbol generated: true>
	
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> arg1: argument1 arg2: argument2 [

	<arg: #argument1 type: #(#SmallFloat64 #SmallInteger ) generated: true>
	<arg: #argument2 type: #'Symbol class' generated: true>
	<var: #temporary1 type: #SmallFloat64 generated: true>
	<var: #temporary2 type: #ByteString generated: true>
	<blockArg: #each type: #(#ByteSymbol #SmallInteger #UndefinedObject ) generated: true>
	<returns: #SmallFloat64 generated: true>
	| temporary1 temporary2 |
	#start traceCr.
	temporary1 := argument1 + 1.
	temporary2 := (temporary1 + 2) asString.
	temporary2 yourself.
	#( 1 2 nil #someting ) do: [ :each | each yourself ].
	#beforeEnd traceCr.
	^ temporary1 - 44
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> blockMessage: aBlock [ 

	<arg: #aBlock type: #(FullBlockClosure arguments #(SmallInteger) returning SmallInteger) generated: true>
	<var: #tmp type: #SmallInteger generated: true>
	<returns: #SchmidtTypeCollectorExample generated: true>
	| tmp |
	tmp := aBlock value: 32.	
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> testSomething2 [

	<returns: #SchmidtTypeCollectorExample generated: true>
	<blockArg: #index type: #SmallInteger generated: true>
	<blockArg: #num type: #SmallInteger generated: true>
	<blockArg: #x type: #SmallInteger generated: true>
	<blockArg: #y type: #SmallInteger generated: true>
	1 ifNotNil: [ :num |
		num.	
	 ].

	instVar := #var.
	self arg1: 42.2 arg2: Symbol.
	
	#(2) do: [ :x |
		#(3 4) withIndexDo: [ :y :index |
			x*y.
			]
	].
]

{ #category : 'accessing' }
SchmidtTypeCollectorExample >> testSomethingBlock [

	<var: #b1 type: #(FullBlockClosure returning SmallInteger) generated: true>
	<var: #b2 type: #(FullBlockClosure) generated: true>
	<var: #b3 type: #(FullBlockClosure arguments #(Object) returning Object) generated: true>
	<var: #b4 type: #(FullBlockClosure arguments #(Object)) generated: true>
	<var: #b5 type: #(FullBlockClosure arguments #(SmallInteger) returning SmallInteger) generated: true>
	<var: #val type: #(#Object #SmallInteger ) generated: true>
	<blockArg: #arg type: #Object generated: true>
	<blockArg: #arg2 type: #Object generated: true>
	<blockArg: #arg3 type: #SmallInteger generated: true>
	<blockArg: #each type: #SmallInteger generated: true>
	<block: 1 returnsValue: true generated: true>
	<block: 5 returnsValue: true generated: true>
	<block: 7 returnsValue: true generated: true>
	<block: 1 returnsValue: true generated: true>
	<block: 1 returnsValue: true generated: true>
	<returns: #SchmidtTypeCollectorExample generated: true>
	| b1 b2 b3 b4 b5 val |
	
	b1 := [ 41 ].
	val := b1 value.
	
	#(1 2 3) select: [ :each | each > 1 ].
	#(1 2 3) do: [ :each | each ].
	
	b2 := [ 42 ].
	b2 value.

	b3 := [ :arg | arg ].
	val := b3 value: Object new.

	b4 := [ :arg2 | arg2 ].
	b4 value: Object new.

	b5 := [ :arg3 | arg3 ].
	self blockMessage: b5.
]
