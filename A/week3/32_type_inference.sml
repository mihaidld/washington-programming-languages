(* Programming Languages, Dan Grossman *)
(* Section 2: A Little Type Inference *)

fun sum_triple1 (x, y, z) =
    x + y + z

fun full_name1 {first=x, middle=y, last=z} =
    x ^ " " ^ y ^ " " ^ z

(*Error: unresolved flex record (need to know the names of ALL the fields*)
(*
fun sum_triple2' triple =
	   #1 triple + #2 triple + #3 triple

fun full_name2' r =
      #first r ^ " " ^ #middle r ^ " " ^ #last r
*)
			    
(* these versions will not type-check without type annotations (must specifiy
triple : int*int*int and r : {first:string, middle:string, last:string}
because the type-checker cannot figure out if there might be other fields
 When we extract values in function body with #1 or #middle, type checker can
 assume it might be a tuple of 4 or record with more than 3 fields*)
fun sum_triple2 (triple : int*int*int) =
	   #1 triple + #2 triple + #3 triple

fun full_name2 (r : {first:string, middle:string,
                    last:string}) =
      #first r ^ " " ^ #middle r ^ " " ^ #last r

(* Unexpected polymorphism*)
					       
(* these functions are polymorphic: type of y can be anything because they don't
 use all the pieces they were pattern matched against. Type checker decides
 the functions are more general than I intended so uses type 'a instead
 of int
 *)
					       
(* x and z are added so must be ints, but y not used can be anything
 int * 'a * int -> int *)
fun partial_sum (x, y, z) = 
    x + z

(* string * 'a * string -> string *)
fun partial_name {first=x, middle=y, last=z} =
    x ^ " " ^ z
