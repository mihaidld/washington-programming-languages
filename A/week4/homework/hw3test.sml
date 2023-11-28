(* Homework3 Simple Test*)
(* These are basic test cases. Passing these tests does not guarantee that your
 code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file:
use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say:
val test1 = true : bool *)
use "hw3.sml";

val test1 = only_capitals ["A","B","C"] = ["A","B","C"];
val test1a = only_capitals ["Aa","bB","Cc"] = ["Aa","Cc"];
val test1b = only_capitals ["aA","bB","cC"] = [];
val test1c = only_capitals ["A","bB","cC"] = ["A"];
					     
val test2 = longest_string1 ["A","bc","C"] = "bc";
val test2a = longest_string1 [] = "";
val test2b = longest_string1 ["C"] = "C";
val test2c = longest_string1 ["C", "A"] = "C";
						 
val test3 = longest_string2 ["A","bc","C"] = "bc";
val test3a = longest_string2 [] = "";
val test3b = longest_string2 ["C"] = "C";
val test3c = longest_string2 ["C", "A"] = "A";
						 
val test4a = longest_string3 ["A","bc","C"] = "bc"				
val test4b = longest_string4 ["A","B","C"] = "C"
val test4c = longest_string3 [] = ""
val test4d = longest_string4 [] = "";
val test4e = longest_string4 ["A","bc","C"] = "bc"				
val test4f = longest_string3 ["A","B","C"] = "A"
						 

val test5 = longest_capitalized ["A","bc","C"] = "A";
val test5a = longest_capitalized [] = "";
val test5b = longest_capitalized ["a","bc"] = "";
val test5c = longest_capitalized ["A","bc","C","DE"] = "DE";



val test6 = rev_string "abc" = "cba";
val test6a = rev_string "" = "";
val test6b = rev_string "a" = "a"

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] =
	    4;
val test7a = (first_answer (fn x => if x > 3 then SOME x else NONE) []
	     handle NoAnswer => 0) = 0;
val test7b = (first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3]
	     handle NoAnswer => 0) = 0;
val test7c = first_answer (fn x => if String.size x > 3 then SOME x else NONE)
			  ["a","bc", "defg"] = "defg";


val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE)
			[2,3,4,5,6,7] = NONE;

val test8a = all_answers (fn x => if x = 1 then SOME [x] else NONE)
			[] = SOME []
val test8b = all_answers (fn x => if x = 1 then SOME [x] else NONE)
			 [1] = SOME [1]
val test8c = all_answers (fn x => if String.size x = 2
				  then SOME (String.explode x) else NONE)
			 ["ab","cd"] = SOME [#"a",#"b",#"c",#"d"]

val p1 = Wildcard
val p2 = Variable "abc"
val p3 = UnitP
val p4 = ConstP 5
val p5 = TupleP [p1, p2, p3, p4, Wildcard]
val p6 = ConstructorP("b", p5)
		
val test9a = count_wildcards p1 = 1;
val test9b = count_wildcards p2 = 0;
val test9c = count_wildcards p3 = 0;
val test9d = count_wildcards p4 = 0;
val test9e = count_wildcards p5 = 2;
val test9f = count_wildcards p6 = 2;

(*1 char in 1 string*)
val test9g = count_wild_and_variable_lengths (Variable("a")) = 1
(*2 wildcards + chars abc*)						   
val test9h = count_wild_and_variable_lengths p6 = 5;
(* wildcard and chars ab *)
val test9i = count_wild_and_variable_lengths (TupleP [Variable "ab",Wildcard]) =
	     3;
val test9j = count_wild_and_variable_lengths p3 = 0 (*no wildcards or vars*)
						      
val test9k = count_some_var ("x", Variable("x")) = 1;
val test9l = count_some_var ("a", Variable("x")) = 0;
val test9m = count_some_var ("x", TupleP [Variable("x"), Variable("x"),p6]) = 2;
val test9n = count_some_var ("abc", p6) = 1;

				     
val test10 = check_pat (Variable("x")) = true
val test10a = check_pat (TupleP [Variable("x"), Variable("x"),p6]) = false
val test10b = check_pat p6 = true
val test10c = check_pat (TupleP[Variable("abc"),p6]) = false
					    
val test11 = match (Const(1), UnitP) = NONE
val test11a = match (Unit, p1) = SOME []
val test11b = match (Const 4, p2) = SOME [("abc", Const 4)]
val test11c = match (Unit,p3) = SOME []
val test11d = match (Const 5, p4) = SOME []
val test11e = match (Tuple [Unit,Const 4,Unit,Const 5,Unit],p5) =
	      SOME [("abc",Const 4)]
val test11f = match (Constructor("b",Tuple [Unit,Const 4,Unit,Const 5,Unit]),
		     p6) = SOME [("abc",Const 4)]
val test11g = match (Constructor("C",Tuple [Unit,Const 4,Unit,Const 5, Unit]),
		     p6) = NONE
val test11h = match (Constructor("b",Tuple[Unit,Const 4,Unit,Const 5,Unit,Unit]),p6) = NONE
val test11i = match (Tuple [Const 3, Const 4],
		     TupleP [Variable "x", Variable "y"]) =
	      SOME [("x",Const 3),("y",Const 4)]
val test11j = match (Const 4, p4) = NONE

					   
val test12 = first_match Unit [UnitP] = SOME []
val test12a = first_match (Const 6) [UnitP,Variable "x",Variable "y"] =
	      SOME [("x", Const 6)]
val test12b = first_match (Const 6) [ConstructorP("a",UnitP),UnitP] = NONE
val test12c = first_match Unit [] = NONE

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

(*a constructor given an argument with wrong type*)
val test13l =  typecheck_patterns([("Red", "color", UnitT),("Green", "color", UnitT),("Blue", "color", UnitT)],[ConstructorP("Red",ConstP 5),Wildcard]) = NONE;
val test13m =  typecheck_patterns([("Red", "color", UnitT),("Green", "color", UnitT),("Blue", "color", UnitT)],[ConstructorP("Blue",UnitP),ConstructorP("Red",ConstP 5),Wildcard]) = NONE;

