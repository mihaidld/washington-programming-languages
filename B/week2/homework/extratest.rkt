#lang racket
;; Programming Languages Extra Problems 5  Simple Test
;; Save this file to the same directory as your homework file
;; These are basic tests.

(require "extra.rkt")
(require "hw5.rkt")

(require rackunit)
  
(define b0 (btree-leaf))
(define b1 (btree-node 1 b0 b0))
(define b2 (btree-node 2 b0 b0))
(define b3 (btree-node 3 b1 b2))
(define b4 (btree-node 3 b0 b3))
  

(define tests
  (test-suite
   "Sample tests for Extra Problems 5"
   
   ;; check tree-height
   (check-equal? (tree-height b0) 0 "tree-height")
   (check-equal? (tree-height b2) 1 "tree-height")
   (check-equal? (tree-height b4) 3 "tree-height")
   (check-exn 
    #rx"expected types of binary tree"
    (lambda () (tree-height (btree-node 3 4 b0)))) ;not binary tree type 

   ;; check sum-tree
   (check-equal? (sum-tree b0) 0 "sum-tree")
   (check-equal? (sum-tree b2) 2 "sum-tree")
   (check-equal? (sum-tree b4) 9 "sum-tree")
   
   ;; check prune-at-v
   (check-equal? (prune-at-v b0 2) b0 "prune-at-v")
   (check-equal? (prune-at-v b2 2) b0 "prune-at-v")
   (check-equal? (prune-at-v b2 3) b2 "prune-at-v")
   (check-equal? (prune-at-v b4 2) (btree-node 3 b0 (btree-node 3 b1 b0)) "prune-at-v")
   (check-equal? (prune-at-v b4 4) b4 "prune-at-v")

      ;; check well-formed-tree?
   (check-equal? (well-formed-tree? b0) #t "well-formed-tree?")
   (check-equal? (well-formed-tree? b2) #t "well-formed-tree?")
   (check-equal? (well-formed-tree? b4) #t "well-formed-tree?")
   (check-equal? (well-formed-tree? 2) #f "well-formed-tree?")
   (check-equal? (well-formed-tree? (btree-node 3 b3 (btree-node 2 4 5))) #f "well-formed-tree?")

   ;check fold-tree
   (check-equal? (fold-tree (lambda (x y) (+ x y 1)) 7 
                            (btree-node 4
                                        (btree-node 5 (btree-leaf) (btree-leaf))
                                        (btree-leaf))) 18 "fold-tree")
   (check-equal? (fold-tree (lambda (x y) (+ x y 1)) 7 
                            (btree-leaf)) 7 "fold-tree")
   (check-equal? (fold-tree (lambda (x y) (+ x y 1)) 7 
                            (btree-node 4
                                        (btree-leaf)
                                        (btree-leaf))) 12 "fold-tree")

   ;check fold-tree-cur
   (check-equal? (((fold-tree-cur (lambda (x y) (+ x y 1))) 7) 
                  (btree-node 4
                              (btree-node 5 (btree-leaf) (btree-leaf))
                              (btree-leaf))) 18 "fold-tree-cur")
   (check-equal? (((fold-tree-cur (lambda (x y) (+ x y 1))) 7) 
                  (btree-leaf)) 7 "fold-tree-cur")
   (check-equal? (((fold-tree-cur (lambda (x y) (+ x y 1))) 7) 
                  (btree-node 4
                              (btree-leaf)
                              (btree-leaf))) 12 "fold-tree-cur")

    ;check crazy-sum
   (check-equal? (crazy-sum (list 10 * 6 / 5 - 3)) 9 "crazy-sum")
   (check-equal? (crazy-sum (list 10)) 10 "crazy-sum")
   (check-equal? (crazy-sum (list 10 * 2 3)) 60 "crazy-sum")
   (check-equal? (crazy-sum (list 10 10 * 6 1 / 12 2)) 5 "crazy-sum")

   ;check either-fold
   (check-equal? (either-fold (lambda (x y) (+ x y 1)) 7 
                              (btree-node 4
                                          (btree-node 5 (btree-leaf) (btree-leaf))
                                          (btree-leaf))) 18 "either-fold")
   (check-equal? (either-fold (lambda (x y) (+ x y 1)) 7 
                              (list 4 5)) 18 "either-fold")
   (check-exn 
    #rx"expected third argument to be either a list or a binary tree"
    (lambda () (either-fold (lambda (x y) (+ x y 1)) 7 
                            (cons 4 5)))) ;not list or binary tree type 

   ;check flatten
   (check-equal? (flatten (list 1 2 (list (list 3 4) 5 (list (list 6) 7 8)) 9 (list 10))) (list 1 2 3 4 5 6 7 8 9 10)
                 "flatten")
   (check-equal? (flatten (list 1 (list 2 (list 3 (list 4) 5)))) (list 1 2 3 4 5)
                          "flatten")

   ;check remove-lets
   (check-equal? (remove-lets (mlet "x" (int 1) (add (int 5) (mlet "y" (int 3) (add (var "x") (var "y"))))))
                 (call (fun #f "x" (add (int 5) (call (fun #f "y" (add (var "x") (var "y"))) (int 3)))) (int 1)) "remove-lets test")

   ;check remove-lets-and-pairs
   (check-equal? (remove-lets-and-pairs (mlet "x" (int 1) (add (int 5) (mlet "y" (int 3) (add (var "x") (var "y"))))))
                 (call (fun #f "x" (add (int 5) (call (fun #f "y" (add (var "x") (var "y"))) (int 3)))) (int 1)) "remove-lets-and-pairs test")
   (check-equal? (eval-exp (remove-lets-and-pairs (fst (apair (int 1) (int 2))))) (int 1) "fst test")
   (check-equal? (eval-exp (remove-lets-and-pairs (fst (apair (add (int 1) (int 1)) (int 1))))) (int 2) "fst test")
   (check-equal? (eval-exp (remove-lets-and-pairs (apair (add (int 1) (int 2)) (int 4))))
                 (closure
                  (list (cons "_y" (int 4)) (cons "_x" (int 3)))
                  (fun #f "_f"
                       (call
                        (call (var "_f") (var "_x"))
                        (var "_y")))) "apair test")
   (check-equal? (eval-exp (remove-lets-and-pairs (apair
                                                   (call (fun "_x" "_x" (add (int 1) (int 2)));
                                                         (int 17))
                                                   (int 4))))
                 (closure
                  (list (cons "_y" (int 4)) (cons "_x" (int 3)))
                  (fun #f "_f"
                       (call
                        (call (var "_f") (var "_x"))
                        (var "_y")))) "apair test")
   (check-equal? (eval-exp (remove-lets-and-pairs (fun "_x" "_x" (add (int 1) (int 2)))))
                 (closure
                  null
                  (fun "_z" "_w"    ;replaces function name and param if _x with _z and _w respectively 
                       (add (int 1) (int 2)))) "apair test")
   (check-equal? (eval-exp (remove-lets-and-pairs (snd (apair (int 1) (int 2))))) (int 2) "snd test")
   (check-equal? (eval-exp (remove-lets-and-pairs (snd (apair (int 1) (add (int 1) (int 1)))))) (int 2) "snd test")
   ;replaces variable name _x with _z
   (check-equal? (remove-lets-and-pairs (mlet "_x" (int 1) (add (int 5) (mlet "y" (int 3) (add (var "_x") (var "y"))))))
                 (call (fun #f "_z" (add (int 5) (call (fun #f "y" (add (var "_z") (var "y"))) (int 3)))) (int 1)) "mlet test")

   ;check mupl-all
   (check-equal? (eval-exp (call mupl-all (racketlist->mupllist (list (int 1) (int 1) (int 1))))) (int 1) "mupl-all")
   (check-equal? (eval-exp (call mupl-all (aunit))) (int 1) "mupl-all")
   (check-equal? (eval-exp (call mupl-all (racketlist->mupllist (list (int 1) (int 1) (int 0) (int 1))))) (int 0) "mupl-all")
   (check-equal? (eval-exp (call mupl-all (racketlist->mupllist (list (int 0))))) (int 0) "mupl-all")

   ;check mupl-append
   (check-equal? (eval-exp (call (call mupl-append (racketlist->mupllist (list (int 1) (int 2))))
                                 (racketlist->mupllist (list (int 3) (int 4)))))
                 (racketlist->mupllist (list (int 1) (int 2) (int 3) (int 4)))  "mupl-append")
   (check-equal? (eval-exp (call (call mupl-append (racketlist->mupllist (list (int 1) (int 2))))
                                 (aunit)))
                 (racketlist->mupllist (list (int 1) (int 2)))  "mupl-append")
   (check-equal? (eval-exp (call (call mupl-append (aunit))
                                 (racketlist->mupllist (list (int 3) (int 4)))))
                 (racketlist->mupllist (list (int 3) (int 4)))  "mupl-append")

   ;check mupl-zip
   (check-equal? (eval-exp (call (call mupl-zip (racketlist->mupllist (list (int 1) (int 2))))
                                 (racketlist->mupllist (list (int 3) (int 4)))))
                 (racketlist->mupllist (list (apair (int 1) (int 3)) (apair (int 2) (int 4))))  "mupl-zip")
   (check-equal? (eval-exp (call (call mupl-zip (racketlist->mupllist (list (int 1))))
                                 (racketlist->mupllist (list (int 3) (int 4)))))
                 (racketlist->mupllist (list (apair (int 1) (int 3))))  "mupl-zip")
   (check-equal? (eval-exp (call (call mupl-zip (racketlist->mupllist (list (int 1) (int 2))))
                                 (racketlist->mupllist (list (int 3)))))
                 (racketlist->mupllist (list (apair (int 1) (int 3))))  "mupl-zip")

   ;check mupl-append-pair
   (check-equal? (eval-exp (call mupl-append-pair (apair (racketlist->mupllist (list (int 1) (int 2)))
                                                         (racketlist->mupllist (list (int 3) (int 4))))))
                 (racketlist->mupllist (list (int 1) (int 2) (int 3) (int 4)))  "mupl-append-pair")
   (check-equal? (eval-exp (call mupl-append-pair (apair (racketlist->mupllist (list (int 1) (int 2)))
                                                         (aunit))))
                 (racketlist->mupllist (list (int 1) (int 2)))  "mupl-append-pair")
   (check-equal? (eval-exp (call mupl-append-pair (apair (aunit)
                                                         (racketlist->mupllist (list (int 3) (int 4))))))
                 (racketlist->mupllist (list (int 3) (int 4)))  "mupl-append-pair")

   ;check mupl-zip-pair
   (check-equal? (eval-exp (call mupl-zip-pair (apair (racketlist->mupllist (list (int 1) (int 2)))
                                                      (racketlist->mupllist (list (int 3) (int 4))))))
                 (racketlist->mupllist (list (apair (int 1) (int 3)) (apair (int 2) (int 4))))  "mupl-zip-pair")
   (check-equal? (eval-exp (call mupl-zip-pair (apair (racketlist->mupllist (list (int 1)))
                                                      (racketlist->mupllist (list (int 3) (int 4))))))
                 (racketlist->mupllist (list (apair (int 1) (int 3))))  "mupl-zip-pair")
   (check-equal? (eval-exp (call mupl-zip-pair (apair (racketlist->mupllist (list (int 1) (int 2)))
                                                      (racketlist->mupllist (list (int 3))))))
                 (racketlist->mupllist (list (apair (int 1) (int 3))))  "mupl-zip-pair")

   ;check mupl-curry
   (check-equal? (eval-exp (call mupl-curry (fun "addit" "p" (add (fst (var "p")) (snd (var "p"))))))
                 (closure (list (cons "f"
                                      (closure '() (fun "addit" "p" (add (fst (var "p")) (snd (var "p")))))))
                          (fun #f "x" (fun #f "y" (call (var "f") (apair (var "x") (var "y"))))))
                 "mupl-curry")

   ;check mupl-uncurry
   (check-equal? (eval-exp (call mupl-uncurry (fun "addit" "x" (fun #f "y" (add (var "x") (var "y"))))))
                 (closure
                  (list (cons "f" (closure '() (fun "addit" "x" (fun #f "y" (add (var "x") (var "y")))))))
                  (fun #f "p"
                       (mlet "x" (fst (var "p"))
                             (mlet "y" (snd (var "p"))
                                   (call (call (var "f") (var "x"))
                                         (var "y"))))))
                 "mupl-uncurry")


   ;; tests if-greater3
   (check-equal? (eval-exp (if-greater3 (int 3) (int 2) (int 1) (int 10) (int 20))) (int 10) "if-greater3 test")
   (check-equal? (eval-exp (if-greater3 (int 3) (int 2) (int 4) (int 10) (int 20))) (int 20) "if-greater3 test")
   (check-equal? (eval-exp (if-greater3 (int 1) (int 2) (int 3) (int 10) (int 20))) (int 20) "if-greater3 test")

   ;; tests call-curried
   (check-equal? (eval-exp (call-curried (fun #f "x" (fun #f "y" (add (var "x") (var "y")))) (list (int 2) (int 3))))
                 (eval-exp (call (call (fun #f "x" (fun #f "y" (add (var "x") (var "y")))) (int 2)) (int 3)))
                 "call-curried test")
   
   ))


(require rackunit/text-ui)
;; runs the test
(run-tests tests)
