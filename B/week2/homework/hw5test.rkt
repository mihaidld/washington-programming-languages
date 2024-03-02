#lang racket
;; Programming Languages Homework 5 Simple Test
;; Save this file to the same directory as your homework file
;; These are basic tests. Passing these tests does not guarantee that your code will pass the actual homework grader

;; Be sure to put your homework file in the same folder as this test file.
;; Uncomment the line below and, if necessary, change the filename
(require "hw5.rkt")

(require rackunit)

(define tests
  (test-suite
   "Sample tests for Assignment 5"
   
   ;; check racketlist to mupllist with normal list
   (check-equal? (racketlist->mupllist (list (int 3) (int 4))) (apair (int 3) (apair (int 4) (aunit))) "racketlist->mupllist test")
   (check-equal? (racketlist->mupllist (list (int 3))) (apair (int 3) (aunit)) "racketlist->mupllist test")
   (check-equal? (racketlist->mupllist null) (aunit) "racketlist->mupllist test")
         
   ;; check mupllist to racketlist with normal list
   (check-equal? (mupllist->racketlist (apair (int 3) (apair (int 4) (aunit)))) (list (int 3) (int 4)) "racketlist->mupllist test")
   (check-equal? (mupllist->racketlist (apair (int 4) (aunit))) (list (int 4)) "racketlist->mupllist test")
   (check-equal? (mupllist->racketlist (aunit)) null "racketlist->mupllist test")

   ;; tests for evaluating var
   (check-equal? (eval-under-env (var "x") (list (cons "y" (int 5)) (cons "x" (int 3)))) (int 3) "var test")
   (check-exn 
    #rx"unbound variable during evaluation"
    (lambda () (eval-under-env (var "z") (list (cons "y" (int 5)) (cons "x" (int 3)))))) ;unbound variable
   
   ;; tests for evaluating int
   (check-equal? (eval-exp (int 1)) (int 1) "int test")
         
   ;; tests for evaluating add
   (check-equal? (eval-exp (add (int 3) (int 4))) (int 7) "add test")
   (check-exn 
    #rx"MUPL addition applied to non-number"
    (lambda () (eval-exp (add (int 3) (closure '() (fun #f "x" (int 7))))))) ;add int with closure

   ;; tests for fun
   (check-equal? (eval-exp (fun #f "x" (int 7))) (closure '() (fun #f "x" (int 7))) "fun test")
   (check-equal? (eval-exp (fun "f" "x" (int 7))) (closure '() (fun "f" "x" (int 7))) "fun test")
   (check-equal? (eval-exp (closure '() (fun #f "x" (add (var "x") (int 7))))) (closure '() (fun #f "x" (add (var "x") (int 7)))) "closure test")
       
   ;; tests if ifgreater returns (int 2)
   (check-equal? (eval-exp (ifgreater (int 3) (int 4) (int 3) (int 2))) (int 2) "ifgreater test")
   (check-equal? (eval-exp (ifgreater (int 4) (int 1) (int 3) (int 2))) (int 3) "ifgreater test")
   (check-exn 
    #rx"MUPL ifgreater needs integer expressions as first 2 subexpressions"
    (lambda () (eval-exp (ifgreater (int 3) (closure '() (fun #f "x" (int 7))) (int 3) (int 2))))) ;compare int with closure
            
   ;; mlet test
   (check-equal? (eval-exp (mlet "x" (int 1) (add (int 5) (var "x")))) (int 6) "mlet test")
   (check-equal? (eval-under-env (mlet "x" (int 1) (add (int 5) (var "x")))
                                 (list (cons "y" (int 5)) (cons "x" (int 3)))) (int 6) "mlet test with local shadowing")
   (check-exn 
    #rx"MUPL mlet needs string as first subexpression"
    (lambda () (eval-exp (mlet 3 (int 1) (add (int 5) (var "x")))))) ;first arg to mlet not string
      
   ;; call test
   (check-equal? (eval-exp (call (closure '() (fun #f "x" (add (var "x") (int 7)))) (int 1))) (int 8) "call test")
   (check-equal? (eval-exp (call (closure (list (cons "y" (int 5)) (cons "z" (int 3)))
                                          (fun #f "x" (add (add (var "x") (var "y")) (var "z"))))
                                 (int 1)))
                 (int 9) "call test with non-empty env")
   (check-exn 
    #rx"unbound variable during evaluation"
    (lambda () (eval-exp (call (closure (list (cons "y" (int 5)) (cons "z" (int 3)))
                                        (fun #f "x" (add (add (var "x") (var "y")) (var "w"))))
                               (int 1))))) ;call doesn't find w in env
   (check-exn 
    #rx"MUPL call needs closure expression as first subexpression"
    (lambda () (eval-exp (call (int 3) (int 1))))) ;call finds number instead of closure

   ;; tests for evaluating apair
   (check-equal? (eval-exp (apair (int 3) (int 4))) (apair (int 3) (int 4)) "apair test")
   (check-equal? (eval-exp (apair (add (int 3) (int 1))
                                  (closure '() (fun #f "x" (add (var "x") (int 7))))))
                           (apair (int 4) (closure '() (fun #f "x" (add (var "x") (int 7)))))
                           "apair test")

   ;;fst test
   (check-equal? (eval-exp (fst (apair (int 1) (int 2)))) (int 1) "fst test")
   (check-equal? (eval-exp (fst (apair (add (int 1) (int 1)) (int 1)))) (int 2) "fst test")
   (check-exn 
    #rx"fst expected apair type"
    (lambda () (eval-exp (fst (int 1))))) ;fst passed not apair arg
   
   ;;snd test
   (check-equal? (eval-exp (snd (apair (int 1) (int 2)))) (int 2) "snd test")
   (check-equal? (eval-exp (snd (apair (int 1) (add (int 1) (int 1))))) (int 2) "snd test")
   (check-exn 
    #rx"snd expected apair type"
    (lambda () (eval-exp (snd (int 1))))) ;snd passed not apair arg
   
   ;aunit test
   (check-equal? (eval-exp (aunit)) (aunit) "aunit test")
   
   ;; isaunit test
   (check-equal? (eval-exp (isaunit (closure '() (fun #f "x" (aunit))))) (int 0) "isaunit test")
   (check-equal? (eval-exp (isaunit (aunit))) (int 1) "isaunit test")

   ;not supported type
;   (check-exn 
;    #rx"bad MUPL expression: TODO"
;    (lambda () (eval-exp (New-int 1)))) ;not supported type
      
   ;; ifaunit test
   (check-equal? (eval-exp (ifaunit (int 1) (int 2) (int 3))) (int 3) "ifaunit test")
   (check-equal? (eval-exp (ifaunit (aunit) (int 2) (int 3))) (int 2) "ifaunit test")
   
   ;; mlet* test
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10))) (var "x"))) (int 10) "mlet* test")
   (check-equal? (eval-exp (mlet* (list (cons "x" (int 10))
                                        (cons "y" (add (var "x") (int 10)))
                                        (cons "z" (add (var "y") (int 10))))
                                  (add (var "x") (add (var "y") (var "z"))))) (int 60) "mlet* test")
      
;   
   ;; ifeq test
   (check-equal? (eval-exp (ifeq (int 1) (int 2) (int 3) (int 4))) (int 4) "ifeq test")
   (check-equal? (eval-exp (ifeq (int 1) (int 1) (int 3) (int 4))) (int 3) "ifeq test")
   (check-equal? (eval-exp (ifeq (add (int 1) (int 2)) (add (int 2) (int 1)) (int 3) (int 4))) (int 3) "ifeq test")
   (check-equal? (eval-exp (ifeq (add (int 1) (int 2)) (add (int 2) (int 2)) (int 3) (int 4))) (int 4) "ifeq test")
   (check-exn 
    #rx"MUPL ifgreater needs integer expressions as first 2 subexpressions"
    (lambda () (eval-exp (ifeq (int 1) (aunit) (int 3) (int 4))))) ;if-eq passed not int arg among first two subexpressions
   (check-exn 
     #rx"MUPL ifgreater needs integer expressions as first 2 subexpressions"
     (lambda () (eval-exp (ifeq (aunit) (int 1) (int 3) (int 4))))) ;if-eq passed not int arg among first two subexpressions
    
   ;; mupl-map test
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 7)))) (apair (int 1) (aunit)))) 
                 (apair (int 8) (aunit)) "mupl-map test")
   (check-equal? (eval-exp (call (call mupl-map (fun #f "x" (add (var "x") (int 7)))) (apair (int 1) (apair (int 3) (apair (int 5) (aunit)))))) 
                 (apair (int 8) (apair (int 10) (apair (int 12) (aunit)))) "mupl-map test")
   
   ;; problems 1, 2, and 4 combined test
   (check-equal? (mupllist->racketlist
   (eval-exp (call (call mupl-mapAddN (int 7))
                   (racketlist->mupllist 
                    (list (int 3) (int 4) (int 9)))))) (list (int 10) (int 11) (int 16)) "combined test")
   (check-equal? (mupllist->racketlist
                  (eval-exp (call (call mupl-mapAddN (int 7))
                                  (racketlist->mupllist 
                                   (list))))) (list) "combined test")

;;Test for challenge compute-free-vars
   
   (check-equal? (compute-free-vars (fun #f "x"
                                         (fun #f "y"
                                              (add (add (var "x") (var "y")) (add (var "w") (var "z"))))))
                 (fun-challenge #f "x"
                                (fun-challenge #f "y"
                                               (add (add (var "x") (var "y")) (add (var "w") (var "z")))
                                               (set "x" "z" "w"))
                                (set "z" "w")) "compute-free-vars test")

   (check-equal? (compute-free-vars (fun #f "x"
                                         (mlet "y" (int 3)
                                              (add (add (var "x") (var "y")) (add (var "w") (var "z"))))))
                 (fun-challenge #f "x"
                               (mlet "y" (int 3)
                                               (add (add (var "x") (var "y")) (add (var "w") (var "z"))))
                                (set "z" "w")) "compute-free-vars test")

   (check-equal? (compute-free-vars (fun #f "x"
                                         (apair (var "y")
                                                (fun #f "y"
                                                     (add (add (var "x") (var "y")) (add (var "w") (var "z")))))))
                 (fun-challenge #f "x"
                                (apair (var "y")
                                       (fun-challenge #f "y"
                                                      (add (add (var "x") (var "y")) (add (var "w") (var "z")))
                                                      (set "x" "z" "w")))
                                (set "y" "z" "w")) "compute-free-vars test")

   ;;Test for challenge eval-exp-c
   
    ;; tests for evaluating var
   (check-equal? (eval-under-env-c (var "x") (list (cons "y" (int 5)) (cons "x" (int 3)))) (int 3) "var test")
   (check-exn 
    #rx"unbound variable during evaluation"
    (lambda () (eval-under-env-c (var "z") (list (cons "y" (int 5)) (cons "x" (int 3)))))) ;unbound variable
   
   ;; tests for evaluating int
   (check-equal? (eval-exp-c (int 1)) (int 1) "int test")
         
   ;; tests for evaluating add
   (check-equal? (eval-exp-c (add (int 3) (int 4))) (int 7) "add test")
   (check-exn 
    #rx"MUPL addition applied to non-number"
    (lambda () (eval-exp-c (add (int 3) (closure '() (fun #f "x" (int 7))))))) ;add int with closure

   ;; tests for fun
   (check-equal? (eval-exp-c (fun #f "x" (int 7))) (closure '() (fun-challenge #f "x" (int 7) (set))) "fun-challenge test")
   (check-equal? (eval-exp-c (fun "f" "x" (int 7))) (closure '() (fun-challenge "f" "x" (int 7) (set))) "fun-challenge test")
   (check-equal? (eval-exp-c (closure '() (fun #f "x" (add (var "x") (int 7))))) (closure '() (fun-challenge #f "x" (add (var "x") (int 7)) (set))) "closure test")
   (check-equal? (eval-exp-c (mlet "x" (int 3) (mlet "z" (int 4) (fun #f "y" (add (var "x") (add (var "y") (var "z")))))))
                 (closure (list (cons "z" (int 4)) (cons "x" (int 3))) (fun-challenge #f "y" (add (var "x") (add (var "y") (var "z"))) (set "x" "z"))) "closure test")
       
   ;; tests if ifgreater returns (int 2)
   (check-equal? (eval-exp-c (ifgreater (int 3) (int 4) (int 3) (int 2))) (int 2) "ifgreater test")
   (check-equal? (eval-exp-c (ifgreater (int 4) (int 1) (int 3) (int 2))) (int 3) "ifgreater test")
   (check-exn 
    #rx"MUPL ifgreater needs integer expressions as first 2 subexpressions"
    (lambda () (eval-exp-c (ifgreater (int 3) (aunit) (int 3) (int 2))))) ;compare int with aunit
            
   ;; mlet test
   (check-equal? (eval-exp-c (mlet "x" (int 1) (add (int 5) (var "x")))) (int 6) "mlet test")
   (check-equal? (eval-under-env-c (mlet "x" (int 1) (add (int 5) (var "x")))
                                 (list (cons "y" (int 5)) (cons "x" (int 3)))) (int 6) "mlet test with local shadowing")
   (check-exn 
    #rx"MUPL mlet needs string as first subexpression"
    (lambda () (eval-exp-c (mlet 3 (int 1) (add (int 5) (var "x")))))) ;first arg to mlet not string
      
   ;; call test
   (check-equal? (eval-exp-c (call (closure '() (fun #f "x" (add (var "x") (int 7)))) (int 1))) (int 8) "call test")
   (check-equal? (eval-exp-c (call (closure (list (cons "y" (int 5)) (cons "z" (int 3)))
                                          (fun #f "x" (add (add (var "x") (var "y")) (var "z"))))
                                 (int 1)))
                 (int 9) "call test with non-empty env")
   (check-exn 
    #rx"unbound variable during evaluation"
    (lambda () (eval-exp-c (call (closure (list (cons "y" (int 5)) (cons "z" (int 3)))
                                        (fun #f "x" (add (add (var "x") (var "y")) (var "w"))))
                               (int 1))))) ;call doesn't find w in env
   (check-exn 
    #rx"MUPL call needs closure expression as first subexpression"
    (lambda () (eval-exp-c (call (int 3) (int 1))))) ;call finds number instead of closure

   ;; tests for evaluating apair
   (check-equal? (eval-exp-c (apair (int 3) (int 4))) (apair (int 3) (int 4)) "apair test")
   (check-equal? (eval-exp-c (apair (add (int 3) (int 1))
                                  (closure '() (fun #f "x" (add (var "x") (int 7))))))
                           (apair (int 4) (closure '() (fun-challenge #f "x" (add (var "x") (int 7)) (set))))
                           "apair test")

   ;;fst test
   (check-equal? (eval-exp-c (fst (apair (int 1) (int 2)))) (int 1) "fst test")
   (check-equal? (eval-exp-c (fst (apair (add (int 1) (int 1)) (int 1)))) (int 2) "fst test")
   (check-exn 
    #rx"fst expected apair type"
    (lambda () (eval-exp-c (fst (int 1))))) ;fst passed not apair arg
   
   ;;snd test
   (check-equal? (eval-exp-c (snd (apair (int 1) (int 2)))) (int 2) "snd test")
   (check-equal? (eval-exp-c (snd (apair (int 1) (add (int 1) (int 1))))) (int 2) "snd test")
   (check-exn 
    #rx"snd expected apair type"
    (lambda () (eval-exp-c (snd (int 1))))) ;snd passed not apair arg
   
   ;aunit test
   (check-equal? (eval-exp-c (aunit)) (aunit) "aunit test")
   
   ;; isaunit test
   (check-equal? (eval-exp-c (isaunit (closure '() (fun #f "x" (aunit))))) (int 0) "isaunit test")
   (check-equal? (eval-exp-c (isaunit (aunit))) (int 1) "isaunit test")

   ;not supported type
;   (check-exn 
;    #rx"bad MUPL expression: TODO"
;    (lambda () (eval-exp-c (New-int 1)))) ;not supported type
      
   ;; ifaunit test
   (check-equal? (eval-exp-c (ifaunit (int 1) (int 2) (int 3))) (int 3) "ifaunit test")
   (check-equal? (eval-exp-c (ifaunit (aunit) (int 2) (int 3))) (int 2) "ifaunit test")
   
   ;; mlet* test
   (check-equal? (eval-exp-c (mlet* (list (cons "x" (int 10))) (var "x"))) (int 10) "mlet* test")
   (check-equal? (eval-exp-c (mlet* (list (cons "x" (int 10))
                                        (cons "y" (add (var "x") (int 10)))
                                        (cons "z" (add (var "y") (int 10))))
                                  (add (var "x") (add (var "y") (var "z"))))) (int 60) "mlet* test")
      
;   
   ;; ifeq test
   (check-equal? (eval-exp-c (ifeq (int 1) (int 2) (int 3) (int 4))) (int 4) "ifeq test")
   (check-equal? (eval-exp-c (ifeq (int 1) (int 1) (int 3) (int 4))) (int 3) "ifeq test")
   (check-equal? (eval-exp-c (ifeq (add (int 1) (int 2)) (add (int 2) (int 1)) (int 3) (int 4))) (int 3) "ifeq test")
   (check-equal? (eval-exp-c (ifeq (add (int 1) (int 2)) (add (int 2) (int 2)) (int 3) (int 4))) (int 4) "ifeq test")
   (check-exn 
    #rx"MUPL ifgreater needs integer expressions as first 2 subexpressions"
    (lambda () (eval-exp-c (ifeq (int 1) (aunit) (int 3) (int 4))))) ;if-eq passed not int arg among first two subexpressions
   (check-exn 
     #rx"MUPL ifgreater needs integer expressions as first 2 subexpressions"
     (lambda () (eval-exp-c (ifeq (aunit) (int 1) (int 3) (int 4))))) ;if-eq passed not int arg among first two subexpressions
    
   ;; mupl-map test
   (check-equal? (eval-exp-c (call (call mupl-map (fun #f "x" (add (var "x") (int 7)))) (apair (int 1) (aunit)))) 
                 (apair (int 8) (aunit)) "mupl-map test")
   (check-equal? (eval-exp-c (call (call mupl-map (fun #f "x" (add (var "x") (int 7)))) (apair (int 1) (apair (int 3) (apair (int 5) (aunit)))))) 
                 (apair (int 8) (apair (int 10) (apair (int 12) (aunit)))) "mupl-map test")
   
   ;; problems 1, 2, and 4 combined test
   (check-equal? (mupllist->racketlist
   (eval-exp-c (call (call mupl-mapAddN (int 7))
                   (racketlist->mupllist 
                    (list (int 3) (int 4) (int 9)))))) (list (int 10) (int 11) (int 16)) "combined test")
   (check-equal? (mupllist->racketlist
                  (eval-exp-c (call (call mupl-mapAddN (int 7))
                                  (racketlist->mupllist 
                                   (list))))) (list) "combined test")
   

   ))

(require rackunit/text-ui)
;; runs the test
(run-tests tests)
