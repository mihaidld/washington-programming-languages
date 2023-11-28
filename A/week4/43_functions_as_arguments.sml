(* Programming Languages, Dan Grossman *)
(* Section 3: Functions As Arguments *)

(* it should *pain* us to write the next three functions separately,
   but we do not have to *)
(* increments x, n times *)
fun increment_n_times_lame (n,x) = (* silly example, this is addition (n+x) *)
   if n=0
   then x
   else 1 + increment_n_times_lame(n-1,x)

(* doubles x, n times *)
fun double_n_times_lame (n,x) = (* 2^n * x *)
   if n=0
   then x
   else 2 * double_n_times_lame(n-1,x)

(* gets tail of (tail of ...) n times of input list
   like drop (l, i) returns what is left after dropping the first i elements of
   the list l. *)
(* eg. nth_tail_lame(3, [4,8,12,16]) -> [16] *)
fun nth_tail_lame (n,xs) =
   if n=0
   then xs
   else tl (nth_tail_lame(n-1,xs))

(* The 3 functions are similar:
- take 2 arguments,
- if 1st is 0, return the 2nd one
- otherwise do something to the recursive call of 2nd argument (x/xs)
 and 1st argument decremented (n-1)*)
	   
(* this is much better: as always, abstract the common pieces into a function
   n_times(f,n,x) returns f(f(...(f(x)))) where there are n calls to f
   note: if we gave x type int, then we could not use this for lists
   argument f captures the differences between initial 3 functions   
 *)
(* applies the function f on x n times*)
fun n_times (f,n,x) = 
    if n=0
    then x
    else f (n_times(f,n-1,x))

fun increment x = x+1

fun double x = x+x

val x1 = n_times(double,4,7)
val x2 = n_times(increment,4,7)
val x3 = n_times(tl,2,[4,8,12,16]) 

(* and we can define functions that use n_times and specific function*)
fun addition (n,x) = n_times(increment,n,x) (* assumes n >=0 *)
fun double_n_times (n,x) = n_times(double,n,x)
fun nth_tail (n,x) = n_times(tl,n,x)

(* we can then use n_times for more things we did not plan on originally *)

fun triple x = 3*x

fun triple_n_times (n,x) = n_times(triple,n,x)


