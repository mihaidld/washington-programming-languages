(* Programming Languages, Dan Grossman *)
(* Section 3: Lexical Scope *)

(* Function bodies can use any bindings in scope.
 For functions being passed as arguments they can use any bindings in their
 lexical scope = the environment we had when the function was defined, not when
 it was called*)

(* 1 *) val x = 1
(*in top-level environment x maps to 1*)

(* 2 *) fun f y = x + y
(*in top-level environment we add f which maps to a function that adds 1
(because when f was defined x mapped to 1) to its argument,
in the future it will always add 1 to its argument, no matter
where it is called, even if x is then bound to another value*)

(* 3 *) val x = 2
(*we shadow previous x, in top-level environment x maps now to 2, no effect of
f and the environment where f was defined*)

(* 4 *) val y = 3
(*in top-level environment y maps to 3*)

(* 5 *) val z = f (x + y);
(*we lookup f in the environment, we get the function that adds 1 to its arg,
 we lookup x and y in current environment ans and get 2 and 3 so we call
f 5 which evaluates the body in the old environment to 5 + 1 = 6
so z maps to 6*)

(* Closures*)
(*How can functions be evaluated in old environments that aren't around anymore?
 The language implementation actually keeps around the old environment, when the
 function was defined as necesary

 A function value has two parts:
 - the code
 - the environment that was current when the function was defined
 Like a "pair", but where we can not access the pieces, just call this "pair"
 This pair is called function closure

 A function call uses both parts of the pair: it evaluates the code part
in the environment part extended with the function argument*)

(* Line 2 creates a closure and binds f to it:
 - code: "take y and have body x + y"
 - environment: "x maps to 1" (plus whatever else is in scope, including f for
recursion)

Line 5 calls the closure defined in line 2 with 5 so body is evaluated in
environment "x maps to 1" extended with "y maps to 5"
 *)
