(* Programming Languages, Dan Grossman *)
(* Section 2: Tail Recursion *)

fun fact1 n = if n=0 then 1 else n * fact1(n-1)

(*More efficient with tail recursion, since caller doesn't do any work with
 result from caleee, the stack of the caller is removed, and reused by the
 callee so no new stacks are created.*)
fun fact2 n =
    let fun aux(n,acc) = if n=0 then acc else aux(n-1,acc*n)
    in
        aux(n,1)
    end
