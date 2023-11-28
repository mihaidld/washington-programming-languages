(* Programming Languages, Dan Grossman *)
(* Section 3: Optional: Abstract Data Types with Closures *)

(* a set of ints with three operations
similar to Object Oriented Programming OOP

A set is represented by a record of 3 functions, all closures have access to
same private data (list of xs) which is in their environments, they work
together to implement a set abstraction

We want to get type = { insert : int -> set, 
   	       	      member : int -> bool, 
		      size : unit -> int }
but since type synonims can not be recursive (int -> set) we must define a
datatype with a constructor: datatype set = S of {...}. We only use datatype
binding for the purpose of mentioning recursively set (in insert) in definition
of set.
* Note: a 1-constructor datatype is an SML trick for recursive types.
 
All record fields hold functions:
- insert : give me an int, I give a new set that contains that int
- member: is the int in the set?
- size: takes no arguments (unit) and counts elements in set

This interface is immutable -- insert returns a new set -- but we could
also have implemented a mutable version using ML's references *)

(* The key to an abstract data type (ADT) is requiring clients to use it via
a collection of functions rather than directly accessing its private
implementation. Thanks to this abstraction, we can later change how the data
type is implemented without changing how it behaves for clients.*)

datatype set = S of { insert : int -> set, 
		      member : int -> bool, 
		      size   : unit -> int }

			
(* Library implementation of sets: this is the fancy stuff, but clients using
   this abstraction do not need to understand it

We define locally helper function make_set that takes a list of elements that
should be in a set, it assumes that list doesn't have dupplicates (it's a
local function so can assume that).
empty_set gets the return value of make_set called with []

make_set returns a record {...} (wrapped in the S constructor) with:

- insert does the right thing for a number i and a list of ints xs
It calls make_set recursively to create a new set, has type int -> set,
an anonymous function that takes an int i.
It uses helper contains to check if i is in xs.
If i already in xs, I want to return the same set I already have with current
list xs, so we create a new set with same list xs.
Otherwise make a new set from list i cons'ed to xs

- member: traverse the list to check is the number inside, we use local function
 contains

- size: xs doesn't have dupplicates in it, an invariant that we will maintain
with insert. size is a record field that contains an anonymous function
unit -> int and gets the length of list xs. It uses private data xs which is in
lexical scope of closure size definition

make_set uses a helper function contains int -> bool that takes an int and
returns true if i is in xs. It's used by insert and member.
It uses private data xs and library function List.exists curried called with
predicate function (for each element of the list j, does i = j?) *)
val empty_set =
    let
	(*int list -> set *)
        fun make_set xs = (* xs is a "private field" in result (3 closures) *)
            let (* contains a "private method" in result (3 closures) *)
                fun contains i = List.exists (fn j => i=j) xs
            in
                S { insert = fn i => if contains i 
                                     then make_set xs 
                                     else make_set (i::xs),
                    member = contains,
                    size   = fn () => length xs
                  }
            end
    in
        make_set []
    end

(*datatype set = S of { insert : int -> set, 
  	       	        member : int -> bool, 
		        size   : unit -> int }*)
(* the only public value is val empty_set : set so we start with empty set
The closures can use xs, the helper functions contains and make_set.
 *)
	
(* example client: easier than the library because we only implement library
once, but it must be easy to use it (call it) multiple times *)
	
(*unit -> int*)
fun use_sets () =
    (*add S to pattern match the empty set so that
      s1 is the record of 3 functions {...}*)
    let val S s1 = empty_set
	(* take s1, read out the insert field, get back closure,
	   call it with 34 and get back a set.
	   Pattern match again with S ... so that s2 is a new record of 3
	   functions.
	   Like s1.insert(34) in OOP*)
        val S s2 = (#insert s1) 34
	(* Call insert in s2, try to insert again 34, no dupplicates, get s3*)
        val S s3 = (#insert s2) 34
	(*insert 19 and get s4 with 2 ints 19, 34, but represented in s4 by
	 record holding 3 functions*)
        val S s4 = #insert s3 19
    in
        if (#member s4) 42 (*false*)
        then 99
        else if (#member s4) 19 (*true*)
        then 17 + (#size s3) () (*17 + 1 (set of 34 only, no dupplicates) = 18*)
        else 0
    end 
