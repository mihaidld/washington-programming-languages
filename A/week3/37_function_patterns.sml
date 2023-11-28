(* Programming Languages, Dan Grossman *)
(* Section 2: *Optional*: Function Patterns *)

datatype exp = Constant of int 
             | Negate of exp 
             | Add of exp * exp
             | Multiply of exp * exp

fun old_eval e =
    case e of
        Constant i => i
      | Negate e2  => ~ (old_eval e2)
      | Add(e1,e2) => (old_eval e1) + (old_eval e2)
      | Multiply(e1,e2) => (old_eval e1) * (old_eval e2)

(*Another way of writing case expression in function body : syntactic sugar
for case expression

 Similar to fun f pattern = expression

Instead of
fun f x =
    case x of
    	 p1 => e1
	 | p2 => e2
	 | p3 => e3

another syntax is:
 fun f p1 = e1
   | f p2 = e2
   | f p3 = e3 *)
					       
fun eval (Constant i) = i
  | eval (Negate e2) = ~ (eval e2)
  | eval (Add(e1,e2)) = (eval e1) + (eval e2)
  | eval (Multiply(e1,e2)) = (eval e1) * (eval e2)

(*if the 2 arguments match this pattern: 1st empty, 2nd matches any list because
anything matches variable pattern ys, return ys*)
fun append ([],ys) = ys 
  | append (x::xs',ys) = x :: append(xs',ys)
