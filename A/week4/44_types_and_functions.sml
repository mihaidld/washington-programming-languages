(* Programming Languages, Dan Grossman *)
(* Section 3: Polymorphic Types and Functions As Arguments *)

(* our n_times function is polymorphic, which lets us use it for numbers, lists,
   or anything else provided f and x "agree"
     - return and argument type of f must be the same here because and only
       because result is passed back to f
 *)
(* ('a -> 'a) * int * 'a -> 'a *)
fun n_times (f,n,x) = 
    if n=0 (*n is an int because we compare it to 0*)
    then x (* n_times produce same type as x: 'a*)
    else f (n_times(f,n-1,x)) (*f takes whatever type n_times produces: 'a
			       and produces same type as n_times: 'a*)

fun increment x = x+1
fun double x = x+x
val x1 = n_times(double,4,7)       (* instantiates 'a with int *)
val x2 = n_times(increment,4,7)    (* instantiates 'a with int *)
val x3 = n_times(tl,2,[4,8,12,16]) (* instantiates 'a with int list *)

(* higher-order functions are often so "generic" are "reusable" that they have
polymorphic types ( = types with type variables)
based on "whatever type of function is passed" but not always: *)

(*There are higher-order functions that are not polymorphic *)
(* (int -> int) * int -> int*)
(* counts how many times we need to do f (f (f ... (f x))) until we get to 0
 So if x is 0 we need 0 f's, otherwise add 1 to recursive call with f and f x*)
fun times_until_zero (f,x) = 
    if x=0 then 0 else 1 + times_until_zero(f, f x)

(* note: a better implementation would be tail-recursive *)
fun times_until_zero_tr (f,x) =
    let fun f'(x, acc) =
	    if x=0 then acc else f'(f x, acc + 1)(*increment acc if x not 0*)
    in f'(x, 0)(*initialize accumulator to 0*)
    end
fun div_by_2 x = x div 2;
val four = times_until_zero(div_by_2,10)
val four_tr = times_until_zero_tr(div_by_2,10)
	
(* conversely, we have seen polymorphic functions that are not higher-order
   (= first-order functions) *)
(* 'a list -> int *)
fun len xs =
    case xs of
       [] => 0
      | _:xs' => 1 + len xs'

