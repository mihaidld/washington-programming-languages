(* Programming Languages, Dan Grossman *)
(* Section 3: Unnecessary Function Wrapping *)

fun n_times (f,n,x) = 
    if n=0
    then x
    else f (n_times(f,n-1,x))

(* bad style: the if e then true else false of functions
 No need to create anonymous function which takes y and returns tl y,
 just use tl*)
fun nth_tail (n,xs) = n_times((fn y => tl y), n, xs)

(* good style: *)
fun nth_tail (n,x) = n_times(tl, n, x)

(* Reverse a list, need a shorter name for a function already defined*)
			    
(* bad style to fun binding where body just calls List.rev*)
fun rev xs = List.rev xs

val rev = fn xs => List.rev xs

(* good style: define variable rev and bind it to result of evaluating
   expression List.rev, I look it up in my environment, I get a function back,so
   rev will be bound to same function as List.rev*)
val rev = List.rev
