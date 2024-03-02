# Programming Languages, Dan Grossman
# Section 8: Extending software = Adding Operations or Variants

=begin
Need to extend software to add more features to the program: one more variant
(Mult) and operation (noNegConstants) which removes all negative expressions.
When decomposing program in first place need to think about what could be
extended easily

      | eval | toString | hasZero | noNegConstants
------|------|----------|---------|--------------
Int   |      |          |         |
------|------|----------|---------|--------------
Add   |      |          |         |
------|------|----------|---------|--------------
Negate|      |          |         |
------|------|----------|---------|--------------
Mult  |      |          |         |

- FP add new column: easy. Write new function), it doesn't affect existing
functions which keep working.
- FP add new row: difficult, Add new constructor to datatype, need to add new
case in each old function. ML static type-checker helps by providing to-do list
by saying which pattern matching is now not exhaustive (if avoided wildcard
patterns)

- OOP add new row (variant): easy. Write new class), the other classes keep
working
- OOP add new column: difficult. Modify each class to add new method.
Static Java type-checker helps to check that all subclasses implement new
method specified in superclass, gives to-do list
If we know from the beginning that we will never need to add in the future new
operations, but will need to add many different kinds of data it's better to use
OOP.

If I prefer a style and want to plan for the difficult extensibility (e.g. OOP
add new operation) without changing existing code (need to add new method in
existing classes) there are workarounds:
- FP plan for add new data in the future: change from the beginning datatype
binding and all functions to have an Other case, then expect that a user of
library might instantiate that new possibility in some way (Other float, Other
bool  etc.) and pass some higher order function arguments to all operations
saying how to handle that new case (if Other float convert it to int, if Other
bool Int 1 for true etc.) 
- OOP plan for add new operations in the future = Visitor Pattern. Make sure
that all classes have certain methods that accept "visitors". e.g method visit
takes visitor arg. Clients who want to add new operations (e.g. divide) , define
visitors and pass then to these class methods (e.g. call Int' s visit with
function divide which takes 2 Ints and produces new Int with underlyings divided
)

But difficult to make predictions about future extensions or might expect both
adding operations and data types (e.g. Scala tries to make easy extensibility
for both cases).
If original code supports extensibility (e.g. Other/ visitors) can be difficult
to understand, so languages can prevent extensibility.
e.g. ML to prevent adding operations on datatype you abstract it and hide it
inside a module, in OOP Java to prevent subclasses or method overriding use
keyword final

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
    # if underlying i negative, return new object Negate with subexpression
    # new Int with positive i, otherwise return self
    if i < 0
      Negate.new(Int.new(-i))
    else
      self
    end
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
  def eval 
    Int.new(e1.eval.i + e2.eval.i) # error if e1.eval or e2.eval has no i method
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
