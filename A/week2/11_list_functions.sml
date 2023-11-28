(* Programming Languages, Dan Grossman *)
(* Section 1: List Functions *)

(* Functions taking or producing lists *)

(* Convention for naming argument of type list in plural
xs means the Xs *)

(* int list -> int *)
fun sum_list (xs : int list) =
    if null xs (*if list is empty produce 0, proper sum over empty collection*)
    then 0
    else hd(xs) + sum_list(tl(xs))
(*else produce sum of head of current list and recursive call on tail of list*)

fun product_list (xs : int list) =
    if null xs (*if list is empty produce 1 *)
    then 1
    else hd(xs) * product_list(tl(xs))

(* int -> int list *)			      
fun countdown (x : int) =
    if x=0 (*count down from 0, no more recursion*)
    then []
    else x :: countdown(x-1)

(*appends 2 lists of ints*)
(* (int list) * (int list) -> int list*)
(* 1st implementation: creates new list with copies of elements of xs first
added 1 by 1, then when there are no more xs, link last element of copy of xs
onto list os ys without looking at each one of the ys.

It uses an alias to same ys which would cause problems in other programming
languages if the list y or z (result of appending xs to ys) can be mutated.
If we  mutate z, without realising it, we have mutated also y and viceversa.

But in ML, since there are no mutations, clients of both implementations
of append (append or append2) don't care of the way append was implemented.
As a client you don't care if the implementation uses an alias (reference
to same place in memory as another variable) or copy of what's stored
in memory under a new reference *)
fun append (xs : int list, ys : int list) = (* part of the course logo :) *)
    if null xs
    then ys
    else hd(xs) :: append(tl(xs), ys)

(* (int list) * (int list) -> int list*)
(* 2nd implementation: creates new list with copies elements of xs first
added 1 by 1, then when there are no more xs, copies elements of ys 1 by 1 *)
fun append2 (xs : int list, ys : int list) = (* part of the course logo :) *)
    if null xs
    then 
	if null ys
	then []
	else hd(ys) :: append([], tl ys) 
    else hd(xs) :: append(tl(xs), ys)

			     
			 
(* More functions over lists, here lists of pairs of ints *)

fun sum_pair_list (xs : (int * int) list) =
    if null xs
    then 0
    else #1 (hd(xs)) + #2 (hd(xs)) + sum_pair_list(tl(xs))

(* produce list with 1st component of every element pair *)
fun firsts (xs : (int * int) list) =
    if null xs
    then []
    else (#1 (hd xs))::(firsts(tl xs))

fun seconds (xs : (int * int) list) =
    if null xs
    then []
    else (#2 (hd xs))::(seconds(tl xs))


fun factorial (n : int) =
    if n = 0
    then 1
    else n * factorial (n - 1)

			   
(* Use functions already defined *)
fun sum_pair_list2 (xs : (int * int) list) =
    (sum_list (firsts xs)) + (sum_list (seconds xs))

(*By getting the countdown from n to 1, we are getting the factors
that form the factorial of n, then product_list multiplies the factorst*)
fun factorial2 (n : int) = product_list (countdown n)
