(* Programming Languages, Dan Grossman *)
(* Section 1: Options *)

(* badly named: evaluates to 0 on empty list *)
fun old_max (xs : int list) =
    if null xs
    then 0
    else if null (tl xs)
    then hd xs
    else
	let val tl_ans = old_max(tl xs)
	in
	    if hd xs > tl_ans
	    then hd xs
	    else tl_ans
	end


(* Having max return 0 for an empty list is not good.
Solutions:
- raise an exception at run time
- return an int list instead of int: a zero element list (empty list)
in case of empty list and a 1 element list (list containing only max)
for non empty list. But type list can hold any number of elements,
not just 0 or 1. For 0 or 1 situations better use built-in type options.

t option is a type for any type t (e.g. int option, bool list option)

Building options:
- NONE has type 'a option (alpha option) builds an option that holds 0 items
- SOME e has type t option if expression e has type t. Builds option holding e.

Accessing options through functions:
- isSome has type 'a option -> bool. Takes an option and returns true if it's
a SOME and false if it's a NONE (like reverted null function for list)
- valOf has type 'a option -> 'a. Gets the thing (value) from underneath
the SOME (if option is NONE raises exception) 
*)


	    
(* better: returns an int option *)
(*fn : int list -> int option *)
	    
(*since tl_ans is an option, it can be accessed through isSome and valOf:
 if it's a SOME and its value is greater than the head of the list, then
 that's the maximum and return tl_ans else (either it's a NONE or head
 of the list is larger) so build an option out of the head of the list
 with SOME*)
	    
fun max1 (xs : int list) =
    if null xs
    then NONE (*NONE is a valid option*)
    else 
	let val tl_ans = max1(tl xs)
	in if isSome tl_ans andalso valOf tl_ans > hd xs
	   then tl_ans
	   else SOME (hd xs)
	end

(*
looks the same as max1 to clients; 
implementation avoids valOf and checking for NONE all the time before getting
to the end of the list;
uses recursive helper function max_nonempty that computes the max int of what
we now know is a non empty list (because we checked for null xs) and
wraps it in SOME to return an option
*)
fun max2 (xs : int list) =
    if null xs
    then NONE
    else let (* fine to assume argument nonempty because it is local *)
	(* int list -> int *)
	fun max_nonempty (xs : int list) =
		if null (tl xs) (* (tl xs) is 1 element list *)
		then hd xs
		else let val tl_ans = max_nonempty(tl xs)
		     in
			 if hd xs > tl_ans
			 then hd xs
			 else tl_ans
		     end
	in
	    SOME (max_nonempty xs)
	end
