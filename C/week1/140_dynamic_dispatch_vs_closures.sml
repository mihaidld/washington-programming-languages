(* Programming Languages, Dan Grossman *)
(* Section 7: Dynamic Dispatch Versus Closures *)

(* ML functions do not use use late binding: simple example: *)

(*we create a closure for odd*)
fun even x = (print "in even\n" ; if x=0 then true else odd (x-1))
and odd x = (print "in odd\n" ; if x=0 then false else even (x-1))

val a1 = odd 7
val _ = print "\n"

(*we shadow even*)
(* does not change behavior of odd -- which is too bad because new even is more
 efficient, constant time*)
fun even x = (x mod 2) = 0

(*when we call odd, it will be evaluated in the environment where odd was
defined, so, in the body of odd, even refers to even which was mutually
recursive with odd*)
val a2 = odd 7
val _ = print "\n"

(*we shadow even again*)
(* does not change behavior of odd -- which is good because new implementation
 of even is wrong*)
fun even x = false

val a3 = odd 7
val _ = print "\n"

