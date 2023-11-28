(* Programming Languages, Dan Grossman *)
(* Section 2: Polymorphic Types and Equality Types *)

(*'a list * 'a list -> 'a list
 'a can be any time, bust elements in both lists have to be the same type

"more general" rule = a type t1 is more general than type t2 if you can take
t1, replace its type variables consistently (every 'a replaced with int, every
'b with int or bool etc.), and get t2
 *)
fun append (xs,ys) =
   case xs of
       [] => ys
     | x::xs' => x :: append(xs',ys)

val ok1 = append(["hi","bye"],["programming","languages"])

val ok2 = append([1,2],[4,5]);

(*
val not_ok = append([1,2],["programming","languages"])
*)

(* ''a (with 2 quotes) is an equality type, it is polymorphic, but
 we can not not replace ''a by any type, just with types that we can
compare using = operator.  = operator works on many types (int, string, tuples
containing equality types etc.), but not all types (function types, real ...)*)

(* has type ''a * ''a -> string *)
fun same_thing(x,y) = if x=y then "yes" else "no" 

(* has type int -> string *)
fun is_three x = if x=3 then "yes" else "no" 
