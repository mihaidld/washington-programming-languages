(* Programming Languages, Dan Grossman *)
(* Section 4: Mutual Recursion *)

(* Mutual recursion = when 2 or more function need to call each other
with and keyword (instead of fun)
to create a bundle type-checked together, where we can refer to each other

e.g. 3 mutually recursive functions:
fun f1 p1 = e1
and f2 p2 = e2
and f3 p3 = 3

e.g. 3 mutually recursive datatype bindings:
datatype t1 = ...
and t2 = ...
and t3 = ...*)

(* State machine = we process a list of arbitrary size of inputs, and while
we process the inputs we are always in one of a finite number of known states.
We read next input and this tells us what state to go to next.
When we are done with the inputs, certain ending states are acceptable (true),
others are to be rejected (false).
Depending on last state we know something about the inputs we had to get there.

An example of mutual recursion: a little "state machine" for
deciding if a list of ints alternates between 1 and 2, not ending with a 1.
This example is simple, but any finite state machine can be programmed via
a set of mutally recursive functions for the states = one function for each
state:

fun state1 input_left = ...
and state2 input_left = ...
and ...
Each function looks at the first element of inputs left and would just call
the function that represents the next state
 *)

(*only accepts lists of ints [1,2,1,2,...,1,2], a number of [1,2]'s,
start with 1, alternate and end with 2*)
fun match xs =
    (*I better have a 1 next state*)
    let fun s_need_one xs =
	    case xs of
		[] => true (*true because has [1,2] 0 times*)
	      | 1::xs' => s_need_two xs' (*switch to state2 with rest of list*)
	      | _ => false
	(*I better have a 2 next*)
	and s_need_two xs =
	    case xs of
		[] => false (*just saw a 1, need 2 now*)
	      | 2::xs' => s_need_one xs'
	      | _ => false
    in
	s_need_one xs
    end

(* mutual recursion works fine in ML provided you can put the functions
   "next to each other".*)
(*mutually recursive datatype bindings*)
datatype t1 = Foo of int | Bar of t2
and t2 = Baz of string | Quux of t1

(*mutually recursive functions operating on mutually recursive datatypes t1,t2
 There is no good order*)
fun no_zeros_or_empty_strings_t1 x =
    case x of
	Foo i => i <> 0
      (*if this t1 is made up with Bar constructor than y : t2 so call
        no_zeros_or_empty_strings_t2 y which operates on t2*)
      | Bar y => no_zeros_or_empty_strings_t2 y
and no_zeros_or_empty_strings_t2 x =
    case x of
	Baz s => size s > 0
      | Quux y => no_zeros_or_empty_strings_t1 y

(* code above works fine.
This workaround works if you cannot put the functions
next to each other for some reason (e.g., different modules)
Use higher-order functions and one function takes in as argument the other one.
The way to have an earlier function call a later one is to pass itself as an
argument when calling 1st one. So the 1st will know how to call later one:

fun earlier (f,x) = ...f x ...
...
fun later x = ... earlier(later,y) *)

(*(t2->bool) * t1 -> bool*)
fun no_zeros_or_empty_strings_t1_alternate(f,x) =
    case x of
	Foo i => i <> 0
      | Bar y => f y

(*t2 -> bool*)
fun no_zeros_or_empty_string_t2_alternate x =
    case x of
	Baz s => size s > 0
      (*call 1st function which would not know to call the 2nd because it's not
       in its environment, but we pass the 2nd function as an argument in
       case 1st one needs to call it to operaye on a t2*)
      | Quux y => no_zeros_or_empty_strings_t1_alternate(no_zeros_or_empty_string_t2_alternate,y)

