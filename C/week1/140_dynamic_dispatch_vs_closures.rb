#  Dan Grossman, Programming Languages
#  Section 7: Dynamic Dispatch Versus Closures 

# Ruby methods use late binding: simple example:

class A
  def even x
    puts "in even A"
    if x==0 then true else odd(x-1) end
  end
  def odd x
    puts "in odd A"
    if x==0 then false else even(x-1) end
  end
end

a1 = A.new.odd 7
puts "a1 is " + a1.to_s + "\n\n"

class B < A
  #overrides even (faster result, no recusrive call), inherits odd
  def even x # changes B's odd too! (helps) because odd will call this even
    puts "in even B"
    x % 2 == 0
  end
end

# Dynamic dispatch: instance of B has a call to odd that calls even it will be
# the even from class B, which overrode even from class A
# Any method (e.g. odd) that makes calls to overridable methods (e.g. even) can
# have its behaviour changed in subclasses even if it's not overriden

# Bad result
# In ML closures are closed, when we look at definition of odd we know how it's
# going to behave (always call same even), in OOP it's calling even which might
# change in a subclass.
# Solution: avoid calling methods that call other methods overriden or
# disallow overriding by making methods private in parent class (subclass can't
# override it) or final (in Java)

# Good result
# A subclass can affect behaviour without copying code
a2 = B.new.odd 7
puts "a2 is " + a2.to_s + "\n\n"

#class C, by breaking even, breaks both even and odd since odd relies on even
class C < A
  def even x
    puts "in even C" # changes C's odd too! (hurts)
    false
  end
end

a3 = C.new.odd 7
puts "a3 is " + a3.to_s + "\n\n"

