(* Programming Languages, Dan Grossman *)
(* Section 4: Signatures and Hiding Things *)

(*Signature is a type for a module. We define modules with structure, and
the module's type (with public bindings) with signature.
The signature defines for a module what minimal bindings must be defined
inside the module and their types. The module can have extra bindings, not
included in the signature. These extra can be used inside the module (private),
but not outside.

signature SIGNAME = sig <public types for module bindings> end
structure MyModule :> SIGNATURENAME = struct <bindings> end

We can define a signature separately from a module and say that the module
has this signature.
We can define a signature once, then different modules which all have that
signature.
If we defined module earlier, we can paste the binding types of the module from
the REPL for a draft signature definition.

Signatures can hide implementation details (bindings and type definitions inside
modules) from clients (all the code outside the module).
e.g. doubler 
I want control over what's public (in signature) and what's private (in module,
but not in signature). Some functions remain private altough at top level
inside the module (e.g. helpers to public functions)
*)

(*Signature it's like an interface to be implemented. Any module with a MATHLIB
  signature must have a variable fact of type int->int however it's defined*)
signature MATHLIB =
sig
val fact : int -> int
val half_pi : real
(*val doubler : int -> int *) (* can hide bindings from clients *)
end

(*structure MyMathLib defines all bindings that MATHLIB requires so we can
ascribe it a signature (:> MATHLIB)

 If we add :> MYSIGNATURE in the module definition, it will type-check only if
 implements all required bindings with appropriate types
(e.g. val half_pi : int would not type check*)
structure MyMathLib :> MATHLIB =
struct
fun fact x =
    if x=0
    then 1
    else x * fact (x - 1)

val half_pi = Math.pi / 2.0

fun doubler y = y + y
			
val eight  = doubler 4 (*can still use doubler inside module*)
end

val pi = MyMathLib.half_pi + MyMathLib.half_pi

(* error since doubler is hidden from clients, since not in signature MATHLIB *)
(*val twenty_eight = MyMathLib.doubler 14 *)
