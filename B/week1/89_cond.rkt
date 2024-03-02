; Programming Languages, Dan Grossman
; Section 5: Cond

#lang racket

(provide (all-defined-out))

; avoid nested if expressions with cond expression
; evaluate tests till find first one true, then evaluate its answer
; (cond [e1a e1b]
;       [e2a e2b]
;        ...
;       [eNa eNb])
; last case, default case eNa should be #t

; for both if and cond test expression can be any type (not just bool)
; Semantics treats anything other than #f as true (e.g. '(), 0, "" count as true)
; eg. (if "hi" 0 1) gives 0
; (if #f 0 1) gives 1

; sum3 is equivalent to sum1 from previous segment but better style
; xs must be list
(define (sum3 xs)
  (cond [(null? xs) 0]
        [(number? (car xs)) (+ (car xs) (sum3 (cdr xs)))]
        [#t (+ (sum3 (car xs)) (sum3 (cdr xs)))]))

; sum4 is equivalent to sum2 from previous segment but better style
;xs can be list of any type
(define (sum4 xs)
  (cond [(null? xs) 0]
        [(number? xs) xs]
        [(list? (car xs)) (+ (sum4 (car xs)) (sum4 (cdr xs)))]
        [#t (sum4 (cdr xs))]))

; this function counts how many #f are in a (non-nested) list
; it uses the "controversial" idiom of anything not #f is true
(define (count-falses xs)
  (cond [(null? xs) 0]
        [(car xs) (count-falses (cdr xs))] ; (car xs) can have any type as long as not false
        [#t (+ 1 (count-falses (cdr xs)))]))
