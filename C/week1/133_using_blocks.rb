# Programming Languages, Dan Grossman
# Section 7: Using Blocks

# Define our own methods that use blocks
# callee does not give a name to the (potential) block argument
# block is treated differently than the method arguments
# to call the block it uses keyword yield if no passing args to block or
# yield(args) for passings args to block
# yield = let the block that presumably is there now run

#if methods wants to knwo if it was given a block to do different things
#it can call in its body block_given? which evaluates to true if block passed

class Foo
  def initialize(max)
    @max = max
  end

  def silly #method assumes was given a block and calls it with (4,5)
    yield(4,5) + yield(@max,@max)
  end

  # takes number argument base
  # start with base, counts how many steps (times will try the block)
  # till get true answer
  # block is like a callback that gets called with 10,11,12...
  def count base 
    if base > @max
      raise "reached max" #raise error
      # count assumes it takes a block, if that block returns true when passed
      # base, count returns 1, we took only 1 step, didn't need to repeat
    elsif yield base
      1

    # add 1 step to recurring of count(base+1) with same block count was called
    # pass to callee incremented base and a block that when called, will call
    # the block that I was given 
    else
      1 + (count(base+1) {|i| yield i})#yield i calls current block with i
    end
  end
end

f = Foo.new(1000)

f.silly {|a,b| 2*a - b}

#how many steps from 10 up to and including 34 since 34*34=34*34
f.count(10) {|i| (i * i) == (34 * i)} #25
