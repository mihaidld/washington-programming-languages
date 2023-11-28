(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* 1. This problem involves using first-name substitutions to come up with
alternate names. For example, Fredrick William Smith could also be Fred William
Smith or Freddie William Smith. Only part (d) is specifically about this, but
the other problems are helpful.*)

(* if you use this function to compare two strings (returns true if the 
same string), then you avoid several of the functions in problem 1 having
polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* (a) Write a function all_except_option, which takes a string and a
string list. Return NONE if the string is not in the list, else return SOME lst
where lst is identical to the argument list except the string is not in it.
You may assume the string is in the list at most once. Use same_string,
provided to you, to compare strings. Sample solution is around 8 lines. *)

(* string * string list -> string list option*)
(* return NONE is string not in the list or SOME lst where lst is given list
 with string searched removed*)
(* Pattern matching on tuple argument with s bound to string searched and lst
 to list of strings. Pattern matching on lst: if empty return NONE, (string
 can't be in empty list, if not empty bind h to its head and t to its tail.
 Check is h is same as s, if so return option containing tail, if not
 pattern matching on option resulted from recursive call with tail.
 In case NONE (s not in tail) return NONE, if it's an option of list,
 bind rst to that list and return option of head consed to rst*)
fun all_except_option (s, lst) =
    case lst of
	[] => NONE
      | h::t => if same_string(h,s)
		then SOME t
		else case all_except_option(s, t) of
			 NONE => NONE
		       | SOME rst  => SOME (h::rst)


(* (b) Write a function get_substitutions1, which takes a string list list
(a list of list of strings, the substitutions) and a string s and returns a
string list. The result has all the strings that are in some list in
substitutions that also has s, but s itself should not be in the result.

Example: get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],
["Freddie","Fred","F"]], "Fred")
(* answer: ["Fredrick","Freddie","F"] *)

Assume each list in substitutions has no repeats. The result will have repeats
if s and another string are both in more than one list in substitutions.

Example:
get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff",
"Jeffrey"]], "Jeff")
(* answer: ["Jeffrey","Geoff","Jeffrey"] *)

Use part (a) and ML’s list-append (@) but no other helper functions.
Sample solution is around 6 lines.*)

(*string list list * string -> string list *)
fun get_substitutions1 (substitutions,s) =
    case substitutions of
	[] => []
      | hlst::t =>  case all_except_option (s, hlst) of
			   NONE =>  get_substitutions1 (t,s)
			 | SOME sublst => sublst @ get_substitutions1 (t,s)
    

(* (c) Write a function get_substitutions2, which is like get_substitutions1
except it uses a tail-recursive local helper function.*)

fun get_substitutions2 (substitutions0,s) =
    (* string list list * string list -> string list *)
    (* use result so far accumulator acc for tail recursion*)
    let fun f (substitutions,acc) = 
	    case substitutions of
		[] => acc
	      | hlst::t =>  case all_except_option (s, hlst) of
				NONE =>  f(t,acc) (*no need to update acc*)
			      | SOME sublst => f(t, acc @ sublst)(*update acc*)
    in f(substitutions0,[])(*initialize acc to []*)
    end


(* (d) Write a function similar_names, which takes a string list list of
substitutions (as in parts (b) and (c)) and a full name of type
{first:string,middle:string,last:string} and returns a list of full names
(type {first:string,middle:string,last:string} list). The result is all the
full names you can produce by substituting for the first name (and only the
first name) using substitutions and parts (b) or (c). The answer should begin
with the original name (then have 0 or more other names).

Example:
similar_names([["Fred","Fredrick"],["Elizabeth","Betty"],
["Freddie","Fred","F"]],{first="Fred", middle="W", last="Smith"})
(* answer: [{first="Fred", last="Smith", middle="W"},
            {first="Fredrick", last="Smith", middle="W"},
            {first="Freddie", last="Smith", middle="W"},
            {first="F", last="Smith", middle="W"}] *)

Do not eliminate duplicates from the answer. Hint: Use a local helper function.
Sample solution is around 10 lines.*)

