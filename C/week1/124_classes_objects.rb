# Programming Languages, Dan Grossman
# Section 7: Classes and Objects

# Syntax class definition
# class Name
#   def method_name1 method_args1
#     expression1
#   end
#   ...
# end

# Name.new creates a new object whose class is Name
# e.m evaluates e to an object and then calls its m method =
# sends the m message to the object
# can write also e.m(), e.m(e1,...,en)


class A
  def m1  #method without args
    34
  end

  def m2 (x,y) #method with 2 args

    #Variables:methods can use local variables
    #variable names start with letters
    #can be put anywhere in method body and their scope is entire body
    #no declaring them, just assign them anywhere in method body 
    z = 7

    #variables are mutable, will refer to a another object
    z += 5
    
    if x > y 
      false   #needs then clause on separate line
    else
      x + y * z
    end #ends if statement
    
  end #ends method definition

end  #ends class definition 

#Top level variables
#contents of a variable is reference to some object
def s
  A.new
end

class B
  def m1
    4
  end

  def m3 x
    #call given arg object's method abs and current object's
    #(since we are executing method m3) m1
    
    #call another method on same object with self.m1()
    #or syntactic sugar just m1() = implicitely self
    
    #method returns its last expression, there is also explicit return statement
    x.abs * 2 + self.m1 
  end
end

# returning self is convenient for "stringing method calls"
class C
  def m1
    print "hi "
    #next expression on next line is to return the whole object
    self
  end
  def m2
    print "bye "
    self
  end
  def m3
    print "\n"
    self
  end

  def m4
    print "yes";self #separate statements on same line with ;
  end
end

# Every value in Ruby is a reference to an object
# Every expression evaluates to an object and the only operation on an object
#is to call methods on it
# can call methods on anything (though might get "udnefined method" error
# Almost everything is method call (with some syntactic sugar)
# e.g. 3+4 is 3.+(4) calling + method on object number 3 with arg 4
# 2.0/3 is 2.0./(3)
#"s"+"e" is "s".+("e")

# nil = the object you use when you don't have any data (like ml unit ()
# or null in Java, C, C++
# counts as false in if statement along false
# nil.nil? returns true while 0.nil? false

# Reflection at run-time: learn about the program while it's running :
# - what methods it has (what an object can do) e.methods return array
# - what is the class of this object : e.class
# Useful in REPL to explore and debug a program
#e.g. 3.methods gets all methods on Number objects, 3.class Integer


# example uses (can type into irb)
# here in a multiline comment, which is not well-known
=begin
a = A.new
thirty_four = a.m1
b = B.new
four = b.m1
forty_seven = B.new.m3 -17
thirty_one = a.m2(3,four)

c = C.new
c.m1.m2.m3.m1.m1.m3
=end
