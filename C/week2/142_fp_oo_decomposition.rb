# Programming Languages, Dan Grossman
# Section 8: OOP vs. Functional Decomposition 

=begin

How you can decompose a program:
- in functional (and procedural) programming using multiple functions. Each
function performs some operation over its arguments, each with a set of cases
(like in an ML case expression)
- in OOP using multiple classes that give behaviour to some kind of data,
each with a set of methods that perform operations over one kind of data.
These "entirely opposite" approaches are essentially a different choice in how
to arrange your code and how you expect to change/extend software

In order to implement a small programming language with expressions, we need :
- different kind of data (different variants): ints, additions, negations etc.
- different operations to perform: eval, toString, hasZero (there is a constant
0 somewhere in the expression) etc.
Any programming language that wants to implement this language needs decide
behaviour in each entry of a matrix (2D-grid). Fills every entry in matrix
in different way/style.

      | eval | toString | hasZero | ...
------|------|----------|---------|----
Int   |      |          |         |
------|------|----------|---------|----
Add   |      |          |         |
------|------|----------|---------|----
Negate|      |          |         |
------|------|----------|---------|----
...

ML approach:
- define a datatype with one constructor for each variant based on rows in grid
- one function for each column, each one with case expressions

OOP approach:
- define a superclass Exp with one abstract method for each operation =
operations to be implemented by each subclass
- define a subclass per row, for each variants Int, Add etc.
- each class implements methods eval, toString etc.

FP and OOP do same thing (fill matrix), in exact opposite way by organizing
the program "by rows" (OOP) or "by columns" (FP).
Choosing OOP or FP is personal taste, or what seems more natural depending on
type of software:
- write an interpreter in FP: to evaluate an expression need different cases,
- write a GUI in OOP: lots of different things on my screen (= different kinds
of data for buttons, labels etc.). For each graphical element how does it
respond to mouse clicks, what colour does it have, what happens if I drag it
with the mouse etc. I like to keep everything about that graphical object
together
Code layout is different in 2 approaches
=end

# Note: If Exp and Value are empty classes, we do not need them in a
# dynamically typed language, but they help show the structure and they
# can be useful places for code that applies to multiple subclasses.

# 1st super class (not necessary in dynamic language Ruby)
class Exp
  # could put default implementations or helper methods here
end

# 2nd superclass
# values are here only Int expressions
class Value < Exp
  # this is overkill here, but is useful if you have multiple kinds of
  # /values/ in your language (e.g. Int, bool, closures) that can share methods
  # that do not make sense for non-value expressions
end

# 1 class for each row in matrix
# Inside each class we fill out row for each column
# we see all operations one type of data in one place (inside one class)
class Int < Value
  attr_reader :i #instance variable that holds underlying number
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
end

class Negate < Exp
  attr_reader :e
  def initialize e
    @e = e
  end
  # get underlying expression e using getter e, recursively call its method eval
  # then assume result has getter i (is instance of Int), create new Int with
  # number negated
  def eval
    Int.new(-e.eval.i) # error if e.eval has no i method
  end
  def toString
    "-(" + e.toString + ")"
  end
  def hasZero
    e.hasZero #recursively check if subexpression hasZero
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
end
