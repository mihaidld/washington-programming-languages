# Programming Languages, Dan Grossman
# Section 7: Arrays Longer Example

# Data structure that holds any number of other objects and is indexed by
# some number
# a numeric mapping of indices to values
# get via a[i], set via a[i] = e

a = [3,2,7,9]
a[2]
a[0]
a[4] #nil object since out of bounds
a.size #4
a[-1]#9 since last element
a[-2]
a[1] = 6
a
a[6] = 14 #assign to something outside bounds
#it extends array to have that index
a #[3,2,7,9,nil,nill,14]
a[5] #nil
a.size #7 now

a[3] = "hi"

b = a + [true,false]#appends 2 arrays

# | returns elements of both without duplicates [3,2,1]
c = [3,2,3] | [1,2,3] 

# array make fine tuples

triple = [false, "hi", a[0] + 4]
triple[2]

# arrays can also have initial size chosen at run-time
# (and as we saw can grow later -- and shrink)
x = if a[1] < a[0] then 10 else 20 end
y = Array.new(x) #x of size 20 with all elements nil

# better: initialized with a block (coming soon)
z = Array.new(x) { 0 } #all 20 are initialized to 0
w = Array.new(x) {|i| -i } #elements initialized to 0,-1,-2 ...

# stacks
a
a.push 5
a.push 7
a.pop
a.pop
a.pop

# queues (from either end)

a.push 11
a.shift #remove first element (from left)
a.shift
a.unshift 14 #put in front (as first element from left)

# aliasing

d = a #d and a are aliases
e = a + []#+ returns new array, so same contents but not alias of a
d[0]
a[0] = 6
d[0]
e[0]

# g refers to a new array, not the same one as h because + on arrays makes a new
# array. However, both g and h contain two references.  g[0] and h[0] are
# aliases to an array holding [1,2] just as g[1] and h[1] are aliases to an
# array holding [3,4]. Thus, the last line updates one of the aliased arrays to
# [6,2].
h = [[1,2],[3,4]]
g = h + []
h[0][0] = 6

# slices 

f = [2,4,6,8,10,12,14]
f[2,4] #gets new array slice from element index 2, size 4
f.slice(2,2)
f.slice(-2,2)
f[2,4] = [1,1] #assign to f (replace 4 elements starting with 2 with 1,1

# iterating: next segment, teaser here:

[1,3,4,12].each {|i| puts (i * i)}#for each element print its square
