# Programming Languages, Dan Grossman
# Section 8: Multiple Inheritance

=begin
Allow having >1 superclass could be usefull
E.g. make a ColorPt3D (x,y,z coordinates, color) inherit from a Pt3D (x,y,z) and
ColorPt(x,y,color) / Color(color).
StudentAthlete class inherits from Student and Athlete

3 solutions for different languages
- Multiple inheritance = allow >1 superclass (e.g. C++)
- Ruby Mixins = 1 superclass, >1 method providers
- Interfaces (Java, C#)  = allow >1 types

In relationship with another subclass/superclass a class can be:
- immediate subclass (N-1) or superclass (N+1). E.g. A is immediate class of B
if A lists as its superclass B
- transitive subclass = inheritance through other classes in between (N+2, N-3)
If A subclass of B, B of C then A subclass of C, but not immediate one

Single inheritance = all subclass relationships form a tree, class hierarchy is
a tree:
- nodes are classes
- parent is immediate superclass
- any number of children allowed
   A
  /|\
B  C  D
|
E

Multiple inheritance = class hierarchy no longer a tree, but a directed acyclic
graph.
- class can have multiple parents (in addition to multiple children)
- cycles still disallowed
- multiple possible paths between X and Y
- if multiple paths show that X is a (transitive) superclass of Y, we have
diamonds
   X
  /  \
V     W
 \    |
  \   Z
   \ /
    Y

Problems with multiple inheritance:
-if both V and Z define method m, which one Y inherits?
Solution would be directed resends (e.g. Z::super calls method with same name
in parent Z)
- if X defines method m that Z but not V overrides, which m inherits Y?
Solution could use directed resends, but sometimes might want one method
to win (e.g. ColorPt3D wants Pt3D's override of distToOrigin to win to include
z)
-if X defines a field (instance variable) f should Y have one copy of it f or
two (V::f and Z::f)? Both useful so C++ supports different forms of inheritance
E.g. when we need 1 field: ColorPt3D would want only one coordinate system x,y
altough x and y are in both parents ColorPt and Pt3D
E.g. need 2 fields with same name pocket: Class Person defines instance variable
pocket, both sublclasses of Person Artist and Cowboy define method draw to
access pocket for brush objects/gun objects. Class ArtistCowboy wants 2 pockets,
one for each draw method to avoid when wanting to draw image to access gun
pocket

=end


class Pt
  attr_accessor :x, :y
  def distToOrigin
    Math.sqrt(x * x  + y * y)
  end
end

class ColorPt < Pt
  attr_accessor :color
  def darken # error if @color not already set
    self.color = "dark " + self.color
  end
end

class Pt3D < Pt
  attr_accessor :z
  def distToOrigin
    Math.sqrt(x * x  + y * y + z * z)
  end
end


# This does not exist in Ruby (or Java/C#)
# It works in a language with multiple inheritance (in C++)
# class ColorPt3D_3 < ColorPt, Pt3D
# end

# In Ruby in orde to achieve this we need to copy code and repeat things
# two ways we could actually make 3D Color Points:

# subclass ColorPt and add features missing from Pt3D
class ColorPt3D_1 < ColorPt
  attr_accessor :z
  def distToOrigin
    Math.sqrt(x * x  + y * y + z * z)
  end
end


# subclass Pt3D and add features missing from ColorPt
class ColorPt3D_2 < Pt3D
  attr_accessor :color
  def darken # error if @color not already set
    self.color = "dark " + self.color
  end
end
