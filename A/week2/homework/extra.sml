(* 1. Write a function alternate : int list -> int that takes a list of numbers
 * and adds them with alternating sign. For example 
 * alternate [1,2,3,4] = 1 - 2 + 3 - 4 = -2
 * alternate [1,2,3,4] = 1 - 2 + 3 - 4 = -2. *)

(* use helper with extra param sign to know pos/neg turn and reverse it
 * for next turn *)
(* int list -> int *)
fun alternate (lst : int list) =
    let fun f (lst : int list, sign : bool) =
	    if null lst
	    then 0
	    else if sign
	    then hd lst + f(tl lst, not sign)
	    else ~(hd lst) + f(tl lst, not sign)
    in f(lst, true) (*initialize sign to true*)
    end;

(* 2. Write a function min_max : int list -> int * int that takes a non-empty
 * list of numbers, and returns a pair (min, max) of the minimum and maximum
 * of the numbers in the list.*)

(* int list -> (int * int) *)
(* Assume list is at least 1-element long*)
fun min_max (lst : int list) =
    (* int list -> int *)
    let fun get_min (lst : int list) =
	    if null (tl lst) (*1-element list*)
	    then hd lst
	    else
		let val ans = get_min (tl lst)
		in if hd lst < ans
		   then hd lst
		   else ans
		end

	(* int list -> int *)
	fun get_max (lst : int list) =
	    if null (tl lst) (*1-element list*)
	    then hd lst
	    else let val ans = get_max (tl lst)
		 in if hd lst > ans
		    then hd lst
		    else ans
		 end
    in (get_min lst, get_max lst)
    end;

(* Write a function cumsum : int list -> int list that takes a list of numbers
 * and returns a list of the partial sums of those numbers. For example 
 * cumsum [1,4,20] = [1,5,25] *)

(* int list -> int list *)
fun cumsum (lst : int list) =
    (* int list * int -> int list *)
    (* use result so far accumulator in local helper *)
    let fun f (lst : int list, rsf : int) =
	    if null lst
	    then []
	    else
		let val s = hd lst + rsf (*sum = head lst + rsf*)
		in s :: f(tl lst, s)(*sum on top recursion with updated rsf*)
		end
    in f(lst, 0) (*initialize rsf to 0*)
    end;

(* 4. Write a function  greeting : string option -> string that given a string
 * option SOME name returns the string "Hello there, ...!" where the dots would
 * be replaced by name. Note that the name is given as an option, so if it is 
 * NONE then replace the dots with "you". *)

(* string option -> string *)
fun greeting (name : string option) =
    let val n = if isSome name then valOf name else "you"
    in "Hello there, " ^ n ^ "!"
    end;

(* 5. Write a function repeat : int list * int list -> int list that given a
 * list of integers and another list of nonnegative integers, repeats the
 * integers in the first list according to the numbers indicated by the second
 * list. For example: 
 * repeat ([1,2,3], [4,0,3]) = [1,1,1,1,3,3,3] *)

(* int list * int list -> int list *)
(* assume both lists have same length*)
fun repeat (lst : int list, times : int list) =
    if null lst
    then []
    else if hd times = 0
    then repeat(tl lst, tl times) (*skip 1st elements from both lists*)
    (* cons hd lst on top of recursion with same lst,
     * but 1st of times decremented by 1*)
    else hd lst :: repeat(lst, (hd times - 1) :: tl times);

(* 6. Write a function addOpt : int option * int option -> int option that given
 * two "optional" integers, adds them if they are both present (returning SOME
 * of their sum), or returns NONE if at least one of the two arguments is
 * NONE.*)

(* int option * int option -> int option *)
fun addOpt (opt1 : int option, opt2 : int option) =
    if isSome opt1 andalso isSome opt2
    then SOME (valOf opt1 + valOf opt2)
    else NONE;

(* 7. Write a function addAllOpt : int option list -> int option that given a
 * list of "optional" integers, adds those integers that are there (i.e. adds
 * all the SOME i). For example: 
 * addAllOpt ([SOME 1, NONE, SOME 3]) = SOME 4. If the list does not contain
 * any SOME i's in it, i.e. they are all NONE or the list is empty, the
 * function should return NONE *)
	
