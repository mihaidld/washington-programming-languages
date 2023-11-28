use "extra.sml";

val test1 = alternate [1,2,3,4] = ~2;
val test1a = alternate [1,2,3,4] = ~2;

val test2 = min_max [~1,2,~3,4,0] = (~3,4);
val test2a = min_max [1,2,3,4] = (1,4);
val test2b = min_max [4,3,2,1] = (1,4);
val test2b = min_max [1] = (1,1);

val test3 = cumsum [1,4,20] = [1,5,25];
val test3a = cumsum [1] = [1];
val test3b = cumsum [] = [];
val test3c = cumsum [~3,2,~1,0] = [~3,~1,~2,~2];

val test4 = greeting(SOME "Mihai") = "Hello there, Mihai!"
val test4a = greeting(NONE) = "Hello there, you!";

val test5 = repeat([1,2,3], [4,0,3]) = [1,1,1,1,3,3,3]
val test5a = repeat([], []) = []

val test6 = addOpt(SOME 3, SOME 5) = SOME 8
val test6a = addOpt(SOME 3, NONE) = NONE;
val test6b = addOpt(NONE, SOME 5) = NONE;
val test6c = addOpt(NONE, NONE) = NONE;

val test7 = addAllOpt ([SOME 1, NONE, SOME 3]) = SOME 4;
val test7a = addAllOpt ([NONE, NONE]) = NONE;
val test7B = addAllOpt ([]) = NONE;

val test8 = any([]) = false;
val test8b = any([false, true, false]) = true;
val test8c = any([false, false, false]) = false;

val test9 = all([]) = true;
val test9b = all([false, true, true]) = false;
val test9c = all([true, true]) = true;

val test10 = zip ([1,2,3], [4, 6]) = [(1,4), (2,6)]
val test10a =  zip ([], [4, 6]) = [];
val test10b = zip ([1,2,3], []) = [];
val test10c =  zip ([], []) = [];
val test10d =  zip ([1,2], [4, 6]) = [(1,4), (2,6)];

val test11 = zipRecycle ([1,2,3], [1, 2, 3, 4, 5, 6, 7]) =
	     [(1,1), (2,2), (3, 3), (1,4), (2,5), (3,6), (1,7)]
val test11a = zipRecycle ([], []) = [];
val test11b = zipRecycle ([1, 2, 3, 4, 5, 6, 7], [1,2,3]) =
	      [(1,1), (2,2), (3, 3), (4,1), (5,2), (6,3), (7,1)]
val test11c = zipRecycle ([1,2], [7]) = [(1,7), (2,7)];

val test12 = zipOpt ([1,2,3], [4, 6]) = NONE;
val test12a =  zipOpt ([], [4, 6]) = NONE;
val test12b = zipOpt ([1,2,3], []) = NONE;
val test12c =  zipOpt ([], []) = SOME [];
val test12d =  zipOpt ([1,2], [4, 6]) = SOME [(1,4), (2,6)];

val test13 = lookup([("b", 2), ("a", 1), ("c", 3)], "a") = SOME 1;
val test13a = lookup([("b", 2), ("a", 1), ("c", 3)], "d") = NONE;
val test13b = lookup([], "a") = NONE;

val test14 = splitup([]) = ([], []);
val test14a = splitup([1,~2,3,~4,0]) = ([1,3,0], [~2,~4]);
val test14b = splitup([1,3]) = ([1,3], []);
val test14c = splitup([~2,~4]) = ([], [~2,~4]);

val test15 = splitAt([],3) = ([],[]);
val test15a = splitAt([1,2,3],2) = ([1],[2,3]);
val test15b = splitAt([1,2,3,4],5) = ([1,2,3,4],[]);	
val test15c = splitAt([1,2,3],~1) = ([],[1,2,3]);
val test15d = splitAt([2],1) = ([],[2])

val test16 = isSorted([]) = true;
val test16a = isSorted([1]) = true;
val test16b = isSorted([1,2,3]) = true;
val test16c = isSorted([1,2,3,2]) = false;
val test16d = isSorted([3,2,1]) = false;