(* string list list * {first:string,middle:string,last:string} ->
 {first:string,middle:string,last:string} list *)
fun similar_names (substitutions, {first=f, middle=m, last=l}) =
    (* string -> {first:string,middle:string,last:string}*)
    (* produce new full name with changed first name*)
    let fun make_name new_first =
	    {first=new_first, middle=m, last=l}
	(* string list -> {first:string,middle:string,last:string} list *)
	(* produce list of full name records with first from subnames*)
		
	fun make_sub_names subnames =
	    case subnames of
		[] => []
	      | h::t => make_name(h)::make_sub_names(t)
    in  {first=f, middle=m, last=l}::
	make_sub_names(get_substitutions2(substitutions,f))
    end


(* 2. This problem involves a solitaire card game invented just for this
question. You will write a program that tracks the progress of a game;
writing a game player is a challenge problem. You can do parts (a)–(e) before
understanding the game if you wish.
A game is played with a card-list and a goal. The player has a list of
held-cards, initially empty. The player makes a move by either drawing, which
means removing the first card in the card-list from the card-list and adding it
to the held-cards, or discarding, which means choosing one of the held-cards to
remove. The game ends either when the player chooses to make no more moves or
when the sum of the values of the held-cards is greater than the goal.
The objective is to end the game with a low score (0 is best).
Scoring works as follows: Let sum be the sum of the values of the held-cards.
If sum is greater than goal, the preliminary score is three times (sum−goal),
else the preliminary score is (goal − sum). The score is the preliminary score
unless all the held-cards are the same color, in which case the score is the
preliminary score divided by 2 (and rounded down as usual with integer division;
use ML’s div operator). *)
	
