(* Programming Languages, Dan Grossman *)
(* Section 1: Let Expressions to Avoid Repeated Computation *)

(* badly named: evaluates to 0 on empty list *)
(* int list -> int *)
(* produce max element from list or 0 if empty list *)
fun bad_max (xs : int list) =
    if null xs
    then 0
    else if null (tl xs) (*if 1-element list return it (its head) *) 
    then hd xs
    else if hd xs > bad_max(tl xs) (* if head > max of tail of list *)
    then hd xs
    else bad_max(tl xs)

(* avoids recomputation by storing recursion on tail in tl_ans *)
(*
fun good_max (xs : int list) =
    if null xs
    then 0
    else if null (tl xs)
    then hd xs
    else
	(* for style, could also use a let-binding for (hd xs) *)
	let val tl_ans = good_max(tl xs)
	in
	    if hd xs > tl_ans
	    then hd xs
	    else tl_ans
	end
*)

(* avoids recomputation by storing recursion on tail in tl_ans *)
(* still badly named: evaluates to 0 on empty list *)
fun good_max (xs : int list) =
    if null xs
    then 0
    else if null (tl xs)
    then hd xs
    else
	(* with let-binding also for (hd xs) *)
	let val tl_ans = good_max(tl xs)
	    val h = hd xs
	in
	    if h > tl_ans
	    then h
	    else tl_ans
	end

(*
Helper functions countup and countdown

bad_max with countdown is ok because in each call we call
only once bad_max(tl xs) since head is always greater

bad_max with countup shows inefficiency of bad_max
 e.g. bad_max(countup(1, 30)) since computes twice at each call
 bad_max(tl xs):  bad_max([1, ..., 30]) calls twice bad_max([2, ..., 30])
 which  calls twice bad_max([3, ..., 30]) so with each new element added
 to list we double computation time. It's doubling at each level.
It's exponential time: 2^30 for 30-element list.
 *)
fun countup(from : int, to : int) =
    if from=to
    then to::[]
    else from :: countup(from+1,to)

fun countdown(from : int, to : int) =
    if from=to
    then to::[]
    else from :: countdown(from-1,to)

