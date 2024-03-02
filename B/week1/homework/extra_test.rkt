#lang racket

(require "extra.rkt")

(require rackunit)


;; Helper functions
(define ones (lambda () (cons 1 ones)))

(define powers-of-two
  (letrec ([f (lambda (x) (cons x (lambda () (f (* x 2)))))])
    (lambda () (f 2))))

(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let ([p (s)])
        (cons (car p) (stream-for-n-steps (cdr p) (- n 1))))))

;(last lst) → any
; Returns the last element of the list.



(define tests
  (test-suite
   "Sample tests for Extra 4"
   
   ; palindromic test
   (check-equal? (palindromic (list 1 2 4 8)) (list 9 6 6 9) "Sequence test")
   (check-equal? (palindromic '()) '() "Sequence test")
   (check-equal? (palindromic (list 1 2 4)) (list 5 4 5) "Sequence test")

   ; fibonacci test
   (check-equal? (last (stream-for-n-steps fibonacci 1)) 0 "Sequence test")
   (check-equal? (last (stream-for-n-steps fibonacci 2)) 1 "Sequence test")
   (check-equal? (last (stream-for-n-steps fibonacci 3)) 1 "Sequence test")
   (check-equal? (last (stream-for-n-steps fibonacci 4)) 2 "Sequence test")
   (check-equal? (last (stream-for-n-steps fibonacci 5)) 3 "Sequence test")

   ; stream-until test
   (check-equal? (stream-until (lambda (x) (< x 2)) powers-of-two) #t "stream-until test") ;prints done
   (check-equal? (stream-until (lambda (x) (<= x 2)) powers-of-two) #t "stream-until test");prints 1 x and done
   (check-equal? (stream-until (lambda (x) (< x 10)) powers-of-two) #t "stream-until test");prints 3 x and done

   ; stream-map test
   (check-equal? (stream-for-n-steps (stream-map (lambda (x) (+ x 1)) ones) 3) (list 2 2 2) "stream-map test")
   (check-equal? (stream-for-n-steps (stream-map (lambda (x) (- x 1)) powers-of-two) 3) (list 1 3 7) "stream-map test")

   ; stream-zip test
   (check-equal? (stream-for-n-steps (stream-zip ones ones) 3) (list (cons 1 1) (cons 1 1) (cons 1 1)) "stream-zip test")
   (check-equal? (stream-for-n-steps (stream-zip powers-of-two ones) 3) (list (cons 2 1) (cons 4 1) (cons 8 1)) "stream-zip test")

   ; interleave test
   (check-equal? (stream-for-n-steps (interleave (list powers-of-two)) 3) (list 2 4 8) "interleave test")
   (check-equal? (stream-for-n-steps (interleave (list ones powers-of-two)) 6) (list 1 2 1 4 1 8) "interleave test")

   ; pack test
   (check-equal? (stream-for-n-steps (pack 3 powers-of-two) 2) (list (list 2 4 8) (list 16 32 64)) "pack test")
   (check-equal? (stream-for-n-steps (pack 2 ones) 2) (list (list 1 1) (list 1 1)) "pack test")

   ; sqrt-stream test
   ;(check-within v1 v2 epsilon [message])
   (check-within (last (stream-for-n-steps (sqrt-stream 4) 10)) 2 0.0001 "sqrt-stream test")
   (check-within (last (stream-for-n-steps (sqrt-stream 100) 10)) 10 0.0001 "sqrt-stream test")
   (println (stream-for-n-steps (sqrt-stream 100) 5))
   (println (stream-for-n-steps (sqrt-stream 4) 5))

   ; approx-sqrt test
   (check-within (approx-sqrt 4 0.0001) 2 0.0001 "sqrt-stream test")
   (check-within (approx-sqrt 100 0.0001) 10 0.0001 "sqrt-stream test")
   
   ; perform test
   (check-equal? (perform (begin (print "e1") 42) if (begin (print "e2") #f)) #f "perform test") ;prints e2 and produces #f
   (check-equal? (perform (begin (print "e1") 42) if (begin (print "e2") 10)) 42 "perform test");prints e2,e1 and produces 42
   (check-equal? (perform (begin (print "e1") 42) unless (begin (print "e2") #f)) 42 "perform test");prints e2,e1 and produces 42
   (check-equal? (perform (begin (print "e1") 42) unless (begin (println "e2") 10)) 10 "perform test");prints e2 and produces 10
;   
   ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)
