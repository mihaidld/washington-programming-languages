(* Programming Languages, Dan Grossman *)
(* Section 4: What is Type Inference *)

(* ML is statically typed programming language (like C, Java), but
 implicitely typed: compiler infers types for all binding, no need to be
 explicit.

 Type inference = give every binding/expression a type such that, using these
 types, type-checking succeeds. It it's impossible to infer such types, type
 inference fails with error message*)

fun f x = (* infer val f : int -> int *) 
    if x > 3
    then 42 
    else x * 2
(*
fun g x = (* report type error since one branch's type is bool, the other's int
*) 
    if x > 3
    then true 
    else x * 2
*)
