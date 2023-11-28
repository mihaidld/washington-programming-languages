(* Programming Languages, Dan Grossman *)
(* Section 3: Anonymous Functions *)

fun n_times (f,n,x) = 
    if n=0
    then x
    else f (n_times(f,n-1,x))

fun triple x = 3*x

fun triple_n_times1 (n,x) = n_times(triple,n,x)

(* since we use helper function triple only once we can define it in local
let expression*)
fun triple_n_times2 (n,x) =
  let fun triple x = 3*x in n_times(triple,n,x) end

(* actually since used only once, we could define it right where we need it.
   triple is not needed in all the body of triple_n_times2,
   if we give it the only scope it needs, it's needed only in 1st arg
   of call to n_times so we can define it right there in local expression
   the 1st argument is the result of the let expression*)
fun triple_n_times3 (n,x) = 
    n_times((let fun triple y = 3*y in triple end), n, x)

(* This will not compile: a function /binding/ is not an /expression/
 We need an expression that represents a function, after binding the function
 we need to return that function.*)
(* fun triple_n_times3 (n,x) = n_times((fun triple y = 3*y), n, x) *)

(* This /anonymous function/ expression works and is the best style.
 We need a function as an expression, not as a fun binding so:
- instead ofkeyword "fun" use keyword "fn",
- the function has no name since we never use it, just argument pattern
eg. fn (x,y) => x + y 
- instead of = for binding we put => for function expression *)

(* Anonymous functions are expressed in the form fn [arguments]=>[function body]
fn y=>3*y is of this form where
y is the [arguments] and 3*y is the [function body].*)

fun triple_n_times4 (n,x) = n_times((fn y => 3*y), n, x)

(*With anonymous functions we cannot define recursive functions because
 if the function has no name we don't have a way to call recursively.
 For recursion we need function binding with fun. Anonymous functions can
 do everything fun bindings do, except recursion*)

(* because triple_n_times4 does not call itself, we don't need a fun binding,
and could use a val-binding and anonymous function for function expression
to define it, but the fun binding above is better style *)
val triple_n_times5 = fn (n,x) => n_times((fn y => 3*y), n, x)
