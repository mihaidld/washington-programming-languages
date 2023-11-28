(* Programming Languages, Dan Grossman *)
(* Section 1: Let Expressions *)

(* Local variables
can be put inside a function that can be used only inside that function

Syntax:
let
	b1
	b2
	...
	bn
in
	e
end

where bi is any binding and e is any expression
All bindings are usable inside body e and are not visible outside
The type of whole let expression is the type of e.
The result of whole let expression is the result of body e.

 *)

(* int -> int *)
(* Takes an int and produces body of local expression which is an int*)
fun silly1 (z : int) =
    let val x = if z > 0 then z else 34
	val y = x+z+9
    in
	if x > y then x*2 else y*y
    end
(* produce 3 + 4 = 7*)
fun silly2 () =
    let val x = 1 (* create environment where x is bound to 1*)
    in
	(* 1st operand of + create inner environment where x shadows outer x,
	   is bound to 2, produce 3 *)
	(let val x = 2 in x+1 end) + (let val y = x+2 in y+1 end)
	(* 2nd operand use x bound to 1, so y is 3, produce 4 *)
    end
