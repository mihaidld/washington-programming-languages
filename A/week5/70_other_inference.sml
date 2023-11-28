(* Programming Languages, Dan Grossman *)
(* Section 4: The Value Restriction and Other Type-Inference Challenges *)

(*Type system should prevent adding int to string.
  Below we have problem from combining polymorphism (type variables) and
  mutation*)

(* first line is not polymorphic so next two lines do not type-check *)
val r = ref NONE  (*cleary a ref, it holds an option and there are no
additional constraints so
val r : 'a option ref *)

(* Assignment type-checks because (infix) := has type 'a ref * 'a -> unit,
where 'a is instantiated here with string option 
val _ = r := SOME "hi" 

Dereference type-checks because ! has type 'a ref -> 'a, where 'a is
instantiated with int option. I get a string there "Hi" with !r, but type
system thought it was an int (since added to 1) so trying to add int and string.
val i = 1 + valOf (!r)
*)

(* The solution is not to make special rules for references (ref shouldn't
   accept polymorhism and should take only references to int or string).
   Same problem as above created with module system where we can create
   synonims for ref so:
   val r2 : 'a option ref *)
(*type synonim can be in a module that the type checker can not see*)
type 'a foo = 'a ref
val f : 'a -> 'a foo = ref (* f is alias for ref function 'a -> 'a ref*)
(* pass to f (expecting 'a) value NONE which is 'a option. f produces 'a foo or
   'a ref. Since 'a is 'a option, r2 has type 'a option ref.

Also need value restriction here *)
val r2 = f NONE 


(*ML's solution is to restrict everybody just because references might be a
 problem, the Value restriction which makes type system sound

 Value restriction = a variable binding can have a polymorphic type only if the
 expression is a variable or a value. It can't be something that computes a
result (like function calls e.g. ref NONE
 val r = ref NONE will result in r's type not 'a option ref, because r can not
have a polymorphic type, instead compiler gives it a dummy type ?.X
val r : ?.X1 option ref which makes r essentially unusable afterwards when
trying to pass r as an argument to functions assignment := or dereference !*)

(* Downside of value restriction altough there is no mutation*)
	   
(* where the value restriction arises despite no mutation *)
val pairWithOne = List.map (fn x => (x,1))
(*does not get type 'a list -> ('a * int) list because type-checker sees
 function call List.map and does not know List.map is not making a mutable
 reference. So instead of 'a list we get dummy type unusable  ?.X1 list*)

(* a workaround is function wrapping: not just a value binding, but fun binding
 with argument xs. Now pairWithOne2 : 'a list ->  ('a * int) list*)
fun pairWithOne2 xs = List.map (fn x => (x,1)) xs

