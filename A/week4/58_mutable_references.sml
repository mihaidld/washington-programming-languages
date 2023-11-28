(* Programming Languages, Dan Grossman *)
(* Section 3: Mutable References *)

(*To update the state of the world that everything else should access to,
 use references to allow mutation

New type: t ref, where t is a type. The type of a reference whose contents is
a t (e.g. int ref has contents of type int)

New expressions:
- ref e
to create a reference with initial contents e. Evaluate expression e to
a value, then create a new reference and the result is a pointer to that
reference, to the contents e (to whatever e evaluated to). The contents can
change.

- e1 := e2
to update contents (assignment statement using operator :=).
We evaluate e1 to some reference, e2 to some value, then update contents of the
reference to that value
e1 has type t ref while e2 has type t

- !e
to get contents of reference (dereference with !(bang) operator).
e is evaluated, must be of type t ref, we get the t with !e 
 *)

val x = ref 42  (*of type int ref*)

(*Make a new box (location in memory), initialize its contents to 42, the
result is an arrow pointing to those contents and bind variable y to this
reference*)
val y = ref 42 

(*An alias for the reference. We lookup x in dynamic environment, get the
 arrow, now z and x refer to same reference*)
val z = x

(*A variable bound to a reference (e.g. x) is still immutable:
it will always refer to the same reference, but the contents of the reference
can change.
Use _ since we assign and don't care about result
Now z also points to 43*)
val _ = x := 43

(*Retrieve contents of boxes y and z point to and add them*)
val w = (!y) + (!z); (* 85 *)

(* x + 1 does not type-check *)

(*References are first-class values: can be passed to functions or returned
 from functions*)
