; Programming Languages, Dan Grossman
; Section 5: Racket Lists

; always make this the first (non-comment, non-blank) line of your file
#lang racket

; not needed here, but a workaround so we could write tests in a second file
; see getting-started-with-Racket instructions for more explanation
(provide (all-defined-out))

; list processing: null, cons, null?, car, cdr
; null / '() = Empty list 
; cons = Cons constructor

; car = Access head of list .
; cdr = Access tail of lits
; Names car and cdr are historical accidents from original machines language was implemented on
; car = Contents of the Address part of the Register”. cdr (pronounced “could-er”) = “Contents of the Decrement part of the Register”.
; These phrases refer to the IBM 704 computer on which the original Lisp was developed.

; null? = Check for empty
; (list e1 ... en) = build list

; we won't use pattern-matching in Racket

;sum all numbers in a list
(define (sum xs)
  (if (null? xs)
      0
      (+ (car xs) (sum (cdr xs)))))

; convention for composed names in Racket is kebab case
;appends second list to first
;append is built-in (append l1 l2) 
(define (my-append xs ys) ; same as append already provided
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))

;builds list by applying f to each elements of xs
;map is built-in (map f xs) 
(define (my-map f xs) ; same as map already provided
  (if (null? xs)
      null
      (cons (f (car xs))
            (my-map f (cdr xs)))))

(define foo (my-map (lambda (x) (+ x 1)) (cons 3 (cons 4 (cons 5 null)))))

