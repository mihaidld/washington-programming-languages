# Programming Languages, Dan Grossman
# Section 7: Subclassing

# A class definition has a superclass (Object if not specified),
# includes everything in the superclass,
# subclass inherits all method definitions, but can override method definitions
# as desired (define different method with same name)
# syntax: class SubClassName < SuperClassName
# e.g. class ColorPoint < Point ...

# instance variables are not part of class definitions, they are not inherited,
# they come into being as part of methods being called by assigning to them

#class to represent points on a plane with x and y coordinates
class Point
  attr_accessor :x, :y #defines 4 methods getters and setters for @x and @y

  def initialize(a,b)
    @x = a
    @y = b
  end

  #uses instances variables
  def distFromOrigin
    Math.sqrt(@x * @x  + @y * @y) # why a module method? Less OOP :-(
  end
  def distFromOrigin2
    Math.sqrt(x * x + y * y) # uses getter methods (4 method calls)
  end

end

class ColorPoint < Point
  attr_accessor :color #we add 2 more methods: color and color=

  #replace initialize method
  # super = "I know I'm replacing my initialize method in superclass, but I
  # want to use the old one defined in superclass as a helper method to
  # initialize x and y instance variables"
  def initialize(x,y,c="clear") # or could skip this and color starts unset
    super(x,y) # keyword super calls same method in superclass
    @color = c
  end
end

# example uses with reflection
p  = Point.new(0,0)
cp = ColorPoint.new(0,0,"red")
p.class                         # Point
p.class.superclass              # Object
cp.class                        # ColorPoint
cp.class.superclass             # Point
cp.class.superclass.superclass  # Object
#method is_a? takes class object and returns true if object is of that class
#cp is a ColorPoint, but also a Point or an Object
# is_a? more useful than instance_of? since allows duck-typing, we don't
# necessarily need a ColorPoint, a Point would do also
cp.is_a? Point                  # true
#cp is instance of ColorPoint (its exact class), but not of Point
cp.instance_of? Point           # false
cp.is_a? ColorPoint             # true
cp.instance_of? ColorPoint      # true


# When use subclass?
# When we want a class that is very similar (e.g. ColorPoint is just like a
# Point, just adds some new thing color)
# In practice overuse of subclassing, might achieve result otherwise than
# subclassing

# Solution 1
# change dynamically definition of Point class to include also color
# bad style if changing Point which was implemented by a library and could
# enforce some invariants under the hood.
# Also not modular since if I add color, others z coordinate, Point gets bloated

class Point1
  attr_accessor :color

  def initialize(a,b,c="clear")
    @x = a
    @y = b
    @color = c
  end

end

# Solution 2
# could create new class and copy/paste methods from Point
# it's modular, Point and ColorPoint1 completely separate, any changes to Point
# class will not affect how instances of ColorPoint1 behaves.
# Disadvantage is copies code, no code reuse, can duplicate bugs

class ColorPoint1
   attr_accessor :x, :y, :color

   def initialize(a,b,c="clear")
        ...
   end

   ... 
end

# Solution 3 Best (altough not god for ColorPoint)
# could use a Point instance variable. Instances of ColorPoint2 have inside
# an instance of Point in an instance variable (as part of their private state)
# It encapsulates inside ColorPoint2 the Point class, it's an implementation
# detail, could rename method x to foo altough it still calls x of Point
# Disadvantage: not enough code reuse, since need to recreate forwarding
# methods

class ColorPoint2
   attr_accessor :color #getter/setter for color

   def initialize(a,b,c="clear")
     @pt = Point.new(a,b)
     @color = c
   end
   def x
     @pt.x #forwards message, calls x method on underlying Point
   end
   ...#similar "forwarding" methods for y, x= and y= 
end
