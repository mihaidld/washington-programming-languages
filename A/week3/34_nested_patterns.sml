(* Programming Languages, Dan Grossman *)
(* Section 2: Nested Patterns *)

(* We can nest patterns as deep as we want
- if pattern is a variable (x) or the wildcard (_), the match succeeds (and
variable x for variable case is bound to value v (between "case" and "of"))
All the other cases are recursive = they build out of smaller nested patterns
- Tuple pattern p is (pattern1,..., patternn) and v is (value1, ..., valuen)
then match succeeds if and only if pattern1 matches value1,..., patternn matches
valuen. If match then various bindings are introduced all with unique names,
there can not be 2 new variables called x
- pattern with Constructor: C p1, the match succeeds is value is C v1 (same
constructor) and p1 matches v1 (value matches pattern).
p1 is usually a tuple*)

exception ListLengthMismatch

(* Before pattern matching (easy to miss a case), don't do this *)
fun old_zip3 (l1,l2,l3) = 
    if null l1 andalso null l2 andalso null l3
    then []
    else if null l1 orelse null l2 orelse null l3
    then raise ListLengthMismatch (*if any is null raise runtime exception*)
    else (hd l1, hd l2, hd l3) :: old_zip3(tl l1, tl l2, tl l3)

(* don't do this: wrong pattern matching, messy, all possibilities empty/not *)
fun shallow_zip3 (l1,l2,l3) =
    case l1 of (*pattern match on l1*)
	[] => 
	(case l2 of 
	     [] => (case l3 of
			[] => [](*if all 3 empty return empty list*)
		      (*otherwise raise exception since l1 and l2 empty,
		       *but l3 is not*)
		      | _ => raise ListLengthMismatch)
	   (*otherwise raise exception since l1 empty, but l2 is not*)
	   | _ => raise ListLengthMismatch)
      | hd1::tl1 => 
	(case l2 of
	     (*raise exception since l1 non-empty, but l2 is*)
	     [] => raise ListLengthMismatch
	   | hd2::tl2 => (case l3 of
			      (*raise exception since l3 empty, but l1,l2 not*)
			      [] => raise ListLengthMismatch
			    | hd3::tl3 =>
			      (* all non-empty so cons triple of their heads
			       * on top of recursion on tails*)
			      (hd1,hd2,hd3)::shallow_zip3(tl1,tl2,tl3)))

(* do this: patterns appear inside other patterns*)
fun zip3 list_triple =
    case list_triple of (*pattern match on triple of lists: we have 3 patterns*)
	(*pattern for a tuple (,,) with 3 patterns of lists [] inside of it
	 will match a value of triple of 3 empty lists*)
	([],[],[]) => []
      (*pattern for a tuple (,,) with 3 nested patterns of non-empty lists
       *hd1::tl1... inside of it will match a value of triple of non-empty lists
       *If it matches we bind 6 variables: hd1-3, tl1-3, then return list
       consed with triple of heads onto recursion on triple of tails*)
      | (hd1::tl1,hd2::tl2,hd3::tl3) => (hd1,hd2,hd3)::zip3(tl1,tl2,tl3)
      (*new pattern _ which matches everything and doesn't bind any variables *)
      | _ => raise ListLengthMismatch

(* and the inverse, take a list of triples and return 3 lists *)
fun unzip3 lst =
    case lst of
	[] => ([],[],[]) (*empty then return 3 empty lists*)
      (*pattern match non-empty list, instead of x::xs or hd::tl use nested
       pattern to match hd pf the list against triple pattern (,,) so
       a,b,c are bound to the 3 components of head of the list, tl is bound to
       rest of list.
       In let expression we call recursively unzip3 on tail to get 3 lists with
       rest of elements.
       we bind the 3 lists to l1,l2,l3 using pattern matching*)
      | (a,b,c)::tl => let val (l1,l2,l3) = unzip3 tl
		       in
			   (*return triple of lists obtained from heads on top
			    of rests*)
			   (a::l1,b::l2,c::l3)
		       end
