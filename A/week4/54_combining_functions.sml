(* Programming Languages, Dan Grossman *)
(* Section 3: Another Closure Idiom: Combining Functions *)

(* Built-in infix operator o (lowercase O) for function composition
 Function composition is associtive, it matters the order of composition,
 not the parenthesis: f o (g o h) = (f o g) o h
 Function composition is read left <- right.
Pipelines allow left -> right by creating our own infix operator

 *)

(* ('b -> 'c) * ('a -> 'b) -> 'a -> 'c *)
fun compose (f,g) = fn x => f (g x)
(*fun compose (f,g) = fn x => (f o g) x *)

(*take the absolute value of an int, convert result in real number, get square
root of that result*)
(* int -> real*)
fun sqrt_of_abs i = Math.sqrt(Real.fromInt (abs i))

(*compose 3 functions, read from right to left: first absolute value, then to
 real, then square root of that*)
fun sqrt_of_abs i = (Math.sqrt o Real.fromInt o abs) i

(*we don't need function binding so val binding is sufficient
 Unnecessary function wrapping since we don't do anything to i:
fun pattern variableName = anotherFunction variableName
-> val pattern = anotherFunction
 *)
val sqrt_of_abs = Math.sqrt o Real.fromInt o abs

(*Make up our own infix operator to write composition left -> right
1. tells the parser !> is a function that appears between its two arguments *)
infix !> 

(* operator more commonly written |> in F# programming language,
but that confuses the current version of SML Mode for Emacs,
leading to bad editing and formatting *)

(* 2. definition of the pipeline operator: a function that takes an argument x
 and a function f and calls f with x*)
fun x !> f = f x

(*Use our new operator with i and abs, this will return abs of i, that result
 goes into Real.fromInt, then get Math.sqrt of that real number*)
fun sqrt_of_abs i = i !> abs !> Real.fromInt !> Math.sqrt

(*Backup: take 2 functions, try to call first one, if not OK return result
of calling the second one*)
		      
(* Version 1 with pattern matching and 1st function returning an option
take 2 functions, run f, but if that is not right then return result of g
pattern matching on f x, f returns an option, if it's NONE, return g of x,
otherwise if it's SOME y, return that y *)

(* ('a -> 'b option) * ('a -> 'b) -> ('a -> 'b) *)
fun backup1 (f,g) = fn x => case f x of NONE => g x | SOME y => y

(*Version 2 with exceptions handled, both functions have same type
 If f called with x raises any exception (_), then call g of x instead *)
(* ('a -> 'b) * ('a -> 'b) -> ('a -> 'b)*)
fun backup2 (f,g) = fn x => f x handle _ => g x
