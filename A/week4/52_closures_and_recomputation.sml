(* Programming Languages, Dan Grossman *)
(* Section 3: Closures and Recomputation *)

(*A function body is not evaluated until the function is called.
 A function body is evaluated every time the function is called.
 A variable binding evaluates its expression when the binding is evaluated,
not every time the variable is used.

 With closures we can avoid repetaing computations that do not depend on
 function arguments*)

fun filter (f,xs) =
    case xs of
	[] => []
      | x::xs' => if f x then x::(filter(f,xs')) else filter(f,xs')

(*string list * string -> string list*)
(*filters out all strings longer than s*)
(*the issue is we recompute the size of s, altough it doesn't change, for
every element of list*)

(*print statement is side effect: just prints string argument*)
(*semicolon ; operator when it separates 2 expression (e.g. e1 ; e2) it
 evaluates e1, throws away the result, then evaluates and returns result of e2
With print statement we compare how many times we recompute String.size s:
for each element in allSgorterThan1, once in allShorterThan2
 *)

							    
fun allShorterThan1 (xs,s) = 
    filter (fn x => String.size x < (print "!"; String.size s), xs)

fun allShorterThan2 (xs,s) =
    let 
	val i = (print "!"; String.size s) (*local variable holds size of s*)
    in
	filter(fn x => String.size x < i, xs)
    end


val _ = print "\nwithAllShorterThan1: "

val x1 = allShorterThan1(["1","333","22","4444"],"xxx")

val _ = print "\nwithAllShorterThan2: "

val x2 = allShorterThan2(["1","333","22","4444"],"xxx")

val _ = print "\n"
