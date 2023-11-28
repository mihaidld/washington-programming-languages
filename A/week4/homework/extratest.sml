use "extra.sml";

datatype color = Red | Green | Blue
val f = (fn a => if a = "foo" then NONE else SOME 5);
val g = fn x => case x of
		     Red => NONE 
		   | Green => SOME "foo"
		   | _ => SOME "bar"
fun h n = case n of 0 => NONE 
		  | 1 => SOME "foo"
		  | _ => SOME "bar" 
	   
val test1 = compose_opt f g Red = NONE;
val test1a = compose_opt f g Green= NONE;
val test1b = compose_opt f g Blue = SOME 5;

val test2 = do_until (fn x => x div 2) (fn x => x mod 2 <> 1) 20 = 5;
val test2a = do_until (fn x => x div 2) (fn x => x mod 2 <> 1) 5 = 5;
val test2b= do_until (fn x => x div 2) (fn x => x mod 2 <> 1) 4 = 1;

val test3 = fact 1 = 1;
val test3a = fact 2 = 2;
val test3b = fact 5 = 5*4*3*2*1;

fun f(x : int) = if x = 0
		 then 0
		 else if x < 0 then x + 1
		 else x - 1
val test4 = fixed_point f 5 = 0;
val test4a = fixed_point f ~5 = 0;
val test4b = fixed_point f 0 = 0;

val test5a = map2 f (1,~5) = (0,~4);
val test5a = map2 f (0,5) = (0,4)

fun f n = [n, 2 * n, 3 * n]
val test6 = app_all f f 1 = [1, 2, 3, 2, 4, 6, 3, 6, 9]

fun g (x,acc) = x + acc
fun h (x,acc) = x ^ acc
val test7 = foldr2 g 0 [1,3,7] = foldr g 0 [1,3,7]
val test7a = foldr2 h "" ["d","bc","a"] = foldr h "" ["d","bc","a"]

fun is_positive x = x > 0 
val test8 = partition is_positive [~1,2,~4,0,5] =
	    List.partition is_positive [~1,2,~4,0,5]

val test9 = unfold (fn n => if n = 0 then NONE else SOME(n, n-1)) 5 =
	    [5, 4, 3, 2, 1]

val test10 = fact1 8 = fact 8;

val test11 = map1 is_positive [1,0,~2] = [true,false,false]
					     
val test12 = filter1 is_positive [1,~4,0,~2,5] = [1,5];

val test13 = foldl1 h "" ["d","bc","a"] = "abcd";

val t0 = Leaf
val t1 = Node(3,t0, Leaf)
val t2 = Node(~2,Leaf,Leaf)
val t3 = Node(~5,t1,t2)

val test14 = map_tree is_positive t0 = t0
val test14a = map_tree is_positive t1 = Node(true,Leaf,Leaf)
val test14b = map_tree is_positive t2 = Node(false,Leaf,Leaf)
val test14c = map_tree is_positive t3 = Node(false, Node(true,Leaf,Leaf), Node(false,Leaf,Leaf))
val test14d = fold_tree g 0 t0 = 0
val test14e = fold_tree g 0 t3 = ~4
val test14f = fold_tree h "" t0 = ""
val test14g = fold_tree h "" (Node("a",
				  Node("b",
				       Leaf,
				       Node("c",
					    Node("f",Leaf, Leaf),
					    Leaf)),
				  Node("d",
				       Leaf,
				       Node("e",Leaf,Leaf))))
	      = "edfcba"
fun is_negative x = x < 0
val test14h = filter_tree is_negative t0 = Leaf
val test14i = filter_tree is_negative t1 = Leaf
val test14j = filter_tree is_negative t2 = t2
val test14k = filter_tree is_negative t3 = Node(~5,Leaf,t2)
