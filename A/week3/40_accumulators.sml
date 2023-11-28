(* Programming Languages, Dan Grossman *)
(* Section 2: Accumulators *)

(*Methodology to refactor to tail recursion:
 - create helper function that takes an accumulator
 - old base case becomes initial accumulator
 - new base case becomes final accumulator
This works when we can combine results in any order (from 0 to n or
from n to 0), e.g. sum or multiplication are commutative
n + n-1 + 1 = 1 +...+ n-1 + n
 *)

(*sum up elements of list*)
(*int list -> int *)
fun sum1 xs =
    case xs of
        [] => 0
      | i::xs' => i + sum1 xs'

(*Tail recursive version*)
fun sum2 xs =
    let fun f (xs,acc) =
            case xs of
                [] => acc
              | i::xs' => f(xs',i+acc)
    in
        f(xs,0)
    end

(*'a list -> 'a list*)
(*reverses list*)
(*inefficient to append quadratic O(n^2) because append always copies the list
which is its first argument, each recursive call traverses the first list
to copy it. So 1 + 2 + ... + (length-1) is almost length*length/2

Avoid list-append (especially to result of recursive call) better use cons*)
	
fun rev1 xs =
   case xs of
       [] => []
     | x::xs' => (rev1 xs') @ [x] 

(*Tail recursive version*)
fun rev2 xs =
    let fun aux(xs,acc) =
            case xs of
                [] => acc
              | x::xs' => aux(xs', x::acc) (*efficient to cons O(1)*)
    in
        aux(xs,[])
    end
