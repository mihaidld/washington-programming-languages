(* Programming Languages, Dan Grossman *)
(* Section 2: Useful Datatypes *)

(*Enumerations enum that don't carry other data*)
datatype suit = Club | Diamond | Heart | Spade

(* Enums, including carrying other data (Num of int)
 might need to specify ints in [2, 10]*)
datatype rank = Jack | Queen | King | Ace | Num of int

(*identify a student either by student number (an int) or
 the name: first and last name with optional middle name (strings)*)					       
datatype id = StudentNum of int 
            | Name of string * (string option) * string

(*if every person has a name and maybe student number use each-of instead of
 one-of with a record
{ student_num : int option,
first :	       	string,
middle :       	string option,
last :	       	string }
 *)

(*Expression trees using self-reference
  to define a simple arithmetic expression language*)

(*An expression is one of the following things:
 - either a constant which holds an int
 - a negation of a smaller expression (not just an int)
 - an addition of 2 smaller expressions
 - a multiplication of ...

We define a set of trees where the leaves are constants with a number attached
and the internal nodes are Negate (with 1 child) or Add/Multiply (with 2)
 *)
datatype exp = Constant of int 
             | Negate of exp 
             | Add of exp * exp
	     | Sub of exp * exp
             | Multiply of exp * exp
	     | Divide of exp * exp
	     | Tup of exp * exp
	     | IfThenElse of exp * exp * exp

(*Functions operating on recursive datatypes are usually recursive *)
(* exp -> int*)
fun eval e =
    case e of
        Constant i => i
      (*recursively call eval on e2 of type exp since it operates on exp*)
      | Negate e2  => ~ (eval e2)
      | Add(e1,e2) => (eval e1) + (eval e2)
      | Sub(e1,e2) => (eval e1) - (eval e2)
      | Multiply(e1,e2) => (eval e1) * (eval e2)
      | Divide(e1,e2) => (eval e1) div (eval e2)
      | Tup(e1, e2) => (eval e1) + (eval e2) (*to return int*)
      (*not all subexpressions need to be evaluated: e2 or e3*)
      | IfThenElse(e1, e2, e3) => if (eval e1) = 0 then (eval e2) else (eval e3)

(*computes how many additions are anywhere in the expression*)
(* exp -> int*)
fun number_of_adds e =
    case e of
        Constant i      => 0 (*no adds in it*)
      | Negate e2       => number_of_adds e2(*same number as in e2*)
      | Add(e1,e2)      => 1 + number_of_adds e1 + number_of_adds e2(*one more*)
      | Multiply(e1,e2) => number_of_adds e1 + number_of_adds e2

(*find larger int contained anywhere in the expression*)							      
(* exp -> int*)
fun max_constant e =
    (*use helper function to compute max of 2 expressions*)
    let fun max_of_two(e1, e2) =
	    (* without built-in to avoid recomputation*)
	    let val max1 = max_constant e1
		val max2 = max_constant e2;
	    in if max1 > max2 then max1 else max2 end	
    in
	case e of
        Constant i      => i
      | Negate e2       => max_constant e2(*same number as in e2*)
      | Add(e1,e2)      => max_of_two(e1, e2)
      | Multiply(e1,e2) => max_of_two(e1, e2)
    end

(*Refactoring helper function*)
fun max_constant1 e =
    (*use helper function to compute max of 2 expressions*)
    let fun max_of_two(e1, e2) =
	    (*with built-in Int.max*)
	    Int.max(max_constant1 e1, max_constant1 e2)		
    in
	case e of
        Constant i      => i
      | Negate e2       => max_constant1 e2
      | Add(e1,e2)      => max_of_two(e1, e2)
      | Multiply(e1,e2) => max_of_two(e1, e2)
    end

(*Refactoring without helper function*)
fun max_constant2 e =
    case e of
        Constant i      => i
      | Negate e2       => max_constant2 e2
      | Add(e1,e2)      => Int.max(max_constant2 e1, max_constant2 e2)
      | Multiply(e1,e2) => Int.max(max_constant2 e1, max_constant2 e2)
	
val example_exp : exp = Add (Constant 19, Negate (Constant 4))
(*every value of type exp looks like this tree:
       Add  - root with 2 children  
        /\
Constant  Negate   (Constant which holds a 19) and Negate with 1 child
   |        |
  19     Constant
            |
            4
 *)

val example_ans : int = eval example_exp

val example_addcount = number_of_adds (Multiply(example_exp,example_exp))

val nineteen = max_constant example_exp
val test1 = (19 = max_constant example_exp) andalso
	    (19 = max_constant1 example_exp) andalso
	    (19 = max_constant2 example_exp)
