(* Note that the grade might be absent (presumably because the student
unregistered from the course). *)
type student_id = int
type grade = int (* must be in 0 to 100 range *)
type final_grade = { id : student_id, grade : grade option }
datatype pass_fail = pass | fail;

(* 1. Write a function pass_or_fail of type
{grade : int option, id : ’a} -> pass_fail that takes a  final_grade (or, as
the type indicates, a more general type) and returns pass if the grade field
contains SOME i for an i≥75 (else fail). *)

(* {grade : int option, id : ’a} -> pass_fail*)
fun pass_or_fail  { id = _, grade = gr } =
    case gr of
	SOME i => if i >= 75 then pass else fail
      | NONE => fail;

(* 2. Using  pass_or_fail as a helper function, write a function has_passed of
type {grade : int option, id : ’a} -> bool that returns true if and only if
the grade field contains SOME i for an i≥75.*)

(* {grade : int option, id : 'a} -> bool *)
fun has_passed g = pass_or_fail g = pass;

(* 3. Using has_passed as a helper function, write a function number_passed that
takes a list of type final_grade (or a more general type) and returns how many
list elements have passing (again, ≥75) grades. *)

(*final_grade list -> int*)
fun number_passed xs =
    case xs of
	[] => 0
      | x::xs' => (if has_passed x then 1 else 0) + number_passed xs';

(* 4. Write a function number_misgraded of type
(pass_fail * final_grade) list -> int that indicates how many list elements are
"mislabeled" where mislabeling means a pair (pass,x) where has_passed x is 
false or (fail,x) where has_passed x is true. *)

(* bind parts of pair to variables pf and gr then check if correctly graded with
 pass_or_fail gr = pf*)
(* (pass_fail * final_grade) list -> int*)
fun number_misgraded xs =
    case xs of
	[] => 0
      | (pf,gr)::xs' => (if pass_or_fail gr = pf then 0 else 1) +
			number_misgraded xs';

datatype 'a tree = leaf 
                 | node of { value : 'a, left : 'a tree, right : 'a tree }
datatype flag = leave_me_alone | prune_me;

(* 5. Write a function tree_height that accepts an ’a tree and evaluates to a
height of this tree. The height of a tree is the length of the longest path to
a leaf. Thus the height of a leaf is 0.*)

(* 'a tree -> int *)
fun tree_height t =
    case t of
	leaf => 0
      | node {value =  _, left = tl, right = tr}
	=> 1 + Int.max(tree_height tl, tree_height tr);

(* 6. Write a function sum_tree that takes an int tree and evaluates to the sum
of all values in the nodes.*)
								  
(* int tree -> int *)
fun sum_tree t =
    case t of
	leaf => 0
      | node {value = v, left = tl, right = tr}
	=> v + sum_tree tl + sum_tree tr;

(* 7. Write a function gardener of type flag tree -> flag tree such that its
structure is identical to the original tree except all nodes of the input
containing prune_me are (along with all their descendants) replaced with a leaf.
*)

(* flag tree -> flag tree *)
fun gardener t =
    case t of
	leaf => leaf
      | node {value = v, left = tl, right = tr}
	=> if v = prune_me
	   then leaf (*convert into leaf all nodes holding prune_me flag*)
		    (*keep pruning left and right branches*)
	   else node {value = v, left = gardener tl, right = gardener tr};

(* 8. Re-implement various functions provided in the SML standard libraries for lists and options.  See http://sml-family.org/Basis/list.html and 
http://sml-family.org/Basis/option.html
Good examples include last, take, drop, concat, getOpt, and join.*)

(* last l
returns the last element of l. It raises Empty if l is nil.*)

(* 'a list -> 'a*)
fun last1 l =
    case l of
	[] => raise List.Empty
      | x::[] => x
      | head::neck::tail => last1 (neck::tail);

(* take (l, i)
returns the first i elements of the list l. It raises Subscript if i < 0 or
i > length l. We have take(l, length l) = l.*)
(* General.Subscript is an exception indicating that an index is out of range,
typically arising when the program is accessing an element in an aggregate data
structure (such as a list, string, array, or vector).*)

(* 'a list * int -> 'a list*)
fun take1 (l, i) =
    if  i < 0 orelse i > length l
    then raise General.Subscript
    else (* 0 <= i <= length l *)
	case (l,i) of
	    (_, 0) => [] (*don't take anything*)
	  (* since i >=1 list can not be empty*)
	  | (x::xs',n) => x::take1(xs',n-1);

(* drop (l, i)
returns what is left after dropping the first i elements of the list l.
It raises Subscript if i < 0 or i > length l.
It holds that take(l, i) @ drop(l, i) = l when 0 <= i <= length l.
We also have drop(l, length l) = [].*)

(* 'a list * int -> 'a list *)
fun drop1 (l, i) =
    if  i < 0 orelse i > length l
    then raise General.Subscript
    else (* 0 <= i <= length l *)
	case (l,i) of
	    (_, 0) => l (* i = 0 so return full remaining list*)
	  (* since i >= 1 list can not be empty*)
	  | (x::xs',n) => drop1(xs',n-1);

(* concat l
returns the list that is the concatenation of all the lists in l in order.
concat[l1,l2,...ln] = l1 @ l2 @ ... @ ln*)

(* 'a list list -> 'a list*)
fun concat1 l =
    case l of
	[] => []
      | hl::tl => hl @ concat1 tl;


(* getOpt (opt, a)
returns v if opt is SOME(v); otherwise it returns a.*)

(* 'a option * 'a -> 'a *)
fun getOpt1 (opt, a) =
    case opt of
	SOME v => v
      | _ => a 


(* The join function maps NONE to NONE and SOME(v) to v.*)

(* 'a option option -> 'a option*)
fun join1 opt =
    case opt of
	NONE => NONE
      | SOME v => v;

(* type definition for natural numbers
A "natural" number is either zero, or the "successor" of a another integer.
So for example the number 1 is just SUCC ZERO, the number 2 is SUCC (SUCC ZERO),
and so on. *)
datatype nat = ZERO | SUCC of nat
				  
(* 9. Write is_positive : nat -> bool, which given a "natural number" returns
whether that number is positive (i.e. not zero).*)

(* nat -> bool *)
fun is_positive n =
    case n of
	ZERO => false
      | SUCC n' => true;

(* 10. Write pred : nat -> nat, which given a "natural number" returns its
predecessor. Since 0 does not have a predecessor in the natural numbers, throw
an exception Negative (will need to define it first). *)

(* nat -> nat *)
exception Negative
fun pred n =
    case n of
	ZERO => raise  Negative
      | SUCC n'=> n';

(* 11. Write nat_to_int : nat -> int, which given a "natural number" returns
the corresponding int. For example, nat_to_int (SUCC (SUCC ZERO)) = 2.
(Do not use this function for problems 13-16 -- it makes them too easy.)*)

(* nat -> int *)
fun nat_to_int n =
    case n of
	ZERO => 0
      | SUCC n' => 1 + nat_to_int n';

(* 12. Write int_to_nat : int -> nat which given an integer returns a
"natural number" representation for it, or throws a Negative exception if the
integer was negative.
(Again, do not use this function in the next few problems.)*)

(* int -> nat *)
fun int_to_nat i =
    if i < 0
    then raise Negative
    else if i = 0
    then ZERO
    else SUCC (int_to_nat (i-1));

(* 13. Write add : nat * nat -> nat to perform addition.*)

(*  nat * nat -> nat *)
fun add (n1 : nat, n2 : nat) =
    case (n1, n2) of
	(n1', ZERO) => n1'
      | (n1', SUCC n2') => SUCC (add (n1', n2'));

(* 14. Write sub : nat * nat -> nat to perform subtraction.
(Hint: Use pred). *)

(* nat * nat -> nat *)
fun sub (n1 : nat, n2 : nat) =
    case n2 of
	ZERO => n1
      | SUCC n2' => sub((pred n1), n2');
    
(* 15. Write mult : nat * nat -> nat to perform multiplication.
(Hint: Use add.) *)

(* nat * nat -> nat *)
fun mult (n1, n2) =
    case n2 of
	ZERO => ZERO
      | SUCC n2' => add (n1, mult(n1, n2'));

(*16. Write less_than : nat * nat -> bool to return true when the
first argument is less than the second.*)

(* nat * nat -> bool *)
fun less_than (n1, n2) =
    case (n1, n2) of
	(_, ZERO) => false (*if n2 is 0, n1 can't be less than 0*)
      (* n2 is positive*)
      | (ZERO, SUCC n2') => true
      | (SUCC n1', SUCC n2') => less_than (n1', n2')

(* datatype, which represents sets of integers:*)
datatype intSet = 
  Elems of int list (*list of integers, possibly with duplicates to be ignored*)
| Range of { from : int, to : int }  (* integers from one number to another *)
| Union of intSet * intSet (* union of the two sets *)
| Intersection of intSet * intSet (* intersection of the two sets *)

(* Solved 19 first which is helper for 17 and 18 *)
(* 19. Write toList : intSet -> int list that returns a list with the set's
elements, without duplicates.*)

(* Helper functions: is_included and remove_duplicates*)
			       
(* int * int list -> bool *)
(* return true if n in list, false otherwise *)
fun is_included (n, loi) =
    case loi of
	[] => false
      | x::xs' => x = n orelse is_included(n, xs')
			  
(* int list -> int list *)
(* copy list without duplicates using helper functions in local *)
fun remove_duplicates loi =
    case loi of
	[] => []
      | x::xs' =>
	
	(* int list * int list -> int list *)
	(* create new list with elements from loi without duplicates *)
	let fun remove_duplicates (loi, acc) =
		case loi of
		    [] => acc
		  | x::xs' =>
		    remove_duplicates(xs',
				      (if is_included(x, acc)
				       then acc
				       else acc @ [x]))
	in remove_duplicates (loi, []) (* use result so far accumulator *)
	end

(* Built-in List.tabulate (n, f)
returns a list of length n equal to [f(0), f(1), ..., f(n-1)], created from left
to right. It raises Size if n < 0.*)
	    
(* intSet -> int list *)
fun toList s =
    case s of
	Elems lst => remove_duplicates lst
      | Range {from = i1, to = i2} =>
	let val min = Int.min(i1, i2)
	    val max = Int.max(i1, i2)
	    (* int -> int*)
	    (* produce numbers starting from min of length
	       max-min+1 (e.g. min 2, max 2 -> [2]) *)
	    fun identity n = n + min
				     
	in List.tabulate (max - min + 1, identity)
	end
	    
      (* convert to lists both sets, append lists and remove duplicates*)
      | Union(s1, s2) => remove_duplicates((toList s1) @ (toList s2))
					  
      | Intersection(s1,s2) =>
	(*get lists l1, l2 with no duplicates*)
	let val l1 = toList s1
	    val l2 = toList s2

	    (* int list * int list -> int list*)
	    (* traverse l1 and check if its elements are in l2, is so include
	      them in acc*)
	    fun get_intersection(lst, acc) =
		case lst of
		    [] => acc
		  | x::xs' => get_intersection(xs',
					       (if is_included(x, l2)
						then acc @ [x]
						else acc))
	in get_intersection(l1,[])
	end



(* 18. Write contains: intSet * int -> bool that returns whether the set
contains a certain element or not. *)

(* intSet * int -> bool*)
fun contains (s, i) = is_included(i, toList s);
	    
	
(* 17. Write isEmpty : intSet -> bool that determines if the set is empty or
not. *)

(* intSet -> bool*)
fun isEmpty s = toList s = []
				    
				    		  
