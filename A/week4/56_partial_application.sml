(* Programming Languages, Dan Grossman *)
(* Section 3: Partial Application = calling curried functions with
too few arguments

If caller provides too few arguments, we get back a closure waiting for the
remaining arguments called Partial application.
We can save this function and have it around for when to call it with
remaining arguments*)

fun sorted3 x y z = z >= y andalso y >= x

fun fold f acc xs = (* means fun fold f = fn acc => fn xs => *)
  case xs of
    []     => acc
  | x::xs' => fold f (f(acc,x)) xs'

(* If a curried function is applied to "too few" arguments, that just returns
   a closure, which is often useful -- a powerful idiom (no new semantics) *)

(* sorted3 0 0 returns a function waiting for arg z that will check if
0 >= 0 andalso z >= 0 *)
val is_nonnegative = sorted3 0 0

(* Pass 2 args instead of 3 to get back a partial application
fold (fn (x,y) => x+y) returns a function waiting for an arg list xs that will
fold over it using f mapped to fn (x,y) => x+y and acc to 0 in its environment,
so it sums up its elements *)
val sum = fold (fn (x,y) => x+y) 0

(* In fact, not doing this is often a harder-to-notice version of
   unnecessary function wrapping, as in these inferior versions
   Better style to not write fun f x = g x (unnecessary function wrapping)
   when we can write val f = g *)

fun is_nonnegative_inferior x = sorted3 0 0 x

fun sum_inferior xs = fold (fn (x,y) => x+y) 0 xs

			   
(* another example *)

(* range 3 6 -> [3,4,5,6]*)
fun range i j = if i > j then [] else i :: range (i+1) j

(* we get a function that expects an argument j to return list of all ints
between 1 and than number*)
(* int -> int list*)
(* countup 6 -> [1,2,3,4,5,6]*)
val countup  = range 1

fun countup_inferior x = range 1 x

(* common style is to curry higher-order functions with function arguments
   first to enable convenient partial application *)

(*returns true if there exists 1 elements in the list for which predicate
returns true, otherwise returns false*)
fun exists predicate xs =
    case xs of
      [] => false
    | x::xs' => predicate x orelse exists predicate xs'

(*call exists with predicate that checks if the given arg is 7 and list that
 doesn't have 7 in it will return false*)
val no = exists (fn x => x=7) [4,11,23]

(* If we apply it to 1 arg (fn x => x=0) it returns a function that takes
a list and returns a bool*)
(* int list -> bool*)
(* cheks is any of the elements of given list is 0*)
val hasZero = exists (fn x => x=0)


(* use partial application of builtin library functions (e.g. List.map) which
are usually curried to get back a function that will increment every element of
given list*)
(* int list -> int list*)
val incrementAll = List.map (fn x => x + 1)

(* library functions foldl, List.filter, etc. also generally curried: *)

(*int list -> int list*)
val removeZeros = List.filter (fn x => x <> 0)

(* If you use partial application to create a polymorphic function and
you get a strange message about "value restriction" with warning "type vars
not generalized because of value restriction" then we can't call the function
Solution: just put back in the actually-necessary wrapping or
an explicit non-polymorphic type *)

(* does not work since the result would be a polymorphic function:
 'a list -> ('a * int) list
val removeZeros = ... works since not polymorphic: int list -> int list
 *)
(* (only an issue will polymorphic functions) *)

(* val pairWithOne = List.map (fn x => (x,1))*)

(* Workarounds *)
(* Use fun binding instead of val vinding to keep it polymorphic*)
fun pairWithOne xs = List.map (fn x => (x,1)) xs

(*Give it explicit non-polymorphic type *)
val pairWithOne : string list -> (string * int) list = List.map (fn x => (x,1))

(* this different function works fine because result is not polymorphic *)
val incrementAndPairWithOne = List.map (fn x => (x+1,1))
