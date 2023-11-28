(* Programming Languages, Dan Grossman *)
(* Section 2: More Nested Patterns *)

(* another elegant use of "deep" patterns

Good style to use nested patterns instead of:
- nested case expressions:
case x of
        case y of
             case z of ...
-> replace with more branches of nested pattern matching

- unnecessary branches or let-expressions:
 case xs of
	[] => true
	| x :: xs'  =>
	    case xs' of [] => true
	    	        | y :: ys  => x <= y andalso nondecreasing xs'

Common idiom to match against tuple of datatypes to compare them, instead of
matching against 1st component (e.g. int list), then 2nd (e.g.(int*int))
match against the couple (the 1 argument of the function) all at once (e.g.
(int list, int * int)

Good style to use of wildcard pattern for when you do not need the data*)

(* int list -> bool*)
(*return true if at no point in the list a number is smaller than the one
  before it, false otherwise*)
fun nondecreasing xs =
    case xs of
	[] => true (*empty so true*)
		  
      (* when when we don't use the variable it's better style to use _
      _ means we don't need what's in that position, we just need that it's
      there*) 
      (*| x::[] => true *)
      | _::[] => true (*1-element list because rest of list matches [] so true*)
		     
      (*pattern matching lists with at least 2 elements, neck is 2nd element in
	list after head*)
      | head::(neck::rest) => (head <= neck andalso nondecreasing (neck::rest))


				  
(* nested pattern-matching often convenient even without recursion;
   also the wildcard pattern is good style 
   match on a pair and one or more parts of it quite useful on homework 2
 *)
(* Sign is P (positive), N (negative) or Z (zero)*)			  
datatype sgn = P | N | Z 

(* int * int -> sgn*)
(* returns sign of the product of given ints*)
fun multsign (x1,x2) =
    (*helper function to get sign of a number*)
  let fun sign x = if x=0 then Z else if x>0 then P else N 
  in
      (*pattern match on pair of calling sign with x1 and x2
       There are 9 possibilities: 3 for sign x1 * 3 for sign x2, but since
       patterns are matched in order,w can simplify to 5 cases using wildcard*)
      case (sign x1,sign x2) of
	  (Z,_) => Z(*this covers 3 cases ZZ, ZP, ZN)*)
	| (_,Z) => Z(*this covers 2 more cases PZ, NZ (ZZ already covered)*)

	(*remaining cases without Z*)
	| (P,P) => P
	| (N,N) => P
	       
	| (P,N) => N
	|   (N,P) => N
	(* | _  => N *) (*this covers 2 cases PN, NP, what is remaining, for
all other possibilities, it's shorter but more dangerous if we have forgotten
any case before*)	
  end

(* use of wild card _ for all remaining cases doesn't take advantage of type
 checker making sure we have taken care of all possible cases. If we forget a
 case (e.g. | (N,N) => P), before case _ then the type checker, because of _,
 still considers we have exhausted all possibilities. If we don't use _ case
 type checker will warn about match nonexhaustive *)

(*'a list -> int *)
(*returns length of list*)
fun len xs =
    case xs of
       [] => 0
     | _::xs' => 1 + len xs' (* we don't care about value at the head of list
			      * so use _ instead of x, but need the tail xs'
			      * because we need to call recursively len xs'*)
