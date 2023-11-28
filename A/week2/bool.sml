(*
Booleans

And uses andalso keyword
e1 andalso e2
we evaluate e2 only if e1 evaluates to true, else produce false

Or uses orelse keyword
e1 orelse e2

Not uses not function
not e1
 *)

(*  Could be implemented also with if then else, but it's poor
 style since longer version

e.g. e1 andalso e2 is same as:
if e1
then e2
else false

Comparing

compare ints or reals, but not int with real
= equal (for all equality types (int, list, bool etc.), except real)
<> not equal (for all equality types, except real)
> greater than
< less than
>= greater than or equal
<= less than or equal

Convert int into real (floating point) with Real.fromInt

 *)
