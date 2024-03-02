; Programming Languages, Dan Grossman
; Section 6: Datatype Programming in Racket Without Structs

#lang racket
(provide (all-defined-out))

; we do not need a datatype to create a list holding a mix of numbers and string
; Note: arguably bad style to not have else clause but makes example more like ML code
(define (funny-sum xs)
  (cond [(null? xs) 0]
        [(number? (car xs)) (+ (car xs) (funny-sum (cdr xs)))]
        [(string? (car xs)) (+ (string-length (car xs)) (funny-sum (cdr xs)))]))

; suppose we wanted a "one-of type" using nothing but lists and symbols and such, like ML's 
; datatype exp = Const of int | Negate of exp | Add of exp * exp | Multiply of exp * exp

; Implement interpreter
; what an expression is needs to be put in documentation
; e.g. (list 'Const 3), (list 'Negate (list 'Const 4))) 

; Constructors: just helper functions that make lists where first element is a symbol 
; that says what kind of list it is
; Note: More robust could check at run-time the type of thing being put in
(define (Const i) (list 'Const i)) ;makes 2 element list with symbol Const and given arg i
(define (Negate e) (list 'Negate e))
(define (Add e1 e2) (list 'Add e1 e2)); returns 3 element list
(define (Multiply e1 e2) (list 'Multiply e1 e2))

; Symbols are a sort of string, start with quote (') character,
; symbols can be compared with eq? (faster than string comparison string=?

; Write helper functions to make it easier to read that use lots of (car e) and (cdr e)
; Test variants: just helper functions that test what "kind of exp"
; Note: More robust could raise better errors for non-exp values
; Assume x is a list
; use eq? to compare symbols
(define (Const? x) (eq? (car x) 'Const))
(define (Negate? x) (eq? (car x) 'Negate))
(define (Add? x) (eq? (car x) 'Add))
(define (Multiply? x) (eq? (car x) 'Multiply))

; Extract data: just helper functions that get the pieces for "one kind of exp"
; Note: More robust could check "what kind of exp": we have the right kind (e.g. arg of Const-int e is a 'Const)
(define (Const-int e) (car (cdr e))) ;e is a 'Const, we get underlying integer (get 2nd element of list)
(define (Negate-e e) (car (cdr e)))
(define (Add-e1 e) (car (cdr e)))
(define (Add-e2 e) (car (cdr (cdr e))))
(define (Multiply-e1 e) (car (cdr e)))
(define (Multiply-e2 e) (car (cdr (cdr e))))

; fyi: there are built-in functions for getting 2nd, 3rd list elements that would
; have made the above simpler:
;(define Const-int cadr)
;(define Negate-e cadr)
;(define Add-e1 cadr)
;(define Add-e2 caddr)
;(define Multiply-e1 cadr)
;(define Multiply-e2 caddr)

; Write interpreter: eval-exp function
; same recursive structure as we have in ML, just without pattern-matching (use cond instead)
; And one change from what we did before: returning an exp, in particular
; a Constant, rather than an int
(define (eval-exp e)
  (cond [(Const? e) e] ; note returning entire expression exp, not a number
        ;if it's a 'Negate, get the piece out (sub-expression) with Negate-e,
        ;call recursively eval-exp on that till we get a 'Const
        ;get underlying integer out with Const-int,
        ;negate it using - operator
        ;call Const with that integer to return new list type 'Const
        [(Negate? e) (Const (- (Const-int (eval-exp (Negate-e e)))))]
        [(Add? e) (let ([v1 (Const-int (eval-exp (Add-e1 e)))]
                        [v2 (Const-int (eval-exp (Add-e2 e)))])
                    (Const (+ v1 v2)))]
        [(Multiply? e) (let ([v1 (Const-int (eval-exp (Multiply-e1 e)))]
                             [v2 (Const-int (eval-exp (Multiply-e2 e)))])
                         (Const (* v1 v2)))]
        [#t (error "eval-exp expected an exp")]))

(define a-test (eval-exp (Multiply (Negate (Add (Const 2) (Const 2))) (Const 7))))