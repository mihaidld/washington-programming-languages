(* 
The client call Digit.test 10  type-checks and causes the Digit.FailTest
exception to be raised.*)

(*
signature DIGIT = 
sig
type digit = int
val make_digit : int -> digit
val increment : digit -> digit
val decrement : digit -> digit
val down_and_up : digit -> digit
val test : digit -> unit
end
*)


(* The type-checker prevents the client from calling Digit.test with the
expression Digit.test e, for any expression e that evaluates to a value v *)
(*
signature DIGIT = 
sig
type digit = int
val make_digit : int -> digit
val increment : digit -> digit
val decrement : digit -> digit
val down_and_up : digit -> digit
end
*)

(* The client call Digit.test 10  type-checks and causes the Digit.FailTest
exception to be raised.   *)
(*
signature DIGIT = 
sig
type digit = int
val make_digit : int -> digit
val increment : digit -> digit
val decrement : digit -> digit
val test : digit -> unit
end
*)

(* There are calls by clients to Digit.test that can type-check, but 
Digit.test 10 does not type-check.  *)
(*
signature DIGIT = 
sig
type digit
val make_digit : int -> digit
val increment : digit -> digit
val decrement : digit -> digit
val down_and_up : digit -> digit
val test : digit -> unit
end
*)

(* The type-checker prevents the client from calling Digit.test with the
expression Digit.test e, for any expression e that evaluates to a value v*)
    
signature DIGIT = 
sig
type digit
val increment : digit -> digit
val decrement : digit -> digit
val down_and_up : digit -> digit
val test : digit -> unit
end
    
    
structure Digit :> DIGIT =
struct
type digit = int
exception BadDigit
exception FailTest
fun make_digit i = if i < 0 orelse i > 9 then raise BadDigit else i
fun increment d = if d=9 then 0 else d+1
fun decrement d = if d=0 then 9 else d-1
val down_and_up = increment o decrement (* recall o is composition *)
fun test d = if down_and_up d = d then () else raise FailTest
end

fun maybeEven x = 
	if x = 0 
	then true
	else
	if x = 50
	then false
	else maybeOdd (x-1)

and maybeOdd y =
	if y = 0
	then false
	else 
	if y = 99
	then true
	else maybeEven (y-1);

fun mystery f xs =
    let
        fun g xs =
           case xs of
               [] => NONE
             | x::xs' => if f x then SOME x else g xs'
    in
        case xs of
            [] => NONE
          | x::xs' => if f x then g xs' else mystery f xs'
    end

fun mystery1 f = fn xs =>
    let
        fun g xs =
           case xs of
               [] => NONE
             | x::xs' => if f x then SOME x else g xs'
    in
        case xs of
            [] => NONE
          | x::xs' => if f x then g xs' else mystery f xs'
    end;

(*  This signature allows (some) clients to cause the 
NoNegativeCounter.InvariantViolated exception to be raised.*)
(*
    signature COUNTER =
sig
    type t = int
    val newCounter : int -> t
    val increment : t -> t
    val first_larger : t * t -> bool
end
*)


(*  This signature allows (some) clients to cause the 
NoNegativeCounter.InvariantViolated exception to be raised.*)
(*
signature COUNTER =
sig
    type t = int
    val newCounter : int -> t
    val first_larger : t * t -> bool
end
*)

(* This signature makes it impossible for any client to call
NoNegativeCounter.first_larger at all (in a way that causes any part of the body
of NoNegativeCounter.first_larger to be evaluated)*)

(*
signature COUNTER =
sig
    type t
    val newCounter : int -> int
    val increment : t -> t
    val first_larger : t * t -> bool
end
*)

(* This signature makes it possible for clients to call 
NoNegativeCounter.first_larger, but never in a way that leads to the 
NoNegativeCounter.InvariantViolated exception being raised.*)

(*
signature COUNTER =
sig
    type t
    val newCounter : int -> t
    val increment : t -> t
    val first_larger : t * t -> bool
end
*)

(* This signature makes it impossible for any client to call 
NoNegativeCounter.first_larger at all (in a way that causes any part of the body
of NoNegativeCounter.first_larger to be evaluated).*)
signature COUNTER =
sig
    type t = int
    val newCounter : int -> t
    val increment : t -> t
end
    
structure NoNegativeCounter :> COUNTER = 
struct

exception InvariantViolated

type t = int

fun newCounter i = if i <= 0 then 1 else i

fun increment i = i + 1

fun first_larger (i1,i2) =
    if i1 <= 0 orelse i2 <= 0
    then raise InvariantViolated
    else (i1 - i2) > 0

end
