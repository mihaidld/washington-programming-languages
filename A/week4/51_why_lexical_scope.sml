
(* Programming Languages, Dan Grossman *)
(* Section 3: Why Lexical Scope *)

(* Lexical scope = use environmenet where the function is defined
Dynamic scope = use environment where function is called

For variables we use lexical scope.
For exceptions dynamic scope: the exception is handled by closest handler where
it was called, not handler inside which function was defined

 *)

(* f1 and f2 are always the same, no matter where the result is used
 It doesn't matter if we change name of local variables from x to q,
the clients of the function will never know.*)

fun f1 y =
    let 
	val x = y + 1
    in
	fn z => x + y + z
    end

fun f2 y =
    let 
	val q = y + 1
    in
	fn z => q + y + z
    end

val x = 17 (* irrelevant in lexical scope, in dynamic scope it would be used
	    instead of local x in f1, while in f2 q would be undefined*)
val a1 = (f1 7) 4
val a2 = (f2 7) 4


		
(* f3 and f4 are always the same, no matter what argument is passed in *)

fun f3 g =
    let 
	val x = 3 (* irrelevant in lexical scope since not used
		   in dynamic scope if g used in its body x, 3 would be used*)
    in
	g 2
    end

fun f4 g =
    g 2

val x = 17 
val a3 = f3 (fn y => x + y)
val a4 = f3 (fn y => 17 + y)

(* under dynamic scope, the call "g 4" below would try to add a string "hi"
(from looking up x) to 4 and would have an unbound variable (looking up y),
even though f1 type-checked with type int -> (int -> int) *)

val x = "hi"
val g = f1 7 (*returns function fn z = z + 15 (since y is 7 -> 2y + 1 = 15 *)
val z = g 4(* 19 *)

(* Being able to pass closures that have free variables (private data they need)
   makes higher-order functions /much/ more useful *)
fun filter (f,xs) =
    case xs of
	[] => []
      | x::xs' => if f x then x::(filter(f,xs')) else filter(f,xs')

(* int -> (int -> bool)*)
fun greaterThanX x = fn y => y > x

(*get only ints > ~1*)
(* int list -> int list*)
fun noNegatives xs = filter(greaterThanX ~1, xs)
(*since x is ~1 we call filter((fn y => y > -1), xs).
Filter is called with closure where x in the environment has value ~1.
It does not matter that inside filter body there is an x (head of xs).*)

(*filter out all numbers less than or equal to n*)
fun allGreater (xs,n) = filter (fn x => x > n, xs)

