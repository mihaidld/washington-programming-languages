(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that 
your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use 
"homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should 
say: val test1 = true : bool *)

use "hw2.sml";

val test1 = all_except_option ("string", ["string"]) = SOME []
val test1a = all_except_option ("string", []) = NONE
val test1b = all_except_option ("string", ["string1", "string2"]) = NONE
val test1c = all_except_option ("string", ["string", "string1"]) =
	    SOME ["string1"]

		 
val test2 = get_substitutions1 ([["foo"],["there"]], "foo") = []
val test2a = get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],
				 ["Freddie","Fred","F"]], "Fred") =
	     ["Fredrick","Freddie","F"]
val test2b = get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],
				 ["Geoff","Jeff","Jeffrey"]], "Jeff")
	     = ["Jeffrey","Geoff","Jeffrey"]
val test2c = get_substitutions1 ([[],["there"]], "foo") = []
val test2d = get_substitutions1 ([], "foo") = []

								 
val test3 = get_substitutions2 ([["foo"],["there"]], "foo") = []
val test3a = get_substitutions2([["Fred","Fredrick"],["Elizabeth","Betty"],
				 ["Freddie","Fred","F"]], "Fred") =
	     ["Fredrick","Freddie","F"]
val test3b = get_substitutions2([["Fred","Fredrick"],["Jeff","Jeffrey"],
				 ["Geoff","Jeff","Jeffrey"]], "Jeff")
	     = ["Jeffrey","Geoff","Jeffrey"]
val test3c = get_substitutions2 ([[],["there"]], "foo") = []
val test3d = get_substitutions2 ([], "foo") = []

val test4 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],
			    ["Freddie","Fred","F"]], 
			   {first="Fred", middle="W", last="Smith"}) =
	    [{first="Fred", last="Smith", middle="W"},
	     {first="Fredrick", last="Smith", middle="W"},
	     {first="Freddie", last="Smith", middle="W"},
	     {first="F", last="Smith", middle="W"}]
val test4a = similar_names ([], {first="Fred", middle="W", last="Smith"}) =
	     [{first="Fred", middle="W", last="Smith"}]
val test4b = similar_names ([["Elizabeth","Betty"],["Fred","F"]], 
			   {first="Fred", middle="W", last="Smith"}) =
	    [{first="Fred", last="Smith", middle="W"},
	     {first="F", last="Smith", middle="W"}]
		 

	
val test5 = card_color (Clubs, Num 2) = Black
val test5a = card_color (Spades, Jack) = Black
val test5b = card_color (Diamonds, Num 2) = Red
val test5c = card_color (Hearts, King) = Red

					    
val test6 = card_value (Clubs, Num 2) = 2
val test6a = card_value (Spades, Ace) = 11
val test6b = card_value (Clubs, King) = 10
val test6c = card_value (Hearts, Num 3) = 3

					    
val test7 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = []
val test7a = remove_card ([(Clubs, Num 4), (Hearts, Ace), (Spades, King)],
			  (Hearts, Ace), IllegalMove) =
	     [(Clubs, Num 4), (Spades, King)]
val test7b = (remove_card ([(Hearts, Ace)], (Hearts, King), IllegalMove)
	     handle IllegalMove => []) = []
val test7c = (remove_card ([(Hearts, Ace)], (Clubs, Ace), IllegalMove)
	     handle IllegalMove => []) = []
		 

									    
val test8 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val test8a = all_same_color [] = true
val test8b = all_same_color [(Hearts, Ace), (Diamonds, Ace)] = true
val test8c = all_same_color [(Hearts, Ace), (Clubs, Ace)] = false
val test8d = all_same_color [(Hearts, Ace), (Diamonds, Ace), (Spades,King)] =
	     false
val test8e = all_same_color [(Clubs, Ace)] = true


val test9 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test9a = sum_cards [(Clubs, Num 3),(Clubs, Ace)] = 14 
val test9b = sum_cards [] = 0
val test9c = sum_cards [(Clubs, King)] = 10

							    
val test10 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4
val test10a = score ([(Spades, Num 2),(Clubs, Num 4)],10) = 2
val test10b = score ([(Hearts, Ace),(Clubs, Num 4)],10) = 15
val test10c = score ([(Hearts, Num 6),(Clubs, Num 4)],10) = 0
val test10d = score ([(Hearts, Num 6),(Diamonds, Num 4)],10) = 0
val test10e = score ([(Hearts, Num 7),(Diamonds, Num 4)],10) = 1
val test10f = score ([(Hearts, Num 7),(Clubs, Num 4)],10) = 3
							     

							      
val test11 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6
val test11a= officiate 
		 ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                  [Draw,Draw,Draw,Draw,Draw],
                  42)
             = 3
val test11b= officiate 
		 ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                  [Draw,Draw,Draw,Draw,Draw],
                  45)
             = 0
val test11c = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                          [Draw,Discard(Hearts,Jack)],
                          42);
		false) 
               handle IllegalMove => true)
val test11d = officiate([(Clubs,Jack),(Spades,Num(8))],
                        [Draw,Discard(Clubs,Jack),Draw],
                        10) = 1 
   
val test12 = sum_cards_challenge [(Clubs, Num 2),(Clubs, Num 2)] = [4]
val test12a = sum_cards_challenge [(Clubs, Num 3),(Clubs, Ace)] = [4,14]
val test12b = sum_cards_challenge [] = [0]
val test12c = sum_cards_challenge [(Clubs, King)] = [10]
val test12d = sum_cards_challenge [(Hearts, Ace),(Clubs, Ace)] = [2,12,22]

val test13 = score_challenge ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4
val test13a = score_challenge ([(Hearts, Ace),(Clubs, Num 4)],10) = 5
									
(* (2*11-10)*3/2 =18,(12-10)*3/2=3,(10-2)/2=4 *)
val test13b = score_challenge ([(Hearts, Ace),(Diamonds, Ace)],10) = 3

val test14 = minlist [1] = 1
val test14a = minlist [2,1,3,0,5] = 0

val test15= officiate_challenge 
		 ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                  [Draw,Draw,Draw,Draw,Draw],
                  3)
             = score_challenge([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),
			       (Spades,Ace)],3)
val test15a= officiate_challenge 
		 ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                  [Draw,Draw,Draw,Draw,Draw],
                  2)
             = score_challenge([(Clubs,Ace),(Spades,Ace),(Clubs,Ace)],2)

val test16 = careful_player 
		 ([(Clubs,Num 2),(Spades,Num 4),(Clubs,Ace)],11) = [Draw]
val test16a = careful_player 
		 ([(Clubs,Num 2),(Spades,Num 4),(Clubs,Ace)],17)
             =  [Draw, Draw, Draw]
val test16b = careful_player 
		 ([(Clubs,Num 2),(Spades,Num 7),(Hearts,Num 9)],16)
             =  [Draw, Draw, Discard (Clubs,Num 2), Draw]

