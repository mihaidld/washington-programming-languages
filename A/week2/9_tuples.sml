(* Programming Languages, Dan Grossman *)
(* Section 1: Pairs and Tuples *)

(* pairs = tuples with 2 parts, 2 tuples
There can be tuples with n parts (e1, e2, ..., en)
Pieces of triple (e1, e2, e3) are accessed with (#1 e) or (#3 e) 
 *)

(*
Build pairs
Syntax: (e1,e2)
Evaluation: e1 has value v1, e2 has value v2,
   then pair has value (v1, v2)
Type-checking: e1 has type t1, e2 has type t2,
   then pair has type t1*t2

Access pieces of pairs:
#1 p for first piece  with value v1 and type t1
#2 p for 2nd piece with value v2 and type t2
 *)

fun swap (pr : int*bool) =
    (#2 pr, #1 pr)

(* Type of function: (int * int ) * (int * int) -> int *)
fun sum_two_pairs (pr1 : int*int, pr2 : int*int) =
    (#1 pr1) + (#2 pr1) + (#1 pr2) + (#2 pr2)

(* returning a pair of quotient and remainder *)
(* int * int -> int * int *)
fun div_mod (x : int, y : int) = 
    (x div y, x mod y)

fun sort_pair (pr : int*int) =
    if (#1 pr) < (#2 pr)
    then pr
    else (#2 pr, #1 pr) 

(* nested pairs *)

val x1 = (7,(true,9)) (* int * (bool*int) *)

val x2 = #1 (#2 x1)  (* bool *)

val x3 = (#2 x1)      (* bool*int *)

val x4 = ((3,5),((4,8),(0,0))) (* (int * int) * ((int * int) * (int * int)) *)
