'From Cuis7.1 [latest update: #6883] on 10 December 2024 at 6:49:21 pm'!
'Description '!
!provides: 'Memoize' 1 2!



!Object methodsFor: '*Memoize' stamp: 'RMV 12/10/2024 18:48:45'!
memoize: aBlock
	"Cache the result of evaluating a method with specific arguments.
	This intended for use in class methods that only use their arguments.
	To clear the cache for all methods in a given class, send
	Object clearMemo: 'SomeClassName'
	"
	| cache cacheKey sender valueKey |
	
	sender := thisContext sender.
	
	"Smalltalk is a SystemDictionary which is an IdentityDictionary.
	That is why cacheKey must be a Symbol."
	cacheKey := ('memo-', sender name) asSymbol.

	cache := Smalltalk at: cacheKey ifAbsentPut: [ IdentityDictionary new ].
	valueKey := thisContext name, sender arguments asString :: asSymbol.

	^ cache at: valueKey ifAbsentPut: [ aBlock value ].! !

!Object class methodsFor: '*Memoize' stamp: 'RMV 12/6/2024 06:12:34'!
clearMemo: aString
	"Delete all memoized entries from Smalltalk Dictionary whose keys
	begin with 'memo-' followed by a given string."
	| prefix |
	
	prefix := 'memo-', aString.
	Smalltalk keys do: [ :key |
		key isSymbol and: [key asString beginsWith: prefix] :: ifTrue: [ Smalltalk removeKey: key ].
	].! !

!String class methodsFor: '*Memoize' stamp: 'RMV 12/10/2024 18:41:21'!
indentDepth: aNumber
	^ self memoize: [
		String new: aNumber * 4 withAll: Character space.
	]! !

!Number methodsFor: '*Memoize' stamp: 'RMV 12/10/2024 09:37:46'!
memoize: aBlock
	"Cache the result of evaluating a method with self and specific arguments.
	The block should only use self and the arguments.
	"
	| cache cacheKey sender valueKey |
	
	sender := thisContext sender.
	
	"Smalltalk is a SystemDictionary which is an IdentityDictionary.
	That is why cacheKey must be a Symbol."
	cacheKey := ('memo-', sender name) asSymbol.

	cache := Smalltalk at: cacheKey ifAbsentPut: [ IdentityDictionary new ].
	"TODO: Test this with a Number instance method that takes arguments!!"
	valueKey := thisContext name, self asString, sender arguments asString :: asSymbol.

	^ cache at: valueKey ifAbsentPut: [
		'memoize is computing for ', self asString :: print.
		aBlock value: self.
	].! !

!Integer methodsFor: '*Memoize' stamp: 'RMV 12/10/2024 09:30:50'!
fibonacci
	"Answer fibonacci number for self."

	^ self memoize: [ :n |
		n = 0 ifTrue: [ 0 ]
		ifFalse: [n = 1 ifTrue: [ 1 ]
		ifFalse: [(n - 1) fibonacci + (n - 2) fibonacci]]
	]! !