(* int option list -> int option *)
fun addAllOpt (lst : int option list) =
    (* int option list -> bool*)
    (* return true if at least 1 element is SOME*)
    let fun min1 (lst : int option list) =
	    if null lst
	    then false
	    else isSome (hd lst) orelse min1(tl lst)

	(* int option list -> int *)
	(*assume 1 element is SOME, so also min 1-element long*)
	(*return sum of values of SOME ints in list*)
	fun sumOpt (lst : int option list) =
	    if null lst
	    then 0 (*this will not count since added to some int value*)
	    else if isSome (hd lst)
	    then valOf (hd lst) + sumOpt(tl lst)
	    else sumOpt(tl lst)
    in if min1(lst)
       then SOME (sumOpt lst)
       else NONE
    end;

(* 8. Write a function any : bool list -> bool that given a list of booleans
 * returns true if there is at least one of them that is true, otherwise
 * returns false. (If the list is empty it should return false because there is
 * no true.) *)

(* bool list -> bool *)
fun any (lst : bool list) =
    if null lst
    then false
    else hd lst orelse any(tl lst);

(* 9. Write a function all : bool list -> bool that given a list of booleans
 * returns true if all of them true, otherwise returns false. (If the list is
 * empty it should return true because there is no false.) *)

(* bool list -> bool *)
fun all (lst : bool list) =
    if null lst
    then true
    else hd lst andalso any(tl lst);

(* 10. Write a function zip : int list * int list -> (int * int) list that given
 * two lists of integers creates consecutive pairs, and stops when one of the
 * lists is empty. For example: 
 * zip ([1,2,3], [4, 6]) = [(1,4), (2,6)]. *)

(* int list * int list -> int * int *)
fun zip (lst1 : int list, lst2 : int list) =
    if null lst1 orelse null lst2 (*1 list is empty*)
    then []
    else (hd lst1, hd lst2) :: zip(tl lst1, tl lst2);

(* 11. Challenge: Write a version zipRecycle of zip, where when one list is
 * empty it starts recycling from its start until the other list completes.
 * For example: 
 * zipRecycle ([1,2,3], [1, 2, 3, 4, 5, 6, 7]) = 
 * [(1,1), (2,2), (3, 3), (1,4), (2,5), (3,6), (1,7)].*)

(* int list -> int *)
(* returns length of list*)
fun length (lst : int list) =
	if null lst
	then 0
	else 1 + length (tl lst)

(* int list * int list -> (int * int) list *)
(* assume either both lists are empty or both non empty*)
    fun zipRecycle (lst1 : int list, lst2 : int list) =
	let val l1  = length lst1
	    val l2 = length lst2
			
	    (* int list * int list * int list * int -> int list *)
	    (* constructs new copy of initial list by traversing
	     * list lst, passing around initial, then reusing initial list till
	     * l reaches 0 *)
	    fun recycled_copy (initial : int list, lst : int list,
			       new : int list, l : int) =
		if l = 0
		then new
		else if null lst
			     (* reuse initial for lst, no other changes*)
		then recycled_copy(initial, initial, new, l)
		(* cons hd on top of recursion with tail,
		 * new appended with hd and l decremented by 1*)
		else hd lst :: recycled_copy(initial, tl lst,
					     new @ [hd lst], l-1)
	in
	    if l1 < l2
	    then zip(recycled_copy(lst1, lst1, [], l2), lst2)(*recycle lst1*)
	    else zip(lst1, recycled_copy(lst2, lst2, [], l1))(*recycle lst2*)
		    (*initialize new to empty list and use longest length*)
	end;

(* 12. Lesser challenge: Write a version zipOpt of zip with return type
 * (int * int) list option. This version should return SOME of a list when the
 * original lists have the same length, and NONE if they do not. *)

(* int list * int list -> (int * int) list option *)
fun zipOpt (lst1 : int list, lst2 : int list) =
    if length lst1 = length lst2
    then SOME (zip (lst1, lst2))
    else NONE;

(* 13. Write a function lookup : (string * int) list * string -> int option
 * that takes a list of pairs (s, i) and also a string s2 to look up.
 * It then goes through the list of pairs looking for the string s2 in the
 * first component. If it finds a match with corresponding number i, then
 * it returns SOME i. If it does not, it returns NONE. *)

