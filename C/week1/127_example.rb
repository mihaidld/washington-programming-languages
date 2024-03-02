# Programming Languages, Dan Grossman
# Section 7: A Longer Example

# class for rational numbers (avoid name conflict with built-in class Rational)
# with invariants:
# - keep them in reduced form
# - with positive denominator

class MyRational

  def initialize(num,den=1) # second argument has a default
    if den == 0
      raise "MyRational received an inappropriate argument"
      #enforce invariant positive denominator
    elsif den < 0 # notice non-english word elsif
      @num = - num # fields created when you assign to them
      @den = - den
    else
      @num = num # semicolons optional to separate expressions on different lines
      @den = den
    end
    #start invariant to keep in reduced form
    reduce # i.e., self.reduce() but private so must write reduce or reduce()
  end

  #convert fraction (MyRational object) to string
  #convention in Ruby to call this method to_s
  #usually implemented on all objects
  def to_s 
    ans = @num.to_s #use numbers to_s method.e.g. 3.to_s -> "3"
    if @den != 1 # everything true except false _and_ nil objects
      ans += "/" #not whole so concatenate num.to_s, / and den.to_s
      ans += @den.to_s 
    end
    ans
  end

  #another to_s # using some unimportant syntax and a slightly different
  #algorithm
  def to_s2
    dens = "" #start tith empty string
    #funny if syntax: e1 if e2 (if e2 true then do e1)
    dens = "/" + @den.to_s if @den != 1 #change dens if @den != 1
    @num.to_s + dens
  end

  #another to_s using string interpolation like Racket's quasiquote and unquote
  #inside "" we have #{e1}, it evaluates expression e1 and converts it to string
  def to_s3
    "#{@num}#{if @den==1 then "" else "/" + @den.to_s end}"
  end

  # imperative addition
  # mutate self in-place: take another MyRational and update myself
  # convention to use ! in method name to show mutation
  def add! r
    #r provides methods to get its num and den
    #since num and den are protected accessible since r and self in same class
    a = r.num # only works b/c of protected methods below
    b = r.den # only works b/c of protected methods below
    c = @num
    d = @den
    @num = (a * d) + (b * c)
    @den = b * d
    reduce
    self # convenient for stringing calls
  end

  # a functional addition, so we can write r1.+ r2 to make a new rational
  # and built-in syntactic sugar will work: can write r1 + r2
  #since regular + is syntactic sugar for calling + method on left arg with
  #right argument 3 + 5 is sugar for 3.+ 5
  def + r
    # returns new fraction, it doesn't mutate current object
    # makes just a copy of current, then mutates it
    ans = MyRational.new(@num,@den)
    ans.add! r
    ans #since add! returns self, we don't actually need this last line 
  end
    
protected  
  # there is very common sugar for this (attr_reader)
  # the better way:
  # attr_reader :num, :den
  # protected :num, :den
  # we do not want these methods public, but we cannot make them private
  # because of the add! method above
  def num
    @num
  end
  def den
    @den
  end

private
  def gcd(x,y) # recursive method calls work as expected
    if x == y
      x
    elsif x < y
      gcd(x,y-x)
    else
      gcd(y,x)
    end
  end

  def reduce
    if @num == 0
      @den = 1
    else
      d = gcd(@num.abs, @den) # notice method call on number
      @num = @num / d
      @den = @den / d
    end
  end
end

# can have a top-level method (just part of Object class) for testing, etc.
# method defined outside explicit class gets put in the Object class
def use_rationals
  r1 = MyRational.new(3,4)
  #same as (r1.+(r1)).+ ...
  r2 = r1 + r1 + MyRational.new(-5,2)
  puts r2.to_s #"-1"
  
  #imperative update r2
  (r2.add! r1).add! (MyRational.new(1,-4))
  puts r2.to_s #"-1/2"
  puts r2.to_s2
  puts r2.to_s3
end
