(* Programming Languages, Dan Grossman *)
(* Section 1: Nested Functions *)

(* Using helper function in top level scope *)
(*	
(* int * int -> int list *)
(* produce list of ints between from and to, including them *)
(* count(3, 6) = [3, 4, 5, 6]*)
fun count (from : int, to : int) =
    if from=to
    then to::[]
    else from :: count(from+1, to)

fun countup_from1 (x : int) =
    count(1, x)
    
*)

(* Nested function count*)

fun countup_from1 (x : int) =
    let fun count (from:int, to:int) =
	    if from=to
	    then to::[] (* note: can also write [to] *)
	    else from :: count(from+1,to)
    in
	count(1,x)
    end

(*Better style : use inside local function count outer param x,
 no need to pass around to which doesn't change in natural recursion
 and there is already variable x in environment*)
	
fun countup_from1_better (x : int) =
    let fun count (from:int) =
	    if from=x
	    then x::[]
	    else from :: count(from+1)
    in
	count 1
    end

