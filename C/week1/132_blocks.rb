# Programming Languages, Dan Grossman
# Section 7: Passing Blocks

# Blocks are almost closures
# - an easy way to pass anonymous functions to methods,
# - can take 0 or more arguments,
# - use lexical scope: block body uses environment where block was defined

#pass a block that prints "hi" as an argument to method times of class Integer
3.times { puts "hello" } 

[4,6,8].each { puts "hi" }

i = 7
#block takes an argument x, evaluates i in the env where block defined
[4,6,8].each {|x| if i > x then puts (x+1) end }

# can pass 0 or 1 block with any message (method call).
# It is separate from normal arguments which are passed in parenthesis, after
# them we could pass a block or not
# Syntax: {e} for block witout arguments
# block with arguments passed by the callee: {|x| e}, {|x,y| e}
# can replace { and } with do and end, preferred style for multiline blocks

# Explicite loops rarely used, replaced with methods in standard library that
# expect blocks = higher order functional and functional programming

# Loop for elements in range 0 to 5, print it if even
(0..5).each {|j| if j.even? then puts j end }

#the initialize method of Array class will take a block
#take index of array and from it compute initial value
a = Array.new(5) {|i| 4*(i+1)} #[4,8,12,16,20]
a.each { puts "hi" } #iterate over array elements
a.each {|x| puts (x * 2) }
a.map  {|x| x * 2 } #[8,16,24,32,40]
a.collect  {|x| x * 2 } #synonym of map [8,16,24,32,40]

# applies block to every element until finds one for which block answers true
# and returns true, else false
a.any? {|x| x > 7 } 
a.all? {|x| x > 7 }
# implicit are elements "true" (i.e., neither false nor nil) without block
a.all?

# reduce, starts with accumulator acc 0, block requires 2 arguments: answer so
# far acc and current element elt
a.inject(0) {|acc,elt| acc+elt }
a.inject {|acc,elt| acc+elt }#without first acc, it uses first element as acc
a.select {|x| x > 7 && x < 18} #non-synonym: filter, selects elements 7<x<18

#(0..1) is range, an object that represents sequence up to i
# syntax for multiline blocks with do ... end
def t i
  (0..i).each do |j|
    print "  " * j #prints 2 spaces times j (2j spaces)
    (j..i).each {|k| print k; print " "} #nested range from j up to i
    print "\n"
  end #end block
end #end method

t 9

=begin
0 1 2 3 4 5 6 7 8 9 
  1 2 3 4 5 6 7 8 9 
    2 3 4 5 6 7 8 9 
      3 4 5 6 7 8 9 
        4 5 6 7 8 9 
          5 6 7 8 9 
            6 7 8 9 
              7 8 9 
                8 9 
                  9
=end
