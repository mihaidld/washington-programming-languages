(* Programming Languages, Dan Grossman *)
(* Section 3: Introduction to First-Class Functions *)

fun double x = 2*x
fun incr x = x+1
val a_tuple = (double, incr, double(incr 7))(*putting functions in tuple*)
val eighteen = (#1 a_tuple) 9 (*pulling functions out of tuple to use them*)
