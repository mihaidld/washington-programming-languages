(* Programming Languages, Dan Grossman *)
(* Section 1: simple functions *)

(* define functions 
 fun x0 (x1 : type1, ..., xn : typen) = expression

List of arguments each one with its type.
 The expression is function body which gets evaluated at function call,
not when adedd to dynamic environment.
 A function is a value which gets added to dynamic environment so
 later expressions can call it
Type of function is (type1 * ... * typen -> y) It consumes arguments
 of type 1, ,,, n and produces type t
 *)

(* this function correct only for y >= 0 *)
(*define function pow*)
fun pow (x:int, y:int) = 
    if y=0
    then 1
    else x * pow(x,y-1)

fun cube (x:int) =
    pow(x,3)

val sixtyfour = cube(4)

val fortytwo = pow(2,2+2) + pow(4,2) + cube(2) + 2
