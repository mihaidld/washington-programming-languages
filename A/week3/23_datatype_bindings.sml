(* Programming Languages, Dan Grossman *)
(* Section 2: Datatype Bindings *)

(* Building datatype
datatype keyword makes one-of types
datatype type_name = a bunch of possibilities separated by pipe | (or) *)

datatype mytype = TwoInts of int * int 
                | Str of string 
                | Pizza
(*
I want a new type called mytype and the way you make values of mytype
is either they carry an int * int, or they carry a string or they carry
nothing (mytype is one-of type)

A datatype binding does:
- Adds a new type mytype to the environment
- Adds constructors to the environment (by convention capitalized, or all caps):
TwoInts, Str and Pizza

A constructor is a function that makes values of the new type if given argument
values of the correct type (or is a value of the new type)
TwoInts is a function of type int * int -> mytype
Str : string -> mytype
Pizza is not a function because it doesn't carry anything, it already is
a value of type mytype

A constructor is also like a tag, which stays in the value of the variable
to say what type of mytype we have: a Str of "hi", a TwoInts of (3,7)
 *)

(*Variable bindings that use the constructors*)
		      
val a = Str "hi"
(*REPL prints out: val a = Str "hi" : mytype*)
(*Str is a function of type string -> mytype*)
(*type of a is mytype, a is bound to the value Str of "hi" (in a we have the
Str of mytype and the underlying value is string "hi"*)
	    
val b = Str(*a constructor function : string -> mytype *)
val c = Pizza (*a value of type mytype*)
val d = TwoInts(1+2,3+4)(*a value of type mytype*)
val e = a;

(* A value of type mytype is made from one of the constructors
 The value contains :
 - a tag for which constructor we used to make this value (e.g. TwoInts)
 - the corresponding data (e.g. (3,7)*)

(* Accessing datatype
 - first check the variant (what constructor made it)
 - extract the data (if the variant has any) e.g. for TwoInts, or Str
(not for Pizza*)


(* Do _not_ redo datatype bindings (e.g., via use "filename.sml".
   Doing so will shadow the type name and the constructors.) 
datatype mytype = TwoInts of int * int | Str of string | Pizza *)
