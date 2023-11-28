(* (Challenge Problem) Write a function typecheck_patterns that “type-checks”
a pattern list.
Types for our made-up pattern language are defined by:

datatype typ = Anything (* any type of value is okay *)
             | UnitT (* type for Unit *)
             | IntT (* type for integers *)
             | TupleT of typ list (* tuple types *)
             | Datatype of string (* some named datatype *)

typecheck_patterns should have type
((string * string * typ) list) * (pattern list) -> typ option.
The first argument contains elements that look like ("foo","bar",IntT), which
means constructor foo makes a value of type Datatype "bar" given a value of type
IntT.
Assume list elements all have different first fields (the constructor name), but
there are probably elements with the same second field (the datatype name).
Under the assumptions this list provides, you “type-check” the pattern list to
see if there exists some typ (call it t) that all the patterns in the list can
have. If so, return SOME t, else return NONE.
You must return the “most lenient” type that all the patterns can have.
For example, given patterns TupleP[Variable("x"),Variable("y")] and
TupleP[Wildcard,Wildcard], return TupleT[Anything,Anything] even though they
could both have type TupleT[IntT,IntT].
As another example, if the only patterns are TupleP[Wildcard,Wildcard] and
TupleP[Wildcard,TupleP[Wildcard,Wildcard]], you must return
TupleT[Anything,TupleT[Anything,Anything]].
 *)

(* Type definitions inspired by the type definitions an ML imple- mentation
   would use to implement pattern matching *)
datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu;


datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string;