(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove;

(* (a) Write a function card_color, which takes a card and returns its color
(spades and clubs are black, diamonds and hearts are red).
Note: One case-expression is enough.*)

(* card -> color *)
fun card_color (s,r) =
    case s of
	Clubs => Black
      | Spades => Black
      |  _ => Red;

(* (b) Write a function card_value, which takes a card and returns its value
(numbered cards have their number as the value, aces are 11, everything else is
10).
Note: One case-expression is enough.*)

(* card -> int*)
fun card_value (s,r) =
    case r of
	Num x => x
      | Ace => 11
      |  _ => 10;

(* (c) Write a function remove_card, which takes a list of cards cs, a card c,
and an exception e. It returns a list that has all the elements of cs except c.
If c is in the list more than once, remove only the first one. If c is not in
the list, raise the exception e. You can compare cards with =. *)

(* card list * card * exn -> card list*)
fun remove_card(cs,c,e) =
    case cs of
	[] => raise e (*not in the list*)
      | h::t => if h = c
		then t (*found it, return tail of current list*)
		(*keep searching with head consed to result of recursive call*)
		else h::remove_card(t,c,e);

(* (d) Write a function all_same_color, which takes a list of cards and returns
true if all the cards in the list are the same color.
Hint: An elegant solution is very similar to one of the functions using nested
pattern-matching in the lectures.*)

(* card list -> bool *)
fun all_same_color cs =
    case cs of
	[] => true
      | head::[] => true
      | head::neck::rest => card_color(head) = card_color(neck) andalso
			    all_same_color (neck::rest);

(* (e) Write a function sum_cards, which takes a list of cards and returns the
sum of their values. Use a locally defined helper function that is tail
recursive. (Take “calls use a constant amount of stack space” as a requirement
for this problem.)*)

(* card list -> int *)
fun sum_cards cs =
    let fun f(cs,acc) =
	    case cs of
		[] => acc (*reached []*)
	      | h::t => f(t, (acc + card_value h))(*update acc with card value*)
    in f(cs,0)(*initialize acc to 0*)
    end;

(* (f) Write a function score, which takes a card list (the held-cards) and
an int (the goal) and computes the score as described above.*)

(* card list * int -> int*)
fun score (cs,goal) =
    let val sum = sum_cards cs
	val preliminary = if sum > goal
			  then 3 * (sum - goal)
			  else goal - sum
    in if all_same_color cs
       then preliminary div 2
       else preliminary
    end;


(* (g) Write a function officiate, which “runs a game.”
It takes a card list(the card-list) a move list (what the player “does” at each
point), and an int (the goal) and returns the score at the end of the game after
processing (some or all of) the moves in the move list in order.
Use a locally defined recursive helper function that takes several arguments
that together represent the current state of the game. As described above:
• The game starts with the held-cards being the empty list.
• The game ends if there are no more moves. (The player chose to stop since the
move list is empty.)
• If the player discards some card c, play continues (i.e., make a recursive
call) with the held-cards not having c and the card-list unchanged. If c is not
in the held-cards, raise the IllegalMove exception.
• If the player draws and the card-list is (already) empty, the game is over.
Else if drawing causes the sum of the held-cards to exceed the goal, the game is
over (after drawing). Else play continues with a larger held-cards and a smaller
card-list.

Sample solution for (g) is under 20 lines.*)

(* card list * move list * int -> int *)
fun officiate (cards0, moves0, goal) =
    let fun play (held, cards, moves) = 
	    case moves of
		[] => score(held,goal) (*end since no more moves*)
			   
	      (*Discard card move*)
	      | (Discard c)::tm  => play(remove_card(held,c,IllegalMove),
					 cards,tm)
					
	      (*Draw move*)
	      | Draw::tm =>
		case cards of
		    [] => score(held,goal) (*end since no more cards*)
		  | hc::tc => let val new_held = hc::held
				  val sum = sum_cards new_held
			      in if sum > goal
				 then score(new_held,goal) (*end: over goal*)
				 else play(new_held,tc,tm)
			      end
    in play([], cards0, moves0)
    end;

(* 3. Challenge Problems:
(a) Write score_challenge and officiate_challenge to be like their non-challenge
counterparts except each ace can have a value of 1 or 11 and score_challenge
should always return the least (i.e., best) possible score.
(Note the game-ends-if-sum-exceeds-goal rule should apply only if there is no
sum that is less than or equal to the goal.)
Hint: This is easier than you might think. *)

(* card list -> int list *)
(*count number of aces, get sum values with aces of 11, build list of possible
 sums with first element the usual sum, then replacing 1 ace's value after
 another from 11 to 1*)
fun sum_cards_challenge cs =
    (*card list -> int*)
    (*counts aces*)
    let fun count_aces cs =
	    case cs of
		[] => 0
	      | (_,Ace)::tc => 1 + count_aces tc (*found an Ace*)
	      | _::tc => count_aces tc (*skip and keep counting*)

	(* card list * int -> int*)
	(*gets normal sum with ace value 11*)
	fun normal_sum(cs,acc) =
	    case cs of
		[] => acc (*reached []*)
	      | h::t => normal_sum(t, (acc + card_value h))
				  
	(* int * int * int list -> int list*)
	(* builds list of possible sums starting with initial sum
	   (aces valued 11) by replacing every time 1 ace's value with 1
	   (so subtracting from current sum 11-1 = 10)
	   count (number of aces) + 1 times (to include initial)*)
	(*e.g. 3 aces-> [3,13,23,33]*)			  
	fun possible_sums(current, count, acc) =
	    if count = 0
	    then acc
	    else possible_sums(current-10,count-1,current::acc)
			      
    in possible_sums (normal_sum(cs,0), (count_aces cs)+1,[])
    end;

(* card list * int -> int*)
(* get possible sums depending on aces values, get score for each sum
 and compute best score (least) for all sums)
 *)
fun score_challenge (cs,goal) =
    let val sums = sum_cards_challenge cs
	(*int -> int*)
	(*get score for certain sum*)
	fun get_score sum =	    
	    let val preliminary = if sum > goal
				  then 3 * (sum - goal)
				  else goal - sum
	    in if all_same_color cs
	       then preliminary div 2
	       else preliminary
    end

	(*int list -> int*)
	(*get best score (minimum) for list od sums*)
	fun best_score xs =
	    case xs of
		[] => raise List.Empty
	      | x::[] => get_score x
	      | x::xs' => Int.min(get_score x, best_score xs')
			 
    in best_score sums
    end;

