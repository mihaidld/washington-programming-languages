(* Programming Languages, Dan Grossman *)
(* Section 2: Case Expressions *)

(*Accessing data of datatype with case expressions and pattern matching
We have several cases, each case separated by pipe (|) character

case e0 of
   pattern1 => e1
|  pattern2 => e2
...
|  patternn => en

each pattern is a constructor name with right number of variables:
e.g. Constructor1 or Constructor2 x or Constructor3(x, y)
 *)

datatype mytype = TwoInts of int * int 
                | Str of string 
                | Pizza

(* mytype -> int *)
(* Optional type of argument x: fun f (x : mytype) = ... *)
(* A multi-branch conditional to pick branch using the variant.
Find what branch matches, and bind the local variables appropriately and
in that extended environment evaluate expression on the right of => and that
is the result of whole case expression
All branches must have same type (e.g. int) *)
		      
fun f x = 
    case x of  (*case expression, x must be a value of type mytype *)
	Pizza => 3 (*if it's a Pizza, take this branch and
		    *evaluate expression after =>, so return 3*)
		     
      (* if x was made using Str constructor, s is a variable that we
	 will bind to the data under the Str constructor, it's in the scope
	 of this branch and we can use it in expression after =>*)
      | Str s => String.size s (*number of chars in string*)
		     
      (*if made using TwoInts, create local scope and let i1 be the 1st and i2
	the second of the ints passed as params to TwoInts*)
      | TwoInts(i1,i2) => i1 + i2

(*| Pizza => 4; (* if added would be redundant case: error *)*)
				   
fun i x = case x of Pizza => 3 (* missing cases: warning *)

(* Pizza, Str s and TwoInts(i1, i2) are patterns used to match (built with
the same constructor) against the value of x*)

(* mytype -> int*)
fun g x = 
    case x of
	Pizza => 3 
      | Str s => String.size s - 1
      | TwoInts(i1,i2) => i1 * i2;

(* mytype -> string *)
fun h x = 
    case x of
	Pizza => "pizza" 
      | Str s => "ingredient is " ^ s
      | TwoInts(i1,i2) => Int.toString(i1 + i2);
