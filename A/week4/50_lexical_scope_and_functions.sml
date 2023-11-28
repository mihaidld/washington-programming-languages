(* Programming Languages, Dan Grossman *)
(* Section 3: Lexical Scope and Higher-Order Functions *)

(* first example : returns function *)
val x = 1 (*x maps to 1*)

(*we define function f which returns an anonymous function
 fn z => x + y  + z
Takes an arg y, creates a local variable x which holds y + 1, that shadows
top-level x*)
 *)
fun f y = 
    let 
        val x = y+1 
    in
        fn z => x + y  + z (*return function which given argument z, returns
			    y + 1 + y + z = 2y + 1 + z*)
    end
val x = 3 (*shadows previous x, x maps to 3, irrelevant *)
	    
val g = f 4 (*calls f with argument 4 so returns function where given arg z
	     it returns 2*4 + 1 + z = z + 9 *)
val y = 5 (* y maps to 5, irrelevant*)
	    
val z = g 6(*calls g with 6 so returns 6 + 9  = 15*)

(* second example: pass in a function *)

(* function f takes a function g and calls g with 2*)
fun f g = 
    let 
        val x = 3 (* irrelevant *)
    in
        g 2
    end
val x = 4 (* x maps to 4*)
fun h y = x + y (*function h takes argument y and adds to it 4 (what x currently
		 maps to*)
val z = f h (*calls f with h so g is function h, it returns h 2 = 2 + 4 = 6*)

