(* Programming Languages, Dan Grossman *)
(* Section 2: Lists and Options are Datatypes *)

(*It's possible to create my own list of ints (int list) that's either:
 - empty
 - built out with Cons constructor with an int and another my_int_list	*)
datatype my_int_list = Empty 
                     | Cons of int * my_int_list
					 
val one_two_three = Cons(1,Cons(2,Cons(3,Empty))) (*like [1,2,3]*)

fun append_mylist (xs,ys) = 
    case xs of
        Empty => ys (*if xs was made by the Empty constructor*)
      (*bind x to head and xs'(xs prime) to tail of list of type my_int_list
       and create the my_int_list that you get from calling constructor Cons
       with x and the result of the recursive call *)
      | Cons(x,xs') => Cons(x, append_mylist(xs',ys))


(*Bad style*)
fun increment_or_zero0 intoption =
    if isSome intoption
    then (valOf intoption) + 1
    else 0

(* Options are a convenient predefined datatype bindings
 NONE and SOME are constructors, not just functions -> use pattern matching
with constructors NONE and SOME instead of isSome or valOf *)
	     
(*Better style*)
fun increment_or_zero intoption =
    case intoption of
        NONE => 0 (*intoption built with constructor NONE, return 0 *)
      | SOME i => i+1

(* Lists are also convenient datatype bindings
[] and infix :: are constructors (altough strange) for empty and non-empty lists
 -> do not use hd, tl, null, use pattern matching with [] and :: *)

(*sums up all elements in list*)
fun sum_list xs =
    case xs of (*pattern match on xs*)
        [] => 0 (*pattern [] matches the empty list*)
      (*let 1st element be x and add that to suk of rest of list which is in
       variable xs'*)
      | x::xs' => x + sum_list xs'

fun append (xs,ys) =
    case xs of
        [] => ys
      | x::xs' => x :: append(xs',ys)

(*own definition of null*)
fun null1 x =
    case x of
	[] => true
      | x::xs  => falsec 
    
