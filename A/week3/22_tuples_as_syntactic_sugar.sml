(* Programming Languages, Dan Grossman *)
(* Section 2: Tuples as Syntactic Sugar *)

(* records are like tuples with user-defined field names
   conversely, tuples are just records with names 1, 2, ..., n
   the only real difference is "by position" vs. "by name"
*)
val a_pair = (3+1,4+2)
val a_record = {second=4+2, first=3+1}

(* actually, tuples *are* just records with names 1, 2, ..., n and
 *special "by position" syntax -- our first example of "syntactic sugar"
*
* It's good style to use syntactic sugar if possible instead of semantics
* corresponding (e.g. tuple (2,5,7) instead of record {1=2,2=5,3=7} *)
		   
val another_pair = {2=5, 1=6}
(*made a record with fileds names 1 and 2 and REPL printed it out as a pair
 (6,5) : int * int *)
val sum = #1 a_pair + #2 another_pair
(*get 2nd component of a pair is like get field 2 of a record*)

val x = {3="hi", 1=true};
(* normal record {1=true,3="hi"} : {1:bool, 3:string} *)
val y = {3="hi", 2=3+2, 1=true};
(* tuple (true,5,"hi") : bool * int * string *)

(* Syntactic sugar is also:
 * e1 andalso e2 for: if e1 then e2 else false
 * e1 orelse e2 for: if e1 then true else e2*)