(* (string * int) list * string -> int option *)
fun lookup (lst : (string * int) list, s2 : string) =
    let fun f (lst : (string * int) list) =
	    if null lst
	    then NONE
	    else if #1 (hd lst) = s2
	    then SOME (#2 (hd lst))
	    else lookup (tl lst, s2)
    in f lst
    end;

(* 14. Write a function splitup : int list -> int list * int list that given a
 * list of integers creates two lists of integers, one containing the
 * non-negative entries, the other containing the negative entries. Relative
 * order must be preserved: All non-negative entries must appear in the same
 * order in which they were on the original list, and similarly for the
 * negative entries. *) 

(* int list -> int list * int list *)
fun splitup (lst : int list) =
    (* int list -> int list *)
    let fun get_positives (lst : int list) =
	    if null lst
	    then []
	    else if hd lst >= 0
	    then hd lst :: get_positives(tl lst)
	    else get_positives(tl lst)
	(* int list -> int list *)
	fun get_negatives (lst : int list) =
	    if null lst
	    then []
	    else if hd lst < 0
	    then hd lst :: get_negatives(tl lst)
	    else get_negatives(tl lst)
    in (get_positives lst, get_negatives lst)
    end;

(* 15. Write a version splitAt : int list * int -> int list * int list of the
 * previous function that takes an extra "threshold" parameter, and uses that
 * instead of 0 as the separating point for the two resulting lists.*)
    
(* int list * int -> int list * int list *)
(* Uses rsf accumulator for gathering parts of resulted pair.
 * When current hd below threshold it updates rsf for next call by appending
 * hd to 1st part of rsf, else appends it to 2nd part of rsf *)
fun splitAt (lst : int list, threshold : int) =
    (* int list * (int list * int list) -> int list * int list *)
    let fun f (lst : int list, rsf : int list * int list) =
	    if null lst
	    then rsf
	    else if hd lst < threshold (*below threshold*)
	    then f(tl lst, ((#1 rsf) @ [hd lst], #2 rsf))
	    else f(tl lst, (#1 rsf, (#2 rsf) @ [hd lst]))
    in f(lst, ([],[]))(*initialize rsf to ([],[])*)
    end;

(* 16. Write a function isSorted : int list -> boolean that given a list of
 * integers determines whether the list is sorted in increasing order. *)
	    
(* int list -> boolean *)
fun isSorted (lst : int list) =
    if null lst orelse null (tl lst) (*empty or 1-element list*)
    then true
    else (hd lst) <= (hd (tl lst)) andalso isSorted (tl lst);

(* 17. Write a function isAnySorted : int list -> boolean, that given a list of
 * integers determines whether the list is sorted in either increasing or
 * decreasing order. *)

fun isSortedDesc (lst : int list) =
    if null lst orelse null (tl lst) (*empty or 1-element list*)
    then true
    else (hd lst) >= (hd (tl lst)) andalso isSortedDesc (tl lst);

(* int list -> boolean *)
fun isAnySorted (lst : int list) =
    isSorted(lst) orelse isSortedDesc(lst);

(* 18. Write a function sortedMerge : int list * int list -> int list that takes
 * two lists of integers that are each sorted from smallest to largest, and
 * merges them into one sorted list. For example: 
 * sortedMerge ([1,4,7], [5,8,9]) = [1,4,5,7,8,9].*)

(* int list * int list -> int list *)

(* 2 one-of, 4 cases simplified to 3*)

(*                 lst1  empty    int :: int list
 *lst2
 * empty                 lst1(1)     lst1(1)
 *
 * int :: int list       lst2(2)     <smallest hd> :: NR
 *)
fun sortedMerge (lst1 : int list, lst2 : int list) =
    if null lst2 (*(1)*)
    then lst1
    else if null lst1 (*(2)*)
    then lst2
    else if (hd lst1 <= hd lst2) (*(3)*)
    then (hd lst1) :: sortedMerge(tl lst1, lst2)
    else (hd lst2) :: sortedMerge (lst1, tl lst2);

(* 19. Quick sort
 * Write a sorting function qsort : int list -> int list that works as follows:
 * Takes the first element out, and uses it as the "threshold" for splitAt.
 * It then recursively sorts the two lists produced by splitAt.
 * Finally it brings the two lists together. (Don't forget that element you took
 * out, it needs to get back in at some point).
 * You could use sortedMerge for the "bring together" part, but you do not need
 * to as all the numbers in one list are less than all the numbers in the other
 *)

(* int list -> int list *)
fun qsort (lst : int list) =
    if null lst
    then []
    else let val parts = splitAt(tl lst, hd lst)
	     val left = #1 parts 
	     val right = #2 parts
	 in (qsort left) @ [hd lst] @ (qsort right)
	 end;

(* 20. Write a function divide : int list -> int list * int list that takes a
 * list of integers and produces two lists by alternating elements between the
 * two lists.  For example: 
 * divide ([1,2,3,4,5,6,7]) = ([1,3,5,7], [2,4,6]). *)

(* int list -> int list * int list *)
fun divide (lst : int list) =
    (* int list * bool * (int list * int list) -> int list * int list *)
    (* use accumulator forFirst to know to which part to append current hd *)
    (* use rsf accumulator to gather 2 parts based on sign value*)
    let fun f (lst : int list, forFirst : bool, rsf : int list * int list) =
	    if null lst
	    then rsf
	    else
		let val next = if forFirst
			       then  (#1 rsf @ [hd lst], #2 rsf)
			       else  (#1 rsf, #2 rsf @ [hd lst])
		in f(tl lst, not forFirst, next)
		end
    in f(lst, true,([],[])) (*initialize forFirst to true, rsf to ([],[])*)
    end;

(* 21. Sort of merge sort
 * Write another sorting function not_so_quick_sort : int list -> int list
 * that works as follows:
 * Given the initial list of integers, splits it in two lists using divide,
 * then recursively sorts those two lists, then merges them together with
 * sortedMerge. *)

(* not_so_quick_sort : int list -> int list *)
(* need to check also case when we reach 1-element list to avoid infinite loop
 * when dividing list of length 1 produces in 1st part a list of length 1*)
fun not_so_quick_sort (lst : int list) =
    if null lst
    then []
    else if null (tl lst) (*1-element list is sorted*)
    then lst
    else let val parts = divide(lst)
	     val left = #1 parts 
	     val right = #2 parts
	 in sortedMerge(not_so_quick_sort left, not_so_quick_sort right)
	 end;

(* 22. Write a function fullDivide : int * int -> int * int that given
 * two numbers k and n it attempts to evenly divide k into n as many times as
 * possible, and returns a pair (d, n2) where d is the number of times while 
 * n2 is the resulting n after all those divisions. Examples: 
 * fullDivide (2, 40) = (3, 5) because 2*2*2*5 = 40 and 
 * fullDivide((3,10)) = (0, 10)  because 3 does not divide 10.*)

(* int * int -> int * int *)
fun fullDivide (k : int, n: int) =
    (* int * int -> int * int *)
    (* keep track of nb of times k is divided into n while updating n*)
    let fun f (n : int, times : int) =
	    if n mod k = 0
	    then f(n div k, times+1)(*update n and times*)
	    else (times, n)(*return result since no division*)
    in f(n, 0)
    end;

(* 23. Using fullDivide, write a function factorize : int -> (int * int) list
 * that given a number n returns a list of pairs (d, k) where d is a prime
 * number dividing n and k is the number of times it fits. The pairs should be
 * in increasing order of prime factor, and the process should stop when the
 * divisor considered surpasses the square root of n.
 * If you make sure to use the reduced number n2 given by fullDivide for each
 * next step, you should not need to test if the divisors are prime:
 * If a number divides into n, it must be prime (if it had prime factors, they
 * would have been earlier prime factors of n and thus reduced earlier).
 *
 * Examples: 
 * factorize(20) = [(2,2), (5,1)]
 * factorize(36) = [(2,2), (3,2)]; 
 * factorize(1) = [].*)

(* int -> (int * int) list *)
fun factorize (n : int ) =
    (* int * int -> (int * int) list*)
    (* keep track of current divisor tried*)
    let fun f (n : int, d : int) =
	    let val ans = fullDivide(d, n)
		val times = #1 ans
		val otherFactor = #2 ans
				     
	    in if times = 0 (*n doesn't divide by current divisor*)
	       then f(n, d+1) (*continue with incremented divisor*)
		     
	       else if otherFactor = 1(*finished*)
	       then [(d, times)](*produce last pair*)
			
	       (*cons pair for current divisor on top of recursion with
		* n set to n2 and incremented divisor*)
	       else (d, times) :: f(otherFactor,d+1) 
	    end
    in if n < 2
       then [] (*no need for f with n < 2*)
       else f(n, 2) (*initialize divisor to 1st prime: 2*)
    end;

(* 24. Write a function multiply : (int * int) list -> int that given a
 * factorization of a number n as described in the previous problem computes
 * back the number n. So this should do the opposite of factorize *)

(* int * int -> int *)
(* assumes exponent e is positive integer*)
(* return base to the exponent*)
fun pow (b : int, e : int) =
    if e = 0
    then  1
    else b * pow(b, e-1)

(* (int * int) list -> int *)
fun multiply (lst : (int * int) list) =
    if null lst
    then 1
    else pow(#1 (hd lst), #2 (hd lst)) * multiply(tl lst);
    
(* 25. Challenge (hard): Write a function all_products : (int * int) list
 * -> int list that given a factorization list result from factorize creates
 * a list all of possible products produced from using some or all of those
 * prime factors no more than the number of times they are available.
 * This should end up being a list of all the divisors of the number n that
 * gave rise to the list. Example: 
 * all_products([(2,2), (5,1)]) = [1,2,4,5,10,20].
 *
 * For extra challenge, your recursive process should return the numbers in
 * this order, as opposed to sorting them afterwards. *)

(* int * int -> int list*)
(* produce list of products from a base and exponent*)
fun get_factors_from_pair (b : int, e : int) =
    if e = 0
    then [1]
    else pow(b, e) :: get_factors_from_pair(b, e-1)
					       
(*int list * int -> int list*)
(*produce list by multiplying each element by n*)
fun multiply_list (lst : int list, n : int) =
    if null lst
    then []
    else (n * (hd lst)) :: multiply_list (tl lst, n)
					 
(* int list * int list -> int list*)
(* produce list with all possible multiplications between
 * elements of 2 lists *)
(* 2 one-of, 4 cases simplified to 3*)
					 
(*                 lst1  empty    int :: int list
 *lst2
 * empty                 lst1(1)     lst1(1)
 *
 * int :: int list       lst2(2)     <hd lst1 * all lst2> :: NR lst1
 *)
					 
fun get_factors_from_lists (lst1 : int list, lst2 : int list) =
    if null lst2
    then lst1 (*(1)*)
    else if null lst1
    then lst2 (*(2)*)
    else multiply_list(lst2, hd lst1) @
	 get_factors_from_lists(lst2, tl lst1)

(* int list -> int list *)
(* copy list without duplicates using helper functions in local *)
fun remove_duplicates (loi : int list) =
    if null loi
    then []
	     (* int * int list -> bool *)
	     (* return true if n in list, false otherwise *)
    else let fun is_included (n : int, loi : int list) =
		 if null loi
		 then false
		 else hd loi = n orelse is_included(n, tl loi)

	     (* int list * int list -> int list *)
	     (* create new list with elements from loi without duplicates *)
	     fun remove_duplicates (loi : int list, new : int list) =
		 if null loi
		 then new
		 else if is_included(hd loi, new)
		 then remove_duplicates(tl loi, new)
		 else remove_duplicates(tl loi, new @ [hd loi])
	 in remove_duplicates (loi, []) (* use result so far accumulator *)
	 end
			       
(* (int * int) list -> int list *)
fun all_products (lst : (int * int) list) =
    if null lst
    then [1]
    else
	let val b = #1 (hd lst)
	    val e = #2 (hd lst)
	    val factors = get_factors_from_lists(get_factors_from_pair(b, e),
						 all_products (tl lst))
	    val no_duplicates = remove_duplicates factors
	in qsort no_duplicates (*sort list*)
	end;

(* More elegant solution to return the numbers in ascending order,
 * as opposed to sorting them afterwards*)
fun all_divisors(divisor: int, product: int): int list =
    if      divisor > product
    then    []
    else if product mod divisor = 0
    then    divisor :: all_divisors(divisor + 1, product)
    else    all_divisors(divisor + 1, product)

fun all_products1(factors: (int * int) list): int list =
    all_divisors(1, multiply factors)(*initialize divisor to 1*)     
					     
			    
    
