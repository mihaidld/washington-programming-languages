(* Programming Languages, Dan Grossman *)
(* Section 8: Binary Methods With Functional Decomposition *)

(*
Situation is more complicated when operations are defined over multiple
arguments that can have different variants
Add now works with any pair of Int, String or Rational by concatenating if
either arg is String, else math addition.
Need to make new 2D-grid just for Add case in eval operation: it's a binary
operation with left and right operands, there are 3 types of operands so 9 cases
We use helper function add-values to make code clearer in eval's Add case.
*)

datatype exp = 
    Int    of int 
  | Negate of exp 
  | Add    of exp * exp 
  | Mult   of exp * exp
  | String of string  
  | Rational of int * int

exception BadResult of string;

(* FP functional decomposition of 2D-grid for adding 2 values among 3 variants.
 We keep eval operation unchanged, just add new cases for all combinations
 possible inside helper function add_values.
 It's good to use commutative to avoid code duplication, here only in 1 case *)
fun add_values (v1,v2) =
    case (v1,v2) of
	(Int i,  Int j)         => Int (i+j)
      | (Int i,  String s)      => String(Int.toString i ^ s)
      | (Int i,  Rational(j,k)) => Rational(i*k+j,k)
					   
      (* not commutative with (Int,String) since order matters *)
      | (String s,  Int i)      => String(s ^ Int.toString i) 
      | (String s1, String s2)  => String(s1 ^ s2)
      | (String s,  Rational(i,j)) => String(s ^ Int.toString i ^ "/" ^ Int.toString j)
      (* commutative: avoid duplication since already covered case
	 (Int,Rational) *)
      | (Rational _,    Int _)    => add_values(v2,v1) 
      | (Rational(i,j), String s) => String(Int.toString i ^ "/" ^ Int.toString j ^ s)
      | (Rational(a,b), Rational(c,d)) => Rational(a*d+b*c,b*d)
      | _ => raise BadResult "non-values passed to add_values"

fun eval e = 
    case e of
	Int _       => e
      | Negate e1   => (case eval e1 of 
			    Int i => Int (~i)
			  | _ => raise BadResult "non-int in negation")
      (*Add works with 3 types *)
      | Add(e1,e2)  => add_values (eval e1, eval e2)
      (*Mult raises exception if both not Ints*)
      | Mult(e1,e2) => (case (eval e1, eval e2) of
			    (Int i, Int j) => Int (i*j)
			  | _ => raise BadResult "non-ints in multiply")
      | String _    => e (*value so return expression*)
      | Rational _  => e(*value so return expression*)

fun toString e =
    case e of
	Int i       => Int.toString i
      | Negate e1   => "-(" ^ (toString e1) ^ ")"
      | Add(e1,e2)  => "("  ^ (toString e1) ^ " + " ^ (toString e2) ^ ")"
      | Mult(e1,e2) => "("  ^ (toString e1) ^ " * " ^ (toString e2) ^ ")"
      | String s    => s
      | Rational(i,j) => Int.toString i ^ "/" ^ Int.toString j

fun hasZero e =
    case e of
	Int i       => i=0 
      | Negate e1   => hasZero e1
      | Add(e1,e2)  => (hasZero e1) orelse (hasZero e2)
      | Mult(e1,e2) => (hasZero e1) orelse (hasZero e2)
      | String _    => false
      | Rational(i,j) => i=0

fun noNegConstants e =
    case e of
	Int i       => if i < 0 then Negate (Int(~i)) else e
      | Negate e1   => Negate(noNegConstants e1)
      | Add(e1,e2)  => Add(noNegConstants e1, noNegConstants e2)
      | Mult(e1,e2) => Mult(noNegConstants e1, noNegConstants e2)
      | String _    => e
      | Rational(i,j) => if i < 0 andalso j < 0
			 then Rational(~i,~j)
			 else if j < 0
			 then Negate(Rational(i,~j))
			 else if i < 0
			 then Negate(Rational(~i,j))
			 else e
