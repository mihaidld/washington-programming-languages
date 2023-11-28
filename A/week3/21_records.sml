(* Programming Languages, Dan Grossman *)
(* Section 2: Records *)

(* Build a compound data record: each-of type
 * val x = {field1 = expr1, field2 = exprn2, ..., fieldn = exprn};
 * this will create a record of type {field1:t1, field2:t2, ..., fieldn:tn}
 * Each value record must hold a value of type t1, another t2, ..., tn.
 * To access pieces: #1field1 record_name e.g. #id my_niece;
 * Record values have fields holding values
 *
 * We don't have to define a record type before (like object in JS, but unlike
 * define-struct in Racket or struct in C or class in Python/Java*)

val x = {bar = (1+2,true andalso true), foo = 3+4, baz = (false,9) }
(* a record value bound to x, where bar field holds (3,true), baz holds
 * (false,9) and foo 7
 * It evaluated each of the expresisons to a value and that was the result.
 * The order of fields in a record doesn't matter*)

val my_niece = {name = "Amelia", id = 41123 - 12}

val brain_part = {id = true, ego = false, superego = false}
