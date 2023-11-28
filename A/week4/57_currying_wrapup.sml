(* Programming Languages, Dan Grossman *)
(* Section 3: Currying Wrapup *)

(* generic functions to switch how/whether currying is used *)
(* in each case, the type tells you a lot *)

(* Curry a tupled function or uncurry it =  make a curried function to take a
tuple arg
If a functions arguments are in the wrong order for the partial application I
want (e.g. I want partial application with later args, not first)
Use generic functions (higher-order wrapping functions) below to combine
functions *)

(* (('a * 'b) -> 'c) -> 'a -> 'b -> 'c*)
(*pass to curry function f which expects a pair and return same function in
 curried form*)
fun curry f x y = f (x,y)

(*convert curried function f into function that expects tuple, we get back
 fn (x,y) => f x y*)
(*('a -> 'b -> 'c) -> ('a * 'b) -> 'c*)
fun uncurry f (x,y) = f x y

(*Switching the arguments of curried function from y then x to: x then y
 since we want to partially apply it to 2nd argument instead of the 1st
It takes the arguments in the opposite order*)
fun other_curry1 f = fn x => fn y => f y x
fun other_curry2 f x y = f y x

(* example *)

(* tupled but we wish it were curried *)
fun range (i,j) = if i > j then [] else i :: range(i+1, j)

(*val countup = range 1 would not work since we use partial application, which
works on curried functions, but range expects tuple and is not curried*)
(* no problem *)
val countup = curry range 1

val xs = countup 7
