(* 1. Write a function compose_opt :
(’b -> ’c option) -> (’a -> ’b option) -> ’a -> ’c option
that composes two functions with "optional" values.
If either function returns NONE, then the result is NONE.*)

(* ('b -> 'c option) -> ('a -> 'b option) -> 'a -> 'c option*)
fun compose_opt  f g v =
    case g v of
	NONE => NONE
      | SOME v1 => case f v1 of
		       NONE => NONE
		     | SOME v2  => SOME v2;

(*2. Write a function do_until : (’a -> ’a) -> (’a -> bool) -> ’a -> ’a.   
do_until f p x will apply f to x and f again to that result and so on until
p x is false. Example: 
do_until (fn x => x div 2) (fn x => x mod 2 <> 1) will evaluate to a function
of type int->int that divides its argument by 2 until it reaches an odd number.
In effect, it will remove all factors of 2 its argument. *)

(*('a -> 'a) -> ('a -> bool) -> 'a -> 'a*)
fun do_until f p x =
    if p x
    then do_until f p (f x)
    else x;

(* 3. Use do_until to implement factorial.*)
(*use tuple to carry (count, accumulator) and pass the tuple to functions
 undone which returns true when count part still > 1, and next which produces
 next tuple with count decremented and accumulator multiplied by current count.
 Start with count n and accumulator 1.
 Return only accumulator part from result*)
fun fact n = let fun undone (cnt,_) = cnt > 1 
		 fun next (cnt,acc) = (cnt-1,acc*cnt)
		 val (_,acc) = do_until next undone (n,1)
	     in acc
	     end;

(* 4. Use do_until to write a function fixed_point: (’’a -> ’’a) -> ’’a -> ’’a
that given a function f and an initial value x applies f to x until f x = x.
(Notice the use of '' to indicate equality types.)*)
					
(* (''a -> ''a) -> ''a -> ''a*)			       
fun fixed_point f x = do_until f (fn x => (f x) <> x) x;

(*5. Write a function map2 : (’a -> ’b) -> ’a * ’a -> ’b * ’b that
given a function that takes ’a values to ’b values and a pair of ’a values
returns the corresponding pair of ’b values.*)

(*  ('a -> 'b) -> 'a * 'a -> 'b * 'b*)
fun map2 f (x,y) = (f x,f y);

(*6. Write a function
app_all : (’b -> ’c list) -> (’a -> ’b list) -> ’a -> ’c list, so that: 
app_all f g x will apply f to every element of the list g x and concatenate
the results into a single list. For example, for fun f n = [n, 2 * n, 3 * n],
we have app_all f f 1 = [1, 2, 3, 2, 4, 6, 3, 6, 9].*)

(* ('b -> 'c list) -> ('a -> 'b list) -> 'a -> 'c list*)
fun app_all f g x = List.concat (map f (g x));

(* 7. Implement List.foldr:
foldr f init [x1, x2, ..., xn] returns f(x1, f(x2, ..., f(xn, init)...))
or init if the list is empty.*)
(*reverse list and use foldl to apply f first to previously last item*)
fun foldr2 f init xs = foldl f init (List.rev xs);

(* 8. Write a function partition : (’a -> bool) -> ’a list -> ’a list * ’a list
  where the first part of the result contains the second argument elements for
  which the first element evaluates to true and the second part of the result
  contains the other second argument elements.
  Traverse the second argument only once.

Implement partition f l
applies f to each element x of l, from left to right, and returns a pair
(pos, neg) where pos is the list of those x for which f x evaluated to true, and
neg is the list of those for which f x evaluated to false. The elements of pos
and neg retain the same relative order they possessed in l.*)

(* ('a -> bool) -> 'a list -> 'a list * 'a list*)
(* use foldl to traverse list and accumulator (pos,neg) where pos gathers
 elements of list for which p x is true, and neg the rest*)
fun partition p xs =
    foldl (fn (x,(pos,neg)) => if p x then (pos@[x],neg) else (pos,neg@[x]))
	  ([],[]) xs;

(* 9. Write a function unfold : (’a -> (’b * ’a) option) -> ’a -> ’b list that
produces a list of ’b values given a "seed" of type ’a and a function that
given a seed produces SOME of a pair of a ’b value and a new seed, or NONE if it
is done seeding.
For example, here is an elaborate way to count down from 5: 
unfold (fn n => if n = 0 then NONE else SOME(n, n-1)) 5 = [5, 4, 3, 2, 1].*)

(* ('a -> ('b * 'a) option) -> 'a -> 'b list*)
fun unfold f seed =
    let fun helper f seed acc =
	    case f seed of
		NONE => acc (*produce accumulated list*)
	      (*recursive call with updated seed and accumulator*)
	      | SOME (v,new_seed) => helper f new_seed (acc@[v])
    in helper f seed []
    end;

(* 10. Use unfold and foldl to implement factorial.*)
fun fact1 n = foldl (fn (x,acc) => x * acc) (*multiply current element by acc*)
		    1 (*init value is 1*)
		    (*get list [n, (n-1), ..., 1] with unfold*)
		    (unfold (fn n => if n = 0 then NONE else SOME(n, n-1)) n);

(* 11. Implement map using List.foldr.*)

(*traverse list from right to left with foldr and cons f of current element of
 list onto accumulated result*)
(* ('a -> 'b) -> 'a list -> 'b list*)
fun map1 f = foldr (fn (x,acc) => f(x)::acc) [];

(* 12. Implement filter using List.foldr.*)

(*traverse list from right to left with foldr and cons current element onto
accumulated result if predicate of x is true*)
(* ('a -> bool) -> 'a list -> 'a list*)
fun filter1 p = foldr (fn (x,acc) => if p(x) then x::acc else acc) [];

(* 13. Implement foldl using foldr on functions. (This is challenging.)*)

(*Reverse list and traverse it from the right (previously first element) with
 foldr*)
(*('a * 'b -> 'b) -> 'b -> 'a list -> 'b*)
fun foldl1 f init xs = foldr f init (List.rev xs);

(* 14. Define a (polymorphic) type for binary trees where data is at internal
nodes but not at leaves.
Define map and fold functions over such trees.
You can define filter as well where we interpret a "false" as meaning the entire
subtree rooted at the node with data that produced false should be replaced with
a leaf.*)

datatype 'a tree = Leaf | Node of 'a * 'a tree * 'a tree;
(*('a -> 'b) -> 'a tree -> 'b tree*)
fun map_tree f t =
    case t of
	Leaf => Leaf
      | Node (x,l,r) => Node (f(x), map_tree f l, map_tree f r)

(* f(xn,...,f(x2, f(x1, init))...)*)
(*('a * 'b -> 'b) -> 'b -> 'a tree -> 'b*)
fun fold_tree f init t =
    case t of
	Leaf => init
      (* combine value of current node with init using f which becomes new
	 acccumulator passed to fold_tree on left child. This result becomes
	 new accumulator passed to fold_tree on right child)*)
      | Node (x,l,r) => fold_tree f (fold_tree f (f(x,init)) l) r;

(*('a -> bool) -> 'a tree -> 'a tree*)
fun filter_tree p t =
    case t of
	Leaf => Leaf
      | Node (x,l,r) => if p(x)
			(* make tree with x and filtered children*)
			then Node(x,filter_tree p l, filter_tree p r)
			(*data produced false so subtree replaced with Leaf*)
			else Leaf

				  

				     
						    
