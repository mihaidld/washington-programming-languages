(* Programming Languages, Dan Grossman *)
(* Section 3: Generalizing Prior Topics *)

(* Takes as argument a function and returns a function *)
(* (int -> bool) -> (int -> int) *)
fun double_or_triple f =
    if f 7 (*calls f with 7*)
    then fn x => 2*x
    else fn x => 3*x
(*to return function double we call double_or_triple with some function
 argument so that f 7 is true e.g. 7-3 = 4 is true *)
val double = double_or_triple (fn x => x-3 = 4)
			      
(*get result function triple and call it with argument 3*)
val nine = (double_or_triple (fn x => x = 42)) 3

(* Higher-order functions over our own datatype bindings for arithmetic
 expressions*)
datatype exp = Constant of int 
	     | Negate of exp 
	     | Add of exp * exp
	     | Multiply of exp * exp

(*abstract the traversal of own datatype tree in a higher-order function
  we can pass it specific first-class functions to check if all even or below 10
  does f return true for every Constant?*)
fun true_of_all_constants(f,e) =
    case e of
	Constant i => f i
      | Negate e1 => true_of_all_constants(f,e1)
      | Add(e1,e2) => true_of_all_constants(f,e1)
		      andalso true_of_all_constants(f,e2)
      | Multiply(e1,e2) => true_of_all_constants(f,e1)
			   andalso true_of_all_constants(f,e2)

(*given an expression e, is every constant in it an even number? or
 is evey constant less than 10*)
fun all_even e = true_of_all_constants((fn x => x mod 2 = 0),e)
fun all_sub10 e = true_of_all_constants((fn x => x < 10),e)

val e1 = Constant 4
val e2 = Constant 10
val e3 = Negate e1
val e4 = Add(e1, e2)
val t = all_even e4
val f = all_sub10 e4
