# Schmidt Type Collector

Runtime type collector for Pharo.

## Loading

**Attention:** Tested in Pharo 12, build 991. It may not work in other versions or builds.

```smalltalk
Metacello new
    baseline: 'SchmidtTypeCollector';
    repository: 'github://bauing-schmidt/Schmidt-Type-Collector/src';
    load.
```

## Purpose

The potential usage of type information in Pharo code:

- code documentation
- shows possible type problems
- help with code rewrite to statically typed languages
- types may be used by code completion, JIT and other tools
- runtime type checking

## How does it work?

For methods in the given package, the type collector installs Metalinks on:
- temporary variable writes
- instance variable writes
- method entry (to read passed arguments)
- block entry (to read passed block arguments)
- method leave (to read return value)
During each write, it resolves the type of the written object. When finished, it then generated pragmas describing these types.

While the collector reads types only during runtime, it is recommended to have an automatic way of executing all your code - e.g., using a test case. 

```smalltalk
	collector := SchmidtTypeCollector new.
	collector installOnPackageNamed: 'Schmidt Type Collector-Examples' mode: #variables.
	
	SchmidtTypeCollectorExample suite run.

	collector finish.
	collector generate.
```

### Two modes of operation

Because of current Metalinks infrastructure limitations, Metalinks for return values do not work together with block entry Metalinks. So the execution needs to be performed twice in these modes:
* `variables`
* `returnValues`
(see `SchmidtTypeCollectorExample class>>#exampe`)

 ## Type pragmas

Type pragmas are placed at the beginning of the method. 

### Temporary variables

```smalltalk
	<var: #tmp type: #SmallInteger>
	<var: #tmp type: #SmallInteger generated: true>
	<var: #tmp type: #SmallInteger generated: false>
```

The Type Collector generates the pragmas with the last keyword ```generated:``` expecting boolean value. If, for a given variable, it finds generated pragma, it rewrites it. If user changes this value to `false` or removes this keyword part because it manually sets the type or expects the generated type to be definitive, the generator ignores it. 

The same for other kind of types described below.

It writes pragmas only for methods that were executed during types collecting.

### Method arguments

```smalltalk
	<arg: #argument type: #SmallInteger>
```

### Instance variables

The collected types for instance variables are stored in the method named `_slotTypes` belonging to the given class.

```smalltalk
	<slot: #iVar type: #SmallInteger>
```

### Instance variables

Pragmas cannot be stored directly in the block code, so they are also placed at the beginning of the method. The name of the variable of the pragma encodes the index of the block in the method. Right now, it uses it all the time. It will probably be changed to do it only if the name is ambiguous.

```smalltalk
	<lockArg: #_1_each type: #SmallInteger>
```

## Return values

```smalltalk
	<returns: #SmallInteger>
```

## Type descriptions

In the simplest case, the type description is just a symbol with a name of the class.

```smalltalk
    <var: #tmp type: #SmallInteger>
```

If more distinct types are written into the variable, an array of class names is used.

```smalltalk
    <var: #tmp type: #(#SmallInteger #UndefinedObject)>
```

If the type is a collection, an array of the form `#(CollectionType of ValueType)` is used.

```smalltalk
    <var: #tmp type: #(Array of SmallInteger)>
```

If the type is a dictionary, an array of the form `#(DictionaryType of ValueType keys KeyType)` is used.

```smalltalk
    <var: #tmp type: #(Dictionary of SmallInteger keys ByteSymbol)>
```

Collections and simple types can be combined.

```smalltalk
    <var: #tmp type: #(#(Dictionary of SmallInteger keys ByteSymbol) #UndefinedObject )>
    <var: #tmp type: #(#(Dictionary of ByteString keys Object) #(Dictionary of SmallInteger keys ByteSymbol) )>
```
