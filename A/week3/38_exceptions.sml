(* Programming Languages, Dan Grossman *)
(* Section 2: Exceptions *)

(*In case of runtime condition that should produce an error
- raise exception (= throw) with raise keyword and exception name
- handle exception (= catch)*)


(*Actual implementation of function head (hd)*)
fun hd xs =
    case xs of
        []   => raise List.Empty (*this exception is already defined*)
      | x::_ => x

(*Exception binding = we define our exceptions with:

 exception MyException
 exception MyExceptionThatCarriesValues of t1 *...*tn to pass data to whoever
handles the exception

Exceptions are of type exn so declaring exceptions adds to the environment
 new Constructors for type exn*)
		    
exception MyUndesirableCondition

exception MyOtherException of int * int
(*raise MyOtherException(3,4) *)

fun mydiv (x,y) =
    if y=0
    then raise MyUndesirableCondition
    else x div y 

(*Raising exceptions
There is a difference between making exception value (of type exn) and
raising it*)

(*takes a list of ints and an exception, is empty list raises given exception
The exception value is passed to function as argument, but raised only in
1 case*)
fun maxlist (xs,ex) = (* int list * exn -> int *)
    case xs of
        [] => raise ex
      | x::[] => x
      | x::xs' => Int.max(x,maxlist(xs',ex))

val w = maxlist ([3,4,5],MyUndesirableCondition) (* 5 *)

(*Handle exceptions

expression1 handle exception1 => expression2
expression1 handle exception1(x,y) => expression2

If expression1 evaluates normally the rest is irelevant, if expression1
raises the expression exception1, catch that exception and evaluate expression2.
If expression1 raised another exception, then no match so not handled so
exception continues to propagate
 *)
		
val x = maxlist ([3,4,5],MyUndesirableCondition) (* 5 *)
	handle MyUndesirableCondition => 42

(*Compile error: uncaught exception MyUndesirableCondition*)
(*val y = maxlist ([],MyUndesirableCondition)*)

(*maxlist raises given exception, since list is empty, exception is handled
 and z bound to 42
 We try first to handle MyOtherException, but 2nd handle actually catches
 raised exception*)

(*handle 1 exception*)
val z = maxlist ([],MyUndesirableCondition) (* 42 *)
	handle MyUndesirableCondition => 42

(*handle 2 exceptions, if 1st one not caught, try to handle 2nd one*)
val t = (maxlist ([],MyUndesirableCondition) (* 42 *)
	handle MyOtherException(x,y)  => x + y)
	handle MyUndesirableCondition => 42

(*Better style to handle multiple exceptions with pattern matching
after handle*)
val u = maxlist ([],MyUndesirableCondition) (* 42 *)
	handle MyOtherException(x,y)  => x + y
	     | MyUndesirableCondition => 42

(*_ to catch any exception*)
val s = maxlist ([],MyUndesirableCondition) (* 42 *)		     
	 handle _ => 42 
					     
