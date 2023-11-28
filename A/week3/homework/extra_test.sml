
use "extra.sml";

val test1 = pass_or_fail {id = 3, grade = SOME 75} = pass
val test1a = pass_or_fail {id = 3, grade = SOME 90} = pass
val test1b = pass_or_fail {id = 3, grade = SOME 74} = fail
val test1c = pass_or_fail {id = 3, grade = NONE} = fail

val test2 = has_passed {id = 3, grade = SOME 75} = true
val test2a = has_passed {id = 3, grade = SOME 90} = true
val test2b = has_passed {id = 3, grade = SOME 74} = false
val test2c = has_passed {id = 3, grade = NONE} = false

val test3 = number_passed [ {id = 3, grade = SOME 75},
			    {id = 3, grade = SOME 90},
			    {id = 3, grade = SOME 74},
			    {id = 3, grade = NONE}] = 2
val test3a = number_passed [] = 0

				    
val test4 = number_misgraded [(pass,{id = 3, grade = SOME 75}),
			      (fail,{id = 3, grade = SOME 90}),
			      (fail,{id = 3, grade = SOME 74}),
			      (pass,{id = 3, grade = NONE})] = 2
val test4a = number_misgraded [(pass,{id = 3, grade = SOME 75}),
			       (fail,{id = 3, grade = SOME 74})] = 0
val test4b = number_misgraded [] = 0

(*Int tree variables for tests*)
val t1 = node {value = 1, left = leaf,
	       right = node {value = 2, left = leaf, right = leaf}};
val t2 = node {value = 1, left = t1,
	       right = node {value = 3, left = leaf, right = leaf}};
val t3 = node {value = 1, left = t1, right = t2};

val test5 = tree_height leaf = 0
val test5a = tree_height t1 = 2
val test5b = tree_height t2 = 3
val test5c = tree_height t3 = 4

val test6 = sum_tree leaf = 0
val test6a = sum_tree t1 = 3
val test6b = sum_tree t2 = 7
val test6c = sum_tree t3 = 11

(*Flag tree variables for tests*)
val t4 = node {value = leave_me_alone, left = leaf,
	       right = node {value = prune_me, left = leaf, right = leaf}};
val t5 = node {value = prune_me , left = t4,
	       right = node {value = leave_me_alone, left = leaf,
			     right = leaf}};
val t6 = node {value = leave_me_alone, left = t4, right = t5};

val test7 = gardener leaf = leaf;
val test7a = gardener t4 =  node {value = leave_me_alone, left = leaf,
				 right = leaf}
val test7b = gardener t5 = leaf;
val test7c = gardener t6 = node {value = leave_me_alone, left = gardener t4,
				 right = leaf};

val test8 = (last1 [] handle List.Empty => 0) = 0
val test8a = last1 [1] = 1;
val test8b = last1 [1,2,3,0] = 0;

val test9 = (take1 ([],1) handle General.Subscript => []) = []
val test9a = take1 ([],0) = []
val test9b = take1 (["a","b","c"],2) = ["a", "b"]
val test9c = take1 ([1],0) = []
val test9d = take1 ([1,2,3],3) = [1,2,3]

val test10 = (drop1 ([],1) handle General.Subscript => []) = []
val test10a = drop1 ([],0) = []
val test10b = drop1 (["a","b","c"],2) = ["c"]
val test10c = drop1 ([1],0) = [1]
val test10d = drop1 ([1,2,3],3) = []

val test11 = concat1 [] = []
val test11a = concat1 [[],["a","b"]] = ["a","b"]
val test11b = concat1 [[1,2],[3,4,5],[6,7]] = [1,2,3,4,5,6,7]

val test12 = getOpt1 (NONE, "a") = "a"
val test12a = getOpt1 (SOME 1, 2) = 1

val test13 = join1 NONE = NONE
val test13a = join1 (SOME NONE) = NONE
val test13b = join1 (SOME (SOME 3)) = SOME 3


val test14 = is_positive ZERO  = false
val test14a = is_positive (SUCC ZERO)  = true
val test14b = is_positive (SUCC (SUCC ZERO)) = true;

val test15 = ((pred ZERO) handle Negative => ZERO) = ZERO;
val test15a = pred (SUCC ZERO) = ZERO
val test15b = pred (SUCC (SUCC ZERO)) = SUCC ZERO;

val test16 = nat_to_int (SUCC (SUCC ZERO)) = 2;
val test16a = nat_to_int (SUCC ZERO) = 1
val test16b = nat_to_int ZERO = 0

val test17 = ((int_to_nat ~1) handle Negative => ZERO) = ZERO;
val test17a = int_to_nat 0 = ZERO;
val test17b = int_to_nat 2 = (SUCC (SUCC ZERO));

(* Natural variables for tests*)
val n0 = ZERO
val n1 = SUCC n0
val n3 = (SUCC (SUCC n1))

val test18 = add (n0, n1) = n1
val test18a = add (n1, n3) = SUCC n3
val test18b = add (n0, n0) = n0

val test19 = ((sub (n0, n1)) handle Negative => n0) = n0
val test19a = sub (n1, n0) = n1
val test19b = sub (n1, n1) = n0
val test19c = sub (n3, n1) = SUCC n1

val test20 = mult (n0, n0) = n0
val test20a = mult (n1, n0) = n0
val test20b = mult (SUCC n1, n3) = SUCC (SUCC (SUCC n3))
val test20c = mult (n1, n1) = n1;

val test21 = less_than(n1, n0) = false
val test21a = less_than(n0, n0) = false
val test21b = less_than(n0, n3) = true
val test21c = less_than(n1, n3) = true

val test22 = remove_duplicates ([1, 2, 3, 2, 4, 3]) = [1, 2, 3, 4];
val test22a = remove_duplicates ([1, 2, 3]) = [1, 2, 3];
val test22b = remove_duplicates ([1, 1, 1]) = [1];
val test22c = remove_duplicates ([]) = [];

val test23  = is_included(1,[]) = false
val test23a  = is_included(1,[2,3]) = false
val test23b  = is_included(1,[2,3,1]) = true

(* intSet variables for tests*)
val s1 = Elems []
val s2 = Elems [3, 2, 3, 1, 2]
val s3 = Range {from = 2, to = 4}
val s4 = Range {from = 7, to = 5}

val test24 = toList s1 = []
val test24a = toList s2 = [3, 2, 1]
val test24b = toList s3 = [2,3,4]
val test24c = toList s4 = [5, 6, 7]
val test24d = toList(Union(s2, s3)) = [3, 2, 1, 4]
val test24e = toList(Union(s2, s4)) = [3, 2, 1, 5, 6, 7]
val test24f = toList(Intersection(s1, s2)) = []
val test24g = toList(Intersection(s2, s3)) = [3, 2]
val test24h = toList(Intersection(s3, s4)) = []
						 
val test25 = contains(s1, 3) = false
val test25a = contains(s2, 3) = true
val test25b = contains(s2, 4) = false
val test25c = contains(s3, 2) = true
val test25d = contains(s3, 5) = false
val test25e = contains(Union(s2, s3),1) = true
val test25f = contains(Union(s2, s4),4) = false
val test25g = contains(Intersection(s2,s3), 2) = true
val test25h = contains(Intersection(s2,s3), 4) = false

val test26 = isEmpty s1 = true
val test26a = isEmpty s2 = false
val test26b = isEmpty s3 = false
val test26c = isEmpty(Union(s1,s2)) = false
val test26d = isEmpty(Intersection(s1,s2)) = true
