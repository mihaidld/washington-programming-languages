(* Homework1 Simple Test *)
(* These are basic test cases.
Passing these tests does not guarantee that your code will pass the actual
 homework grader *)
(* To run the test, add a new line to the top of this file:
use "homeworkname.sml"; *)
(* All the tests should evaluate to true.
For example, the REPL should say: val test1 = true : bool *)

use "hw1.sml";
(*use "hw1_solutions.sml";*)

val test1 = is_older ((1,2,3),(2,3,4)) = true;
val test1a = is_older ((1,2,3),(1,3,4)) = true;
val test1b = is_older ((1,2,3),(1,2,4)) = true;
val test1c = is_older ((3,2,3),(2,3,4)) = false;
val test1d = is_older ((1,4,3),(1,3,4)) = false;
val test1e = is_older ((1,2,5),(1,2,4)) = false;


val test2 = number_in_month ([(2012,2,28),(2013,12,1)],2) = 1;
val test2a = number_in_month ([(2012,3,28),(2013,12,1)],2) = 0;
val test2b = number_in_month ([(2012,2,28),(2013,2,1)],2) = 2;
val test2c = number_in_month ([],2) = 0;

val test3 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = 3
val test3a = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[1,7]) = 0
val test3b = number_in_months ([(2012,2,28),(2013,12,1),(2013,2,30),(2011,3,31),(2011,4,28)],[2,3,4]) = 4							val test3c = number_in_months ([(2012,2,28),(2013,12,1),(2013,2,30),(2011,3,31),(2011,4,28)],[]) = 0;											      
val test4 = dates_in_month ([(2012,2,28),(2013,12,1)],2) = [(2012,2,28)];
val test4a = dates_in_month ([(2012,2,28),(2013,12,1)],3) = [];
val test4b = dates_in_month ([],2) = [];
val test4c = dates_in_month ([(2012,2,28),(2013,2,1)],2) = [(2012,2,28),(2013,2,1)];

val test5 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)];
val test5a = dates_in_months ([],[2,3,4]) = [];
val test5b = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[]) = [];

											    
val test6 = get_nth (["hi", "there", "how", "are", "you"], 2) = "there";
val test6a = get_nth (["hi", "there", "how", "are", "you"], 1) = "hi";
val test6b = get_nth (["hi", "there", "how", "are", "you"], 5) = "you";

								     
val test7 = date_to_string (2013, 6, 1) = "June 1, 2013";
val test7a = date_to_string (2014, 1, 31) = "January 31, 2014";

					       
val test8 = number_before_reaching_sum (10, [1,2,3,4,5]) = 3;
val test8a = number_before_reaching_sum (11, [1,2,3,4,5]) = 4;
val test8b = number_before_reaching_sum (3, [4,2,3,4,5]) = 0;
val test8c = number_before_reaching_sum (3, [2,2,3,4,5]) = 1;
val test8d = number_before_reaching_sum (3, [3,2,3,4,5]) = 0;
val test8e = number_before_reaching_sum (14, [1,2,3,4,5]) = 4;

val test9 = what_month 31 = 1;
val test9a = what_month 70 = 3;
val test9b = what_month 59 = 2;
val test9c = what_month 60 = 3;

val test10 = month_range (31, 34) = [1,2,2,2];
val test10a = month_range (31, 30) = [];
val test10b = month_range (31, 32) = [1,2];
val test10c = month_range (1, 3) = [1,1,1];
					
val test11 = oldest([(2012,2,28),(2011,3,31),(2011,4,28)]) = SOME (2011,3,31);
val test11 = oldest([]) = NONE;
val test11 = oldest([(2012,2,28),(2012,2,27),(2012,2,29)]) = SOME (2012,2,27);

val test12 = remove_duplicates ([1, 2, 3, 2, 4, 3]) = [1, 2, 3, 4];
val test12a = remove_duplicates ([1, 2, 3]) = [1, 2, 3];
val test12b = remove_duplicates ([1, 1, 1]) = [1];
val test12c = remove_duplicates ([]) = [];
						 

val test13 = number_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,2]) = 4
val test13a =  number_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,2,4,2,4]) = 3;

val test14 = dates_in_months ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,2,4]) = [(2012,2,28),(2011,3,31),(2011,4,28),(2012,2,28),(2011,4,28)];
val test14a = dates_in_months_challenge ([(2012,2,28),(2013,12,1),(2011,3,31),(2011,4,28)],[2,3,4,2,4]) = [(2012,2,28),(2011,3,31),(2011,4,28)];

val test15 =  reasonable_date ((1,2,3)) = true;
val test15a =  reasonable_date ((0,2,3)) = false;
val test15b =  reasonable_date ((1,0,3)) = false;
val test15c =  reasonable_date ((1,13,3)) = false;
val test15d =  reasonable_date ((1,1,32)) = false;
val test15e =  reasonable_date ((1,2,29)) = false;
val test15f =  reasonable_date ((2000,2,29)) = true;
val test15g =  reasonable_date ((1900,2,29)) = false;
val test15h =  reasonable_date ((2004,2,29)) = true;
