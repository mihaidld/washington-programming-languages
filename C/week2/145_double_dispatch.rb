# Programming Languages, Dan Grossman
# Section 8: Binary Methods with OOP: Double Dispatch

=begin
Add new variants String and Rational is easy (new classes), but changing
addition to take any pair of Int, String and Rational is tricky in OOP
Update Add's eval method. e1 and e2 should know how to evaluate themselves, lets
send them a message to e1 first, then to e2
=end

# Note: If Exp and Value are empty classes, we do not need them in a
# dynamically typed language, but they help show the structure and they
# can be useful places for code that applies to multiple subclasses.

class Exp
  # could put default implementations or helper methods here
end

class Value < Exp
  # this is overkill here, but is useful if you have multiple kinds of
  # /values/ in your language that can share methods that do not make sense 
  # for non-value expressions
end

class Int < Value
  attr_reader :i
  def initialize i
    @i = i
  end
  def eval # no argument because no environment
    self
  end
  def toString
    @i.to_s
  end
  def hasZero
    i==0
  end
  def noNegConstants
    if i < 0
      Negate.new(Int.new(-i))
    else
      self
    end
  end
=begin
add_values needs to implement how to add self to v (which can be Int, MyString
or MyRational) but it does it depending on type of v.

Solution 1
Easy, common and good solution, but only half OOP since it uses dynamic dispatch
on first argument e1 to choose which add_values method to call (Int's, MyString
or MyRational), then in the body of the 3 add_values methods we switch to
functional programming Racket-style type tests (cond statement) for 2nd argument
e2:

def add_values v
  if v.is_a? Int
    Int.new(v.i + i)
  if v.is_a? MyRational
    MyRational.new(v.i + v.j * i, v.j)
  else
    MyString.new(i.to_s + v.s)
end
The add_values method in INt handles 3 cases, the other 6 would be handled by
same method in MyString and MyRational. 

Solution 2
Full OOP using Double dispatch
add_values in Int needs to know what kind of thing v is.
In OOP instead of asking what kind of v is, since we don't have all info to give
result, we call a method on v instead telling them what we are and
have different kinds of things implement that differently. We call method on v
and let it do the addition (can't just call v.add_values self since then v will
not know what we are and it will call back us and have infinite loop).
We tell method on v what we are (what kind of thing self is) since we know
that.
Programming trick called double dispatch = we tell v what we are by passing self
and calling different methods on v depending on what we are: if we are an Int
we call addInt (if we are MyString we call addString etc.) and v (depending on
what it is) will know how to add itself to an Int.
Each subclass of Value needs now add_values + 3 other methods: addInt, AddString
and addRational -> 9 cases 
add_values performs 2nd dispatch to the correct case of 9 depending on self.

Solution 3 Multimethods = Multiple dispatch
This works in static C# or Clojure (not Ruby) where it's also possible to have
multiple methods with same name, but different types of arguments.
Int, MyString and MyRational each define 3 methods all named add_values, but one
takes an Int, the other MyString, the 3rd MyRational -> 9 methods add_values
Then e1.eval.add_values e2.eval picks right one of the 9 at run-time using the
classes of the 2 arguments. At run-time we don't use dynamic dispatch just on
the receiver e1.eval, the one to who we send message add_values, but also on
rest of arguments (e2.eval) to pick best method if multiple methods have same
name.
Altough Java and C++ allow multiple methods with same name, they don't have
multimethods, but static overloading: they use dynamic dispatch to choose which
receiver (dynamic = decided at run-time), but then use static types of arguments
(decided by the compiler at compile-time) to choose which one of methods to call
So still need to add methods addInt, addString, addRational, je just can call
all 3 add which might be confusing

=end
  # double-dispatch for adding values
  def add_values v # first dispatch (Add's eval sent it here)
    # Sends message to v: you need to know how to add yourself to an Int so do
    # so with me
    v.addInt self
  end
  def addInt v # second dispatch: other is Int and sent me the message
    # I know how to add myself to an Int v. v is for sure an Int since it's
    # called only in Int's add_values
    Int.new(v.i + i)
  end
  def addString v # second dispatch: other is MyString (notice order flipped)
    # put other first because 1st operand (v.s), them me in concatenation
    MyString.new(v.s + i.to_s)
  end
  def addRational v # second dispatch: other is MyRational
    MyRational.new(v.i+v.j*i,v.j)
  end
end

# new value classes -- avoiding name-conflict with built-in String, Rational
class MyString < Value
  attr_reader :s
  def initialize s
    @s = s
  end
  def eval
    self
  end
  def toString
    s
  end
  def hasZero
    false
  end
  def noNegConstants
    self
  end

  # double-dispatch for adding values
  def add_values v # first dispatch
    # Sends message to v: you need to know how to add yourself to a String so do
    # so with me
    v.addString self
  end
  def addInt v # second dispatch: other is Int (notice order is flipped)
    MyString.new(v.i.to_s + s)
  end
  def addString v # second dispatch: other is MyString (notice order flipped)
    MyString.new(v.s + s)
  end
  def addRational v # second dispatch: other is MyRational (notice order flipped)
    MyString.new(v.i.to_s + "/" + v.j.to_s + s)
  end
end

class MyRational < Value
  attr_reader :i, :j
  def initialize(i,j)
    @i = i
    @j = j
  end
  def eval
    self
  end
  def toString
    i.to_s + "/" + j.to_s
  end
  def hasZero
    i==0
  end
  def noNegConstants
    if i < 0 && j < 0
      MyRational.new(-i,-j)
    elsif j < 0
      Negate.new(MyRational.new(i,-j))
    elsif i < 0
      Negate.new(MyRational.new(-i,j))
    else
      self
    end
  end

  # double-dispatch for adding values
  def add_values v # first dispatch
    v.addRational self
  end
  def addInt v # second dispatch
    v.addRational self  # reuse computation of commutative operation
  end
  def addString v # second dispatch: other is MyString (notice order flipped)
    MyString.new(v.s + i.to_s + "/" + j.to_s)
  end
  def addRational v # second dispatch: other is MyRational (notice order flipped)
    a,b,c,d = i,j,v.i,v.j
    MyRational.new(a*d+b*c,b*d)
  end
end

class Negate < Exp
  attr_reader :e
  def initialize e
    @e = e
  end
  def eval
    Int.new(-e.eval.i) # error if e.eval has no i method
  end
  def toString
    "-(" + e.toString + ")"
  end
  def hasZero
    e.hasZero
  end
  def noNegConstants
    Negate.new(e.noNegConstants)
  end
end

class Add < Exp
  attr_reader :e1, :e2
  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end
  # Recursively call e1.eval which gets a value (Int, MyString or MyRational),
  # then call result's add_values method with e2.eval. We need to add method
  # add_values to each one of Int, MyString and MyRational classes.
  def eval
    e1.eval.add_values e2.eval
  end
  def toString
    "(" + e1.toString + " + " + e2.toString + ")"
  end
  def hasZero
    e1.hasZero || e2.hasZero
  end
  def noNegConstants
    Add.new(e1.noNegConstants,e2.noNegConstants)
  end
end

class Mult < Exp
  attr_reader :e1, :e2
  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end
  def eval
    Int.new(e1.eval.i * e2.eval.i) # error if e1.eval or e2.eval has no i method
  end
  def toString
    "(" + e1.toString + " * " + e2.toString + ")"
  end
  def hasZero
    e1.hasZero || e2.hasZero
  end
  def noNegConstants
    Mult.new(e1.noNegConstants,e2.noNegConstants)
  end
end
