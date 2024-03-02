# Programming Languages, Dan Grossman
# Section 7: Hashes and Ranges

# Hashes are like arrays, collection of key value pairs, mapping key to a value,
# but keys can be anything (usually strings and symbols, but can be any objects)
# no natural ordering like numeric indices
# like a record where field names and contents that can be anything
# use hashes when need data staructure with bunch of pieces, each with its name
# (e.g. configuration options passed to a method 
h1 = {} #built empty hash or with Hash.new
h1["a"] = "Found A"
h1[false] = "Found false"
h1["a"] #"Found A"
h1[false]
h1[42]#nil
h1.keys #["a", false]
h1.values #[ "Found A", "Found false"]
h1.delete("a")

#create hash of 3 mappings 
h2 = {"SML"=>1, "Racket"=>2, "Ruby"=>3}
h2["SML"]

# Symbols are like strings, but cheaper.  Often used with hashes.
h3 = {:sml => 1, :racket => 2, :ruby => 3}

# each for hashes best with 2-argument block (takes pair key value)

h2.each {|k,v| print k; print ": "; puts v}

# Ranges are like arrays of contiguous numbers, but are more efficiently
# represented: fast to make one, doesn't occupy much space, is a little object
# with 2 instance variables from and to, but acts like contigous numbers from
# ... to ...
# e.g. (1..1000000) is fast, doesn't take 1000000 spaces
#  (1..1000000).to_a converts range to array not efficient

# adds up all numbers from 1 to 100
(1..100).inject {|acc,elt| acc + elt}

# Good style:
# - use ranges when you can because more efficient
# - use hashes when non-numeric keys better represent data

# Arrays, hashes and ranges have many of the same methods (e.g. iterators)

def foo a
  a.count {|x| x*x < 50}
end

# duck typing in foo
# a is not necessarily an array, can be other object with count method
# can call foo with any object that has a count method that takes a block
# Separation of concerns in highr-order programming: iterator takes care of
# iterating over an array, range etc. (implementation of count on different data
# structures) and another code computes something useful of each data (foo)
foo [3,5,7,9] # 3 
foo (3..9) # 5