val test17 = isSortedDesc([]) = true;
val test17a = isSortedDesc([1]) = true;
val test17b = isSortedDesc([1,2,3]) = false;
val test17c = isSortedDesc([3,2,1,2]) = false;
val test17d = isSortedDesc([3,2,1]) = true;
val test17e = isAnySorted([]) = true;
val test17f = isAnySorted([1]) = true;
val test17g = isAnySorted([1,2,3]) = true;
val test17h = isAnySorted([3,2,1]) = true;
val test17i = isAnySorted([1,2,3,1]) = false;

val test18 = sortedMerge ([1,4,7], [5,8,9]) = [1,4,5,7,8,9];
val test18a = sortedMerge ([], []) = [];
val test18b = sortedMerge ([1,4,7], []) = [1,4,7];
val test18c = sortedMerge ([], [5,8,9]) = [5,8,9];
val test18d = sortedMerge ([1,3], [1,2]) = [1,1,2,3];

val test19 = qsort([]) = [];
val test19a = qsort([1]) = [1];
val test19b = qsort([1,2,3]) = [1,2,3];
val test19c = qsort([3,2,1]) = [1,2,3];
val test19d = qsort([1,7,5,2,6,4,3,1]) = [1,1,2,3,4,5,6,7];

val test20 = divide ([1,2,3,4,5,6,7]) = ([1,3,5,7], [2,4,6]);
val test20a = divide ([]) = ([], []);
val test20b = divide ([1]) = ([1], []);
val test20c = divide ([1,2]) = ([1], [2]);

val test21 = not_so_quick_sort([]) = [];
val test21a = not_so_quick_sort([1]) = [1];
val test21b = not_so_quick_sort([1,2,3]) = [1,2,3];
val test21c = not_so_quick_sort([3,2,1]) = [1,2,3];
val test21d = not_so_quick_sort([1,7,5,2,6,4,3,1]) = [1,1,2,3,4,5,6,7];

val test22 = fullDivide (2, 40) = (3, 5);
val test22a = fullDivide((3,10)) = (0, 10); 
val test22b = fullDivide((2,8)) = (3, 1);

val test23 = factorize(20) = [(2,2), (5,1)]
val test23a = factorize(36) = [(2,2), (3,2)]; 
val test23b = factorize(1) = [];
val test23c = factorize(42) = [(2,1), (3,1), (7,1)];

val test24 = multiply([(2,2), (5,1)]) = 20
val test24a = multiply([(2,2), (3,2)]) = 36; 
val test24b = multiply([]) = 1;
val test24c = multiply([(2,1), (3,1), (7,1)]) = 42;

val test25 = all_products([(2,2), (5,1)]) = [1,2,4,5,10,20];
val test25a = all_products([]) = [1];
val test25b = all_products([(2,1)]) = [1,2];
val test25c = all_products([(2,2), (3,3)]) = [1,2,3,4,6,9,12,18,27,36,54,108];
val test25d = get_factors_from_pair (2,3) = [8,4,2,1]
val test25e = get_factors_from_pair (2,0) = [1];
val test25f = multiply_list ([],3) = [];
val test25g = multiply_list ([1,2,3],3) = [3,6,9];
val test25h = get_factors_from_lists([],[]) = [];
val test25i = get_factors_from_lists([],[1]) = [1];
val test25j = get_factors_from_lists([1],[]) = [1];
val test25k = get_factors_from_lists([1,2],[]) = [1,2];
val test25l = get_factors_from_lists([1,2],[1,2]) = [1,2,2,4,2];
val test25m = remove_duplicates ([1, 2, 3, 2, 4, 3]) = [1, 2, 3, 4];
val test25n = remove_duplicates ([1, 2, 3]) = [1, 2, 3];
val test25o = remove_duplicates ([1, 1, 1]) = [1];
val test25p = remove_duplicates ([]) = [];

val test25q = all_products1([(2,2), (5,1)]) = [1,2,4,5,10,20];
val test25r = all_products1([]) = [1];
val test25s = all_products1([(2,1)]) = [1,2];
val test25t = all_products1([(2,2), (3,3)]) = [1,2,3,4,6,9,12,18,27,36,54,108];
