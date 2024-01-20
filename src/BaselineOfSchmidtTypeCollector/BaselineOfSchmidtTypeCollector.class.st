Class {
	#name : 'BaselineOfSchmidtTypeCollector',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSchmidtTypeCollector',
	#package : 'BaselineOfSchmidtTypeCollector'
}

{ #category : 'baselines' }
BaselineOfSchmidtTypeCollector >> baseline: spec [
	<baseline>
	spec for: #common
		do: [			
			spec package: 'Schmidt Type Collector'.
			spec package: 'Schmidt Type Collector-Examples'
	]
]
