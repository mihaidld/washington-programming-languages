(* Programming Languages, Dan Grossman *)
(* Section 3: Fold and More Closures *)

(* Another hall-of-fame higher-order function: fold
 Synonims  / close relatives: reduce, inject etc.
 Iterator over recusrive structures -> accumulates an answer by repeatedly
 applying f to answer so far

 fold(f,acc,[x1,x2,x3,x4]) computes f(f(f(f(acc,x1),x2),x3),x4)
Folds left: first combines x1 with accumulator acc using combinator f, then
combines result of that with x2, ...

Fold separates:
- recursive traversal: the way to traverse a list, tree, graph etc.
 = how to write function fold using pattern matching

- data processing (computation): what to do with value stored at some place in
data structure
= how to write function combinator f to combine acc with current value

We can reuse same traversal for different data processing: same fold for lists,
but using different f combinators.

We can reuse same data processing for different data structures: same f
combinator for combining values in list, tree etc.
 *)

(* note this is "fold left" (tail recursive) if order matters*)
(* ('a * 'b -> 'a) * 'a * 'b list -> 'a*)
fun fold (f,acc,xs) =
    case xs of 
	[] => acc
      | x::xs' => fold (f,f(acc,x),xs') 

(*can also do "fold right" (is not tail recursive since it must combine first
 x4 to initial acc, then that result to x3 ,...*)
fun fold_right (f,acc,xs) =
    case xs of 
	[] => acc
      | x::xs' => f(fold_right(f,acc,xs'),x) 
		       
(* examples not using private data: closures only use their arguments *)

(*sums list elements*)
fun f1 xs = fold ((fn (x,y) => x+y), 0, xs)

(*checks if all list elements are non-negative*)
fun f2 xs = fold ((fn (x,y) => x andalso y >= 0), true, xs)

(* examples using private data *)
(* counts number of elements in [lo,hi]
 closures use private data (values of low and high), not just their arguments
 x is current accumulator (initially 0), y is next element of the list*)
fun f3 (xs,lo,hi) = 
    fold ((fn (x,y) => 
	      x + (if y >= lo andalso y <= hi then 1 else 0)),
          0, xs)
(*checks if all strings are shorter than s*)
fun f4 (xs,s) =
    let 
	val i = String.size s
    in
	fold((fn (x,y) => x andalso String.size y < i), true, xs)
    end

(*
More generic
Takes in a function g and list xs, it passes xs to fold, initial accumulator
of true. Elements of xs pass the test if g of element is true
Do all elements of list produce true when passed to g.

Same as List.all(f,lst) : applies f to each element x of the list lst, from left
to right, until f x evaluates to false; it returns false if such an x exists
and true otherwise. *)
fun f5 (g,xs) = fold((fn(x,y) => x andalso g y), true, xs)

(*use generic helper f5 which calls fold with passed anonymous function
 closure: fn y => String.size y < i *)
fun f4again (xs,s) =
    let
	val i = String.size s
    in
	f5(fn y => String.size y < i, xs)
    end