(* int list -> int*)
(* get minimum int*)
fun minlist (xs) =
    case xs of
        [] => raise List.Empty
      | x::[] => x
      | x::xs' => Int.min(x,minlist(xs'))


(* card list * move list * int -> int *)
(*usual officiate just use score_challenge instead of score and apply rule
 game-ends-if-sum-exceeds-goal only if minimum of the sums is greater than the
 goal*)
fun officiate_challenge (cards0, moves0, goal) =
    let fun play (held, cards, moves) = 
	    case moves of
		[] => score_challenge(held,goal) (*end since no more moves*)
			   
	      (*Discard card move*)
	      | (Discard c)::tm  => play(remove_card(held,c,IllegalMove),
					 cards,tm)
					
	      (*Draw move*)
	      | Draw::tm =>
		case cards of
		    [] => score_challenge(held,goal) (*end since no more cards*)
		  | hc::tc => let val new_held = hc::held
				  val sums = sum_cards_challenge new_held
			      in if minlist sums > goal (*all sums > goal*)
				 then score_challenge(new_held,goal)
				 else play(new_held,
					   remove_card(cards,hc,IllegalMove),tm)
			      end
    in play([], cards0, moves0)
    end;

(* (b) Write careful_player, which takes a card-list and a goal and returns a
move-list such that calling officiate with the card-list, the goal, and the
move-list has this behavior:
• The value of the held cards never exceeds the goal.
• A card is drawn whenever the goal is more than 10 greater than the value of
the held cards. As a detail, you should (attempt to) draw, even if no cards
remain in the card-list.
• If a score of 0 is reached, there must be no more moves.
• If it is possible to reach a score of 0 by discarding a card followed by
drawing a card, then this must be done. Note careful_player will have to look
ahead to the next card, which in many card games is considered “cheating.” Also
note that the previous requirement takes precedence: There must be no more moves
after a score of 0 is reached even if there is another way to get back to 0.

Notes:
• There may be more than one result that meets the requirements above. The
autograder should work for any correct strategy — it checks that the result
meets the requirements.
• This problem is not a continuation of problem 3(a). In this problem, all aces
 have a value of 11.*)

(* card list * int -> move list*)
(*
If no more cards no more moves.
If there are still cards and score reached with held cards is 0 then no more
moves.
Since careful player, only if sum is very low that even by drawing Ace (11)
we would get to max the goal, we draw a card.
Else we try to discard. If there is nothing to discard, no more moves, but if
we have held cards we try to get the pair (card,score) with the card among
held ones to discard and replace it with head of the deck, in order to get that
best score. If worth to discard (get score 0), we discard it and draw.
Remaining case, no more moves.
 *)
fun careful_player (cards0, goal) =
    (* card list * card -> card * int *)
    (* produce pair card to be replaced by new from held to get best score
     and best score*)
    let fun best_replace (held, current, new, replaced, best_score) =
	    case current of
		[] => (replaced, best_score)
	      | hc::tc => let val new_score =
				  score ((new::remove_card(held,hc,IllegalMove))
					,goal)
			  in if new_score < best_score
			     then best_replace(held,tc,new,hc,new_score)
			     else best_replace(held,tc,new,replaced,best_score)
			  end
			      
	(* card list * card list * move list -> move list*)
	(* accumulate moves by drawing from cards into held or discarding
	 cards from held*)
	fun play (held, cards, moves) =
	    case cards of
		[] => moves
	      | hc::tc => if score(held,goal) = 0 (*end since score 0*)
			  then moves
			  else if (sum_cards held + 10) < goal (*Draw*)
			  then play(hc::held, tc, moves @ [Draw])
			  else case held of
				   [] => moves (*nothing to discard so end*)
				 | hh::th =>
				   let val (replaced,best_score) =
					   best_replace(held,held,hc,hh,
							score(held,goal))
				   in if best_score = 0 (*Discard and Draw*)
				      then play(hc::remove_card(held,replaced,
								IllegalMove),
						tc, moves @
						    [Discard replaced, Draw])
				      else moves
				   end
				      
    in play([],cards0,[]) (*initialize held and moves to []*)
    end
