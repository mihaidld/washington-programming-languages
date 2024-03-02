# Programming Languages, Dan Grossman
# Section 7: Procs

# Procs are like blocks, but they are actual objects, similar to function
# closures

# Blocks are not objects, are "second class expressions", not really expressions
# first-class expression = can be result of a computation, can be returned by a
# method, stored in an object, passed around
# second-class expressions is when we can't do that

# the only thing a method can do with a block given to it is yield to it, can
# call a block multiple times inside (by calling yield), but
# can not return the block or store it in an object (put it in an array), keep
# it for a callback.
# Usually blocks are enough for using standard library methods, not many times
# need Procs

# To turn block into objects we create instances of class Proc, that object
# has a method call to invoke the closure (execute the block)
# Procs are first-class expressions

# to create Procs: use method lambda of Object which takes a block and returns
# corresponding Proc
a = [3,5,7,9]

# no need for Procs here
b = a.map {|x| x + 1}

#counts how many times on all elements of arrays, it returns true
i = b.count {|x| x >= 6} 

# need Procs here: want an array of functions (array of closures)
# we want an array of closures that take y and return true if what was in a
# at that positions >= y
c = a.map {|x| lambda {|y| x >= y} } #array of 4 closures (instances of Proc)

# elements of c are Proc objects with a call method

#need to call with an arg because given proc expects a y
c[2].call 17

j = c.count {|x| x.call(5) } #3 because 5,7 and 9 >=5



