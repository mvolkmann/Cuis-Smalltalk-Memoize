# Cuis-Smalltalk-Memoize

This is a package for Cuis Smalltalk that provides methods for memoizing methods,
which caches results of computation so repeating them can be avoided.
There are two `memoize:` methods that both take a block.

It adds the `Object` instance method `memoize:` that is used to
memoize class methods that only use the values of arguments passed to them.

The following class method added to the `String` class provides an example:

```smalltalk
indentDepth: aNumber
    ^ self memoize: [
        String new: aNumber * 4 withAll: Character space.
    ]
```

It also adds the `Number` instance method `memoize:` that is used to
memoize instance methods in that class and its subclasses
that only use the value of the instance (a number of some kind)
and the values of arguments passed to them.

The following instance method added to the `Integer` class provides an example:

```smalltalk
fibonacci
    "Answer fibonacci number for self."

    ^ self memoize: [ :n |
        n = 0 ifTrue: [ 0 ]
        ifFalse: [n = 1 ifTrue: [ 1 ]
        ifFalse: [(n - 1) fibonacci + (n - 2) fibonacci]]
    
```

To clear all cached values, evaluate `Object clearMemo: prefix`
where `prefix` is the name of class containing memoized methods.
For example, to clear the memoized `fibonacci` results,
evaluate `Object clearMemo: 'SmallInteger'`.
