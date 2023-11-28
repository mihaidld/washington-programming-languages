(* Programming Languages, Dan Grossman *)
(* Section 4: Another Equivalent Structure *)

(* this signature hides gcd and reduce.  
That way clients cannot assume they exist or 
call them with unexpected inputs. *)
signature RATIONAL_A = 
sig
datatype rational = Frac of int * int | Whole of int
exception BadFrac
val make_frac : int * int -> rational
val add : rational * rational -> rational
val toString : rational -> string
end

(* the previous signature lets clients build 
 any value of type rational they
 want by exposing the Frac and Whole constructors.
 This makes it impossible to maintain invariants 
 about rationals, so we might have negative denominators,
 which some functions do not handle, 
 and print_rat may print a non-reduced fraction.  
 We fix this by making rational abstract. *)
signature RATIONAL_B =
sig
type rational (* type now abstract *)
exception BadFrac
val make_frac : int * int -> rational
(* val make_frac : rational -> rational
would make module unusable since all functions expect rationals and there is no
way to make one since rational is abstract and not possible to create first
rational with make_frac which also expects a rational (not known types
like int*int). So make_frac(2,3) would raise error since it expects rational arg
The module's make_frac function internally actually has type rational->rational
or int*int -> int*int, but in signature externally  make_frac couldn't take a
rational, must take int*int*)

val add : rational * rational -> rational
val toString : rational -> string
end
	
(* as a cute trick, it is actually okay to expose
   the Whole function since no value breaks
   our invariants, and different implementations
   can still implement Whole differently.
*)
signature RATIONAL_C =
sig
type rational (* type still abstract *)
exception BadFrac
val Whole : int -> rational 
(* client knows only that Whole is a function int -> rational, but internally
 it's 'a -> 'a * int. Type-checker accepts because the implementation is more
 general so 'a can be instantiated with int so it becomes int -> int*int which
 is the same as int -> rational*)
val make_frac : int * int -> rational
val add : rational * rational -> rational
val toString : rational -> string
end 

(*Given a signature with abstract type, different structures can:
- have that signature
- but implement the abstract type differently

This structure uses a different abstract type: instead of datatype
binding with 2 constructors, it uses type synonim for pair of ints
It does not even have signature RATIONAL_A (no datatype rational)  
For RATIONAL_C, we need a function Whole.
This implementation is equivalent to previous examples under RATIONAL_B and
RATIONAL_C
*) 
structure Rational3 :> RATIONAL_B (* or C *)= 
struct 
   type rational = int * int
   exception BadFrac
	     
   fun make_frac (x,y) = 
       if y = 0
       then raise BadFrac
       else if y < 0
       then (~x,~y)
       else (x,y)

   (*'a -> 'a * int*)
   fun Whole i = (i,1)

   fun add ((a,b),(c,d)) = (a*d + c*b, b*d)

   (*more work since we reduce and treat whole numbers specially only in this
    function, not for make_frac and add
    Doesn't print denominator (prints it as whole number) if numerator is 0 or
    reduced denominator is 1*)
   fun toString (x,y) =
       if x=0
       then "0"
       else
	   let fun gcd (x,y) =
		   if x=y
		   then x
		   else if x < y
		   then gcd(x,y-x)
		   else gcd(y,x)
	       val d = gcd (abs x,y)
	       val num = x div d
	       val denom = y div d
	   in
	       Int.toString num ^ (if denom=1 
				   then "" 
				   else "/" ^ (Int.toString denom))
	   end
end