(*  create an algorithm that (like the SML compiler), is capable of inferring
the type t based on the datatype definitions in first list argument and list of
patterns in the second argument.
List of patterns represent every one of the branches in a case expression. If
all the patterns in the case expression are compatible with some type t then
the answer is SOME t, otherwise NONE.
We would not need the first argument except if among the patterns there are
constructor patterns which do not "tell us" what type they are, e.g. for
ConstructorP("Red",UnitP) we don't know the type.

e.g. datatype color = Red | Green | Blue is represented by 1st argument
[("Red", "color", UnitT),
("Green", "color", UnitT),
("Blue", "color", UnitT)]

The pattern can be of 4 restrictive (specific) types (UnitP, ConstP, TupleP,
ConstructorP) and 2 generic types (Wildcard, Variable). If all patterns are
generic the infered type is Anything, but if one of the patterns is specific,
then either all the others are generic (since generic types are compatible with
specific ones) or must be of same restrictive type to infer that specific type,
otherwise no type matches all patterns
e.g. we can not infer a common type from patterns UnitP and ConstP.

We iterate over list of patterns, we start with generic typ Anything, if we find
a generic pattern then we keep Anything, if we find a specific, the accumulated
type becomes that specific one, and we keep checking.
Afterwards we must find only same specific, or generics, otherwise there is no
common type.
We define an exception to be raised if no match is found.
We use foldl to traverse list of patterns with accumulator typ initialized to
Anything (most "lenient").
For each pair (current pattern, accumulator) we update the type in accumulator
with helper function update_typ which needs its helper functions pattern_to_typ
and datatypes_to_typ.
We wrap the accumulator type resulted in SOME to get the option SOME typ,
and handle the exception (in case it was raised during function calls) to
return NONE*)



		 
(* ((string * string * typ) list) * (pattern list) -> typ option *)
fun typecheck_patterns (ds,ps) =
    
    (*exception to raise if no common typ is found*)
    let exception NoCommon

	fun compatible(t1,t2) =
	    t1 = t2 orelse
	    case (t1,t2) of
		(Anything,_) => true
	     |  (_,Anything) => true
	     | (TupleT t1s, TupleT t2s) =>
	       List.all compatible (ListPair.zip(t1s,t2s))
	     | _ => false
			
	(* string -> typ *)
	(*use List.find to look inside list of datatype definitions ds for a
	 definition with   constructor name n (cn = n).
	 If found return 2nd part of definition (the typ built with that	
	 constructor name), else raise exception*)
			 
	fun datatypes_to_typ (n,t)  =
	    case (List.find (fn (cn,ty,tyarg) => cn = n) ds) of
		NONE => raise NoCommon
	      | SOME (cn,ty,tyarg) =>
		if compatible(t,tyarg)
		then ty
		else raise NoCommon
			   
	(* pattern -> typ*)
	(*infer typ from pattern*)
	fun pattern_to_typ p =
	    case p of
		UnitP => UnitT
	      | ConstP _ => IntT
	      | TupleP ps' => TupleT (map pattern_to_typ ps')
	      | ConstructorP (s,p') =>
		Datatype (datatypes_to_typ(s,pattern_to_typ(p')))
	      | _ => Anything (* cases Wildcard, Variable s*)
			 
			 

						      
	(* pattern * typ => typ*)
	(* compares accumulator typ with current pattern to either keep value
	 of accumulator, update accumulator or raise exception*)
	fun update_typ(p,acc) =
	    case (acc,p) of
		(Anything,UnitP) => UnitT (*more specific*)
	      | (Anything,ConstP _) => IntT (*more specific*)			
	      (* more specific TupleT with list of types infered from each
		pattern of the list with map and pattern_to_typ*)
	      | (Anything,TupleP ps') =>
		TupleT (map pattern_to_typ ps')
	      (* more specific Datatype of custom datatype retrieved with
		 datatypes_to_typ to which we pass constructor name from pattern
	       *)
	      | (Anything,ConstructorP (cn,p')) =>
		Datatype (datatypes_to_typ(cn,pattern_to_typ(p')))
	      | (Anything,_) => Anything (*cases Wildcard, Variable _*)
				    
	      | (UnitT, UnitP) => UnitT (*keep*)
	      | (UnitT,Wildcard) => UnitT (*compatible with specific, keep*)
	      | (UnitT,Variable _) => UnitT (*keep*)
	      | (UnitT,_) => raise NoCommon (*other specific*)
				   
	      | (IntT,ConstP _) => IntT(*keep*)
 	      | (IntT,Wildcard) => IntT (*keep*)
	      | (IntT,Variable _) => IntT (*keep*)
	      | (IntT,_) => raise NoCommon (*other specific*)
				  
	      (*check same lengths of types and patterns.
		If not raise exception.
		If so keep type TupleT, but might need to update types in list.
		Use ListPair.zip to gather pairs pattern*typ then then map each
		pair with current function update_typ to an updated typ*)
	      | (TupleT ts, TupleP ps) => if length ts = length ps
					  then TupleT
						   (map update_typ
							(ListPair.zip(ps,ts)))
					  else raise NoCommon
	      | (TupleT ts,Wildcard) => TupleT ts (*keep*)
	      | (TupleT ts,Variable _) => TupleT ts (*keep*)
	      | (TupleT _,_) => raise NoCommon (*other specific*)

	      (*get custom datatype built with constructor name in pattern,
	       if same as accumulator, then keep, else raise exception*)
	      | (Datatype t, ConstructorP (cn,p')) =>
		if datatypes_to_typ(cn,pattern_to_typ(p')) = t
		then Datatype t
		else raise NoCommon
	      | (Datatype t,Wildcard) => Datatype t (*keep*)
	      | (Datatype t,Variable _) => Datatype t (*keep*)
	      | (Datatype t,_) => raise NoCommon (*other specific*)
						     
    in (SOME (foldl update_typ Anything ps))
       handle NoCommon => NONE
    end 

(*ConstructorP patterns with datatype definitions*)
val test13 = typecheck_patterns ([("C1","bar",IntT),("C2","bar",UnitT)], [ConstructorP("C1",ConstP 5),ConstructorP("C2",UnitP)]) = SOME (Datatype "bar");
val test13a = typecheck_patterns ([("C1","bar",IntT),("C2","bar",UnitT)], [ConstructorP("C1",ConstP 5),ConstructorP("C3",UnitP)]) = NONE;

(* datatype color = Red | Green | Blue
fun f(x) = 
   case x of
     Red => 0
     | _ => 1
 *)
val test13b =  typecheck_patterns([("Red", "color", UnitT),("Green", "color", UnitT),("Blue", "color", UnitT)],[ConstructorP("Red",UnitP),Wildcard]) = SOME (Datatype "color");

(*Specific IntT with generic type*)

(* fun b(x) = 
   case x of
       (10) => 1
      | a => 3
One of the patterns is a integer constant. Thus, the other pattern named a must
be an integer as well. *)

(*Different specific types with no common*)
val test13c = typecheck_patterns([],[ConstP 10, Variable "a"]) = SOME IntT;
(* fun b(x) = 
   case x of
      (10) => 1
      | SOME x => 3
      | a => 3
This would not even compile, because we cannot infer a common type for all
patterns. The types in the different patterns are conflicting. We cannot tell if
x is an int or an optio. This cannot produce a common type and the answer is
NONE, equivalent with the compiler throwing an error due to incapacity to
determine a common type.*)
val test13d = typecheck_patterns([("SOME","optio",IntT)],[ConstP 10, Variable "a", ConstructorP("SOME",Variable "x")]) = NONE;

(*Specific IntT with generic type in TupleP*)
(* fun c(x) = 
    case x of
        (a,10,_) => 1
      | (b,_,11) => 2
      | _ => 3
We can easily infer it's a tuple of three elements. Based on the patterns, we
know the second and third elements of this tuple are integers. The first one,
on the other hand, can be "anything".
 *)
val test13e = typecheck_patterns([],[TupleP[Variable "a", ConstP 10, Wildcard], TupleP[Variable "b", Wildcard, ConstP 11], Wildcard]) = SOME (TupleT[Anything,IntT,IntT]);

(*Custom datatypes with constructor name*)

(* datatype auto =  Sedan of color
               | Truck of int * color
               | SUV
fun g(x) = 
   case x of
        Sedan(a) => 1
      | Truck(b,_) => 2
      | _ => 3
 *)
val test13f = typecheck_patterns([("Sedan","auto", Datatype "color"),("Truck","auto",TupleT[IntT, Datatype "color"]),("SUV","auto",UnitT)], [ConstructorP("Sedan", Variable "a"), ConstructorP("Truck", TupleP[Variable "b", Wildcard]), Wildcard]) = SOME (Datatype "auto");


(* datatype 'a list = Empty | List of 'a * 'a list
polymorphic type 'a corresponds to anything here
fun j(x) = 
   case x of
       Empty => 0
     | List(10,Empty) => 1 
     | _ => 3

Evidently the patterns are of type list, but not just that, but a list of	integers. This case is tricky, because ConstP(10) needs to correspond with
Anything in the constructors metadata as you can see above.*)
val test13g = typecheck_patterns([("Empty","list",UnitT),("List","list",TupleT[Anything, Datatype "list"])],[ConstructorP("Empty",UnitP),ConstructorP("List",TupleP[ConstP 10, ConstructorP("Empty",UnitP)]), Wildcard]) = SOME (Datatype "list");

(*  datatype 'a list = Empty | List of 'a * 'a list
fun h(x) = 
   case x of
      Empty => 0
    | List(k,_) => 1

Variable "k" needs to correspond with Anything in the datatype definition.
In previous example ConstP(10) and now Variable "x" can be considered
"compatible with" Anything.*)

val test13h = typecheck_patterns([("Empty","list",UnitT),("List","list",TupleT[Anything, Datatype "list"])],[ConstructorP("Empty",UnitP),ConstructorP("List",TupleP[Variable "k", Wildcard])]) = SOME (Datatype "list");

(* fun g(x) = 
   case x of
      Empty => 0
    | List(Sedan(c),_) => 1*)
val test13i = typecheck_patterns([("Sedan","auto", Datatype "color"),("Truck","auto",TupleT[IntT, Datatype "color"]),("SUV","auto",UnitT),("Empty","list",UnitT),("List","list",TupleT[Anything, Datatype "list"])],[ConstructorP("Empty",UnitP),ConstructorP("List",TupleP[ConstructorP("Sedan", Variable "c"), Wildcard])]) = SOME (Datatype "list");

(* Generic types: Wildcard and Variable s*)

(* for the "most lenient" pattern.
fun m(w) = 
    case w of
          (x,y) => 0
        | (_,_) => 1
This would not compile, since the patterns are redundant, namely, we would
alway go out throught the first branch. But this was simply used with
illustration purposes. We can infer that w is a tuple with two elements that can
be of anything.
What "most lenient" means is that the type TupleT[IntT, IntT] (for example) is
also a fine type for all the patterns, but it is not as "lenient" or generic
(does not match as many values as) TupleT[Anything,Anything] so
TupleT[IntT, IntT] is not correct.*)
val test13j = typecheck_patterns([],[TupleP[Variable("x"),Variable("y")],TupleP[Wildcard,Wildcard]]) = SOME (TupleT[Anything,Anything]);

(*Specific Tuple of 2 Wildcards with generic Wildcard*)
(* fun m(w) = 
    case w of
      (_,(_,_)) => 0
    | (_,_) => 1
We can infer that w is a tuple of two elements, the first one can be anything,
the second one is evidently a tuple of other two elements, which in turn can be
anything. *)
val test13k = typecheck_patterns([],[TupleP[Wildcard,Wildcard],TupleP[Wildcard,TupleP[Wildcard,Wildcard]]]) = SOME (TupleT[Anything,TupleT[Anything,Anything]]);

val test13l =  typecheck_patterns([("Red", "color", UnitT),("Green", "color", UnitT),("Blue", "color", UnitT)],[ConstructorP("Red",ConstP 5),Wildcard]) = NONE;
val test13m =  typecheck_patterns([("Red", "color", UnitT),("Green", "color", UnitT),("Blue", "color", UnitT)],[ConstructorP("Blue",UnitP),ConstructorP("Red",ConstP 5),Wildcard]) = NONE;

