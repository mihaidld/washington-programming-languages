(* Programming Languages, Dan Grossman *)
(* Section 3: Map and Filter *)

(* here is a very, very useful and common example *)
(*applies f to each element of the list*)
fun map (f,xs) =
    case xs of
	[] => []
      | x::xs' => (f x)::(map(f,xs'))

val x1 = map ((fn x => x+1), [4,8,12,16])

val x2 = map (hd, [[1,2],[3,4],[5,6,7]])

(* another very, very useful and common example
filter takes two arguments, a function and a list, and applies the function
to each element of the list, including the element if true, excluding if false.
produce subset of list, after filtering out elements of list for which f elm
returns false*)
fun filter (f,xs) =
    case xs of
	[] => []
      | x::xs' => if f x
		  then x::(filter (f,xs'))
		  else filter (f,xs')

fun is_even v = 
    (v mod 2 = 0)

(*produce list of even elements*)
fun all_even xs = 
    filter(is_even,xs)

(* produce list of pairs where the second part of each pair is even*)
(*('a * int) list -> ('a * int) list*)
fun all_even_snd xs = 
    filter((fn (_,v) => is_even v), xs) (*use _ because we don't use 1st part
					  of pair*)

