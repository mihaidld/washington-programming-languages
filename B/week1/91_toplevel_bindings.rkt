; Programming Languages, Dan Grossman
; Section 5: Top-Level Bindings

#lang racket

(provide (all-defined-out))

; at the top-level (*)
; defines in a file have same letrec-like rules: can have forward references (only in function body), but
;  definitions still evaluate in order and cannot be repeated

(define (f x) (+ x (* x b))) ; forward reference to b okay here
(define b 3)
(define c (+ b 4)) ; backward reference okay
;(define d (+ e 4)) ; not okay (get an error: reference to an identifier before its definition)
(define e 5)
;(define f 17) ; not okay: f already defined in this module (error duplicate definition for identifier)
;!!!in REPL interactions though it's possible to redefine and shadow

; (*) we are not actually at top-level -- we are in a module called 91_toplevel_bindings
; each file is implicitely a module with its letrec semantics
; a module can shadow bindings from other modules (outer bindings) it uses (including Racket standard library)
; e.g. shadow - function from std library, fortunately only in this module (bad style) 
(define (- x y) (+ x y))  ; (- 7 6) -> 13