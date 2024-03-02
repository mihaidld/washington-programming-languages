; Programming Languages, Dan Grossman
; Section 5: Racket Definitions, Functions, Conditionals

; always make this the first (non-comment, non-blank) line of your file
#lang racket

; not needed here, but a workaround so we could write tests in a second file
; see getting-started-with-Racket instructions for more explanation
(provide (all-defined-out))

; basic variable definitions
; (define variableName expression)
; (functionName arg1 args2 ...)
(define x 3)
(define y (+ x 2)) ; function call is (e1 e2 ... en): parens matter!

; basic function
(define cube1 ;bind cube1 to an anonymous function
  (lambda (x) ; define anonymous function with args in parens e.g. (lambda (x y) (+ x y)) 30 12) 
    (* x (* x x))));body of anonymous function

; many functions, such as *, take a variable number of arguments
(define cube2
  (lambda (x)
    (* x x x)))

; syntactic sugar for function definitions
(define (cube3 x)
  (* x x x))

; conditional (if e1 e2 e3)
(define (pow1 x y) ; x to the yth power (y must be non-negative)
  (if (= y 0)
      1
      (* x (pow1 x (- y 1)))))

; currying pow2 is a function that takes one arg x, its body is a function which takes arg y and in its body calls pow1 with x and y
(define pow2 
  (lambda (x)
    (lambda (y)
      (pow1 x y))))

; sugar for currying (fairly new to Racket)
(define ((pow2b x) y) (pow1 x y))

(define three-to-the (pow2 3)) ;partial application of curried function
(define eightyone (three-to-the 4))
(define sixteen ((pow2 2) 4)) ; need exactly these parens PARENTHESIS ALWAYS MATTER IN RACKET !!!
;(pow2 2 4) is wrong.
; arity mismatch;
; the expected number of arguments does not match the given number
;  expected: 1
;  given: 2