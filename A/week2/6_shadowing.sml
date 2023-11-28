(* Programming Languages, Dan Grossman *)
(* Section 1: Examples to Demonstrate Shadowing *)

val a = 10;

(* a --> 10 *)

	    

val b = a * 2

val a = 5;

(* b --> 20, a --> 5
in new dynamic environment new var a shadows old variable a
 it is not a mutation or assignment statement for a *)	
	    

val c = b

val d = a

val a = a + 1

(* next line does not type-check, f not in environment *)
(* val g = f - 3  *)

val f = a * 2;

(*
val a = <hidden> : int This variable a stil exists,
 but it is shadowed in dynamic env by newer variable
also called a

val b = 20 : int
val a = <hidden> : int
val c = 20 : int
val d = 5 : int
val a = 6 : int
val f = 12 : int
*)

		

