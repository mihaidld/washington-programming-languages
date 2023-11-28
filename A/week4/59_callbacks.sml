(* Programming Languages, Dan Grossman *)
(* Section 3: Callbacks = functions to be called later when an event happens

Someone writes a library that takes callbacks = functions given by the clients
of the library to apply (call them) later, when an event occurs.
E.g. of events:
- when a key is pressed, mouse moves, data arrives from the network etc.
the function given to the library in case of that event will be called 
- when the program enters some state (e.g. players take turns in a game)

Library should accept multiple callbacks:
- multiple parts of the program might need the new data. Multiple callbacks
might use the input to do something with it
- different callbacks can need different data to act on.
The callbacks need to be closures with private data. So each client passing in
a callback can use the private data to access the data it's going to need when
the callback executes.
The private data inside the closure doesn't show up in the type of the
callback

Library has mutable state:
- must keep track of all the callbacks registered (all available callbacks): cbs
- provides a function to accept new callbacks: onKeyEvent
- provides a function to remove callbacks (not implemented in this simulation)*)



(* Library implementation to simulate keyboard events*)

(* these two bindings would be internal (private) to the library *)

(* the library maintains a mutable reference cbs (callbacks) that holds a list
of all the callbacks that have been registered. We initialize it to have
contents empty list [] because no callbacks have been added yet*)
val cbs : (int -> unit) list ref = ref []

(*when some event actually occurs later (e.g. it simulates a key being pressed)
the function is called with a number i (i mimics a particular key event).
It takes the contents of cbs (!cbs) and go through the list of
functions to call each of the functions with input i
 *)
fun onEvent i =
   let fun loop fs = (*fs are the registered callback functions (!cbs)*)
        case fs of 
            [] => () (*return unit, don't do anything*)
		      
	  (*call current callback with i, disgard result (of type unit),
	    then keep looping through rest of callbacks*)
        | f::fs' => (f i; loop fs')
    in loop (!cbs) end

(* clients call only this function (public interface to the library) to
 register new callbacks of type int -> unit, e.g. which key on the keyboard
 was pressed
 It says: when a key event occurs later you want me to call this int -> unit you
 passed (and for example  I can give you back the int corresponding to the key
 that was pressed).
 The result of onKeyEvent is a side effect that I'll call you back later.
 When someone calls onKeyEvent with a function, we assign to cbs the list made
 out of cons'ing f onto the previous contents of cbs
 *)     
(* (int -> unit) -> unit*)
fun onKeyEvent f = cbs := f::(!cbs)


				 
(* Clients register callbacks*)
				 
(* can only register an int -> unit (callback) so if any other data is needed,
(other than the key event) it must be in closure's environment
				 
Some clients where closures are essential notice different environments use
bindings of different types *)

(*if we need to remember something, we need mutable state*)
val timesPressed = ref 0 (*int ref whose contents is initially 0*)
		       
(*We register first callback (and don't care about return of onKeyEvent with
val _) that every time is called, it ignores the integer it was given (_), just
increments the contents of the reference timesPressed
 It's a logger counting how many times keys have been pressed*)
val _ = onKeyEvent (fn _ => timesPressed := (!timesPressed) + 1)

(*function that, every time you call it with an i, it registers a callback
 that says: if you give me afterwards an int j by calling onEvent with that j,
if i saved in the closure (as private data when callback was registered) is
the same as j (key pressed afterwards), then print a message,
otherwise I'll do nothing.
I only care about cases when i was pressed *)
fun printIfPressed i =
    onKeyEvent (fn j => if i=j
                        then print ("you pressed " ^ Int.toString i ^ "\n")
                        else ())

(* Register 4 more callbacks for printing when 4,11,23 and 4 again*)
val _ = printIfPressed 4
val _ = printIfPressed 11
val _ = printIfPressed 23
val _ = printIfPressed 4;

(* Events simulation with onEvent *)

(*If we call now onEvent with a number it's going to pass that number to all
the closures registered with onKeyEvent.

If we call onEvent with 11, since we registered a callback to print a message
for 11, it prints "you pressed 11" and timesPressed contents is 1.
If then we call onEvent with 12, since we didn't register any  callback to
print a message for 12, the callbacks don't do anything", but timesPressed
contents is mutated to 2.
If then we call onEvent with 4, since we registered 2 callbacks to print a
message for 4, it prints twice "you pressed 4" and timesPressed contents is 3.*)
