#lang racket

(require "hw5.rkt")

(provide (all-defined-out)) ;; so we can put tests in a second file

;Racket structs:

;To practice a little with structs,  we can implement binary trees, with practice problems similar to those from Section 2 and Section 3,
;but of course in Racket instead of ML.  Use the following definitions:

(struct btree-leaf () #:transparent)
(struct btree-node (value left right) #:transparent)

;A binary tree is either (btree-leaf) or a Racket value built from 
;btree-node where the left and right fields are both binary trees.

;Write a function tree-height that accepts a binary tree and evaluates to a height of this tree.
;The height of a tree is the length of the longest path to a leaf. Thus the height of a leaf is 0.

(define (tree-height bt)
  (cond [(btree-leaf? bt) 0]
        [(btree-node? bt) (+ 1
                             (max (tree-height (btree-node-left bt))
                                  (tree-height (btree-node-right bt))))]
        [#t (error "expected types of binary tree")]))


;Write a function sum-tree that takes binary tree and sums all the values in all the nodes.
;(Assume the value fields all hold numbers, i.e., values that you can pass to +.

(define (sum-tree bt)
  (cond [(btree-leaf? bt) 0]
        [(btree-node? bt) (+ (btree-node-value bt)
                             (sum-tree (btree-node-left bt))
                             (sum-tree (btree-node-right bt)))]
        [#t (error "expected types of binary tree")]))


;Write a function prune-at-v that takes a binary tree t and a value v and
;produces a new binary tree with structure the same as t except any node with value equal to v
;(use Racket's equal?) is replaced (along with all its descendants) by a leaf.

(define (prune-at-v t v)
  (cond [(btree-leaf? t) t]
        [(btree-node? t) (let ([node-val (btree-node-value t)])
                           (if (equal? node-val v)
                             (btree-leaf)
                             (btree-node node-val
                                         (prune-at-v (btree-node-left t) v)
                                         (prune-at-v (btree-node-right t) v))))]
        [#t (error "expected types of binary tree")]))


;Write a function well-formed-tree? that takes any value and returns 
;#t if and only if the value is legal binary tree as defined above.

(define (well-formed-tree? bt)
  (or (btree-leaf? bt);either a leaf
      (and (btree-node? bt);or a node with both children well formed
           (well-formed-tree? (btree-node-left bt))
           (well-formed-tree? (btree-node-right bt)))))

;Write a function fold-tree that takes a two-argument function, an initial accumulator, and a binary tree and
;implements a fold over the tree, applying the function to all the values.
;For example, 
;(fold-tree (lambda (x y) (+ x y 1)) 7 
; (btree-node 4 (btree-node 5 (btree-leaf) (btree-leaf)) (btree-leaf))) would evaluate to 18.
;You can traverse the tree in any order you like (though it does affect the result of a call to 
;fold-tree if the function passed isn't associative).

(define (fold-tree f acc bt)
  (cond [(btree-leaf? bt) acc]
        [(btree-node? bt)
         (let ([rl (fold-tree f ;compute result on left branch updating acc to result of applying f to current node value and acc
                              (f (btree-node-value bt) acc)
                              (btree-node-left bt))])
           (fold-tree f rl (btree-node-right bt)))];use rl as new acc for computing right branch
        [#t (error "expected types of binary tree")]))


;Reimplement fold-tree as a curried function.

(define (fold-tree-cur f)
  (lambda (acc)
    (lambda (bt)
      (cond [(btree-leaf? bt) acc]
            [(btree-node? bt)
             (let* ([g (fold-tree-cur f)] ;store in g function resulted from calling fold-tree-cur with f
                    [h (g (f (btree-node-value bt) acc))];;call g with updated acc (result of applying f to current node value and acc) to get new function h
                    [rl (h (btree-node-left bt))]);get result on left branch by calling h on left branch 
               ((g rl) (btree-node-right bt)))];call g with result left to get new function to be applied on right branch
            [#t (error "expected types of binary tree")]))))


;Dynamic typing:

;Write a function crazy-sum that takes a list of numbers and adds them all together, starting from the left.
;There's a twist, however. The list is allowed to contain functions in addition to numbers.
;Whenever an element of a list is a function, you should start using it to combine all the following numbers in a list instead of +.
;You may assume that the list is non-empty and contains only numbers and binary functions suitable for operating on two numbers.
;Further assume the first list element is a number.
;For example, (crazy-sum (list 10 * 6 / 5 - 3)) evaluates to 9
;Note:  It may superficially look like the function implements infix syntax for arithmetic expressions, but that's not really the case.

(define (crazy-sum xs)
  (letrec ([f (lambda (xs acc proc) ;helper function keeps track od remaining list, accumulator and current procedure to apply
                (if (null? xs)
                    acc;reached end of list so produce acc
                    (let ([cur (car xs)]) ;get current element
                      (cond [(number? cur) (f (cdr xs) (proc acc cur) proc)];if number recurse on (cdr xs) with same proc and updated acc by applying current procedure to cur and acc
                            [(procedure? cur) (f (cdr xs) acc cur)];if procedure recurse on (cdr xs) with same acc and updated proc to cur
                            [#t (error "list of only numbers and functions operating on numbers")]))))])
    (f (cdr xs) (car xs) +)));trampoline on (cdr xs) with initial acc number (car xs) and initial procedure +

;Write a function either-fold that is like fold for lists or binary trees as defined above except that it works for both of them.
;Give an appropriate error message if the third argument to either-fold is neither a list nor a binary tree.

(define (either-fold f acc lstorbt)
  (cond [(list? lstorbt) (foldl f acc lstorbt)]
        [(well-formed-tree? lstorbt) (fold-tree f acc lstorbt)]
        [#t (error "expected third argument to be either a list or a binary tree")]))


;Write a function flatten that takes a list and flattens its internal structure, merging all the lists inside into a single flat list.
;This should work for lists nested to arbitrary depth.
;For example, (flatten (list 1 2 (list (list 3 4) 5 (list (list 6) 7 8)) 9 (list 10))) should evaluate to 
;(list 1 2 3 4 5 6 7 8 9 10).

(define (flatten xs)
  (if (null? xs)
      null ;empty list
      (let ([cur (car xs)]) ;get current element
        (if (list? cur)
            (append (flatten cur) (flatten (cdr xs)));if list flatten it recursively and append to result flatenning of rest of list
            (cons cur (flatten (cdr xs)))))));else cons current onto flatenning of rest of list



;Using lambda-calculus ideas to remove features from MUPL programs:

;Like Racket itself, MUPL (the programming language from this section's homework assignment) is essentially
;a superset of untyped lambda calculus.
;"Lambda calculus" may sound scary, but it's essentially a very simple programming language
;it really doesn't have anything in it, apart from anonymous functions and function calls!
;Of course, that makes it very inconvenient to program in, which is also why real programming languages usually supply
;all sorts of bells and whistles, like additional language constructs and data types like booleans and numbers.
;Nonetheless, untyped lambda calculus is Turing-complete, so we can actually represent things like numbers and booleans
;using nothing but functions. In these problems we'll do some of that in MUPL.

;Notice that MUPL doesn't need mlet: Anywhere we have (mlet name e body), we can use (call (fun #f name body) e) instead and get the same result.
;Write a Racket function remove-lets that takes a MUPL program and produces an equivalent MUPL program that does not contain mlet.

(define (remove-lets e)
  (cond [(mlet? e) (call (fun #f (mlet-var e) (remove-lets (mlet-body e)))
                         (remove-lets (mlet-e e)))]
        [(add? e) (add (remove-lets (add-e1 e)) (remove-lets (add-e2 e)))]
        [(ifgreater? e) (ifgreater (remove-lets (ifgreater-e1 e)) (remove-lets (ifgreater-e2 e))
                                   (remove-lets (ifgreater-e3 e)) (remove-lets (ifgreater-e4 e)))]
        [(fun? e) (fun (fun-nameopt e) (fun-formal e) (remove-lets (fun-body e)))]
        [(call? e) (call (remove-lets (call-funexp e)) (remove-lets (call-actual e)))]
        [(apair? e) (apair (remove-lets (apair-e1 e)) (remove-lets (apair-e2 e)))]
        [(fst? e) (fst (remove-lets (fst-e e)))]
        [(snd? e) (snd (remove-lets (snd-e e)))]
        [(isaunit? e) (isaunit (remove-lets (isaunit-e e)))]
        [(closure? e) (closure (closure-env e) (remove-lets (closure-fun e)))]
        [#t e] ;for var, int, aunit
        ))

;[more challenging] Now we will do something even more clever: remove pairs by using
;closure environments as another way to "hold" two pieces of data.
;Instead of using, (apair e1 e2), we can use 
;(mlet "_x" e1
;      (mlet "_y" e2
;            (fun #f "_f"
;                 (call (call (var "_f")
;                             (var "_x"))
;                       (var "_y")))))
;(assuming "_x" isn't already used in e2  -- we will assume that).
;This will evaluate to a closure that has the result of evaluating e1 and e2 in its environment.
;When the closure is called with a function, that function will be called with the result of evaluating e1 and e2 (in curried form).
;So if we replace every apair expression as described above, then we can, rather cleverly, replace 
;(fst e) with
;(call e
;      (fun #f  "x"
;             (fun #f "y" (var "x"))))

;Extend your remove-lets, renaming it remove-lets-and-pairs so that it removes all uses of apair, fst, and snd.
;(We are leaving it to you to figure out how to replace (snd e).

;Note 1: Remember you need to remove things recursively inside of apair, fst, etc., else an expression like 
;(fst (snd (var "x"))) won't have the snd removed.

;Note 2: The resulting program should produce the same result when evaluated if the (original) result doesn't contain any pair values.
;If the original result does contain pair values, the result after removal will contain corresponding closures.

;Note 3: A slightly more challenging approach is to change how apair is removed so that we do not need to assume "_x" is not used in e2.

(define (remove-lets-and-pairs e)
  ;replace apair with mlet
  
  ;  [(apair? e)
  ;   (mlet "_x" (apair-e1 e)
  ;         (mlet "_y" (apair-e2 e)
  ;               (fun #f "_f"
  ;                    (call (call (var "_f")
  ;                                (var "_x"))
  ;                          (var "_y")))))]

  ;change fst and snd without recursion on subexpression
  ;e is not apair any longer, it's a function now storing 2 parts in its env under _x and _y
  ;  [(fst? e) (call (fst-e e)                      ;we call the function with a function that takes param x and
  ;                  (fun #f  "x"                   
  ;                       (fun #f "y" (var "x"))))] ;produces a function that takes param y and produces value of x
  ;  [(snd? e) (call (snd-e e)
  ;                  (fun #f  "x"
  ;                       (fun #f "y" (var "y"))))]


  ;need to make sure there is no var "_x" inside e2 by changing when variable names are created in mlet and fun cases,
  ;and when variable names are used in var case
  (cond
    [(apair? e)
     (call (fun #f "_x"
                (call (fun #f "_y" 
                           (fun #f "_f"
                                (call (call (var "_f")
                                            (var "_x"))
                                      (var "_y"))))
                      (remove-lets-and-pairs (apair-e2 e)))) 
           (remove-lets-and-pairs (apair-e1 e)))]
    [(fst? e) (call (remove-lets-and-pairs (fst-e e)) ;call closure containing "_x" and "_y" in its env
                    (fun #f  "x"                      ;with a function that takes param "x" so in its body "x" is bound to "_x" from closure's env and 
                         (fun #f "y" (var "x"))))]    ;produces a function that takes param "y" so in its body "y" is bound to "_y" from closure's env and produces first part "x"("_x")
    [(snd? e) (call (remove-lets-and-pairs (snd-e e))
                    (fun #f  "x"
                         (fun #f "y" (var "y"))))]    
    [(mlet? e) (let* ([vn (mlet-var e)]
                      [vn (if (string=? vn "_x") ;if variable name in mlet is _x we replace it with _z to avoid shadowing _x in e2 in apair case
                              "_z"
                              vn)])
                 (call (fun #f vn (remove-lets-and-pairs (mlet-body e))) 
                       (remove-lets-and-pairs (mlet-e e))))]
    [(add? e) (add (remove-lets-and-pairs (add-e1 e)) (remove-lets-and-pairs (add-e2 e)))]
    [(ifgreater? e) (ifgreater (remove-lets-and-pairs (ifgreater-e1 e)) (remove-lets-and-pairs (ifgreater-e2 e))
                               (remove-lets-and-pairs (ifgreater-e3 e)) (remove-lets-and-pairs (ifgreater-e4 e)))]
    [(fun? e) (let* ([fun-n (fun-nameopt e)]
                     [fun-n (if (string=? fun-n "_x") ;if function name in fun definition is _x we replace it with _z to avoid shadowing _x in e2 in apair case
                                "_z"
                                fun-n)]
                     [par-n (fun-formal e)]
                     [par-n (if (string=? par-n "_x") ;if param name in fun definition is _x we replace it with _w to avoid shadowing _x in e2 in apair case
                                "_w"
                                par-n)])
                (fun fun-n par-n (remove-lets-and-pairs (fun-body e))))]
    [(call? e) (call (remove-lets (call-funexp e)) (remove-lets-and-pairs (call-actual e)))] 
    [(isaunit? e) (isaunit (remove-lets-and-pairs (isaunit-e e)))]
    [(closure? e) (closure (closure-env e) (remove-lets-and-pairs (closure-fun e)))]
    [(var? e) (let* ([vn (var-string e)])
                     (if (string=? vn "_x") ;if variable name is _x we replace it with (var "_z") to avoid shadowing _x in e2 in apair case
                              (var "_z")
                              e))]
    [#t e])) ;for int, aunit



;More MUPL functions:

;In the first problem, we treat (int 1) as true in MUPL and (int 0) as false in MUPL.

;Define a Racket binding mupl-all that holds a MUPL function that takes a MUPL list and
;evaluates to (MUPL) true if all the list elements are (MUPL) true, else it evaluates to (MUPL) false.


(define mupl-all
  (fun "all" "es" ;MUPL function named "all" which takes a param MUPL list es and 
       (ifaunit (var "es")  ;checks is es is empty (aunit)
                (int 1)    ;produces MUPL true (int 1)
                (mlet "cur" (fst (var "es")) ;else stores in local variable cur (car es) then
                      (ifeq (var "cur")     ;checks if cur is equal to true (int 1)
                            (int 1)
                            (call (var "all") (snd (var "es")));if so keeps recursively checking rest of list
                            (int 0)))))) ;else produce MUPL false (int 0)

;Define a Racket binding mupl-append that holds a MUPL function that takes two MUPL lists (in curried form) and appends them.
(define mupl-append
  (fun "append" "xs" ;MUPL function named "append" that takes a param MUPL list xs and 
       (fun #f "ys" ;produces MUPL function that takes param MUPL list ys and
            (ifaunit (var "xs")  ;checks is xs is empty (aunit)
                     (var "ys")    ;produces ys (append to null)
                     (mlet "cur" (fst (var "xs")) ;else stores in local variable cur (car xs) then
                           (apair (var "cur")     ;makes new MUPL list from cur consed onto
                                  (call (call (var "append") (snd (var "xs"))) (var "ys"))))))));recursive call to append with rest of xs and same ys in curried form

;Define a Racket binding mupl-zip that holds a MUPL function that takes two MUPL lists (in curried form) and
;returns a list of pairs (much like ML's zip).
;If the MUPL lists are different lengths, ignore a suffix of the longer list
;(so the returned list of pairs has a length equal to the shorter of the argument lengths).

(define mupl-zip
  (fun "zip" "xs" ;MUPL function named "zip" that takes a param MUPL list xs and 
       (fun #f "ys" ;produces MUPL function that takes param MUPL list ys and
            (ifaunit (var "xs")  ;checks is xs is empty (aunit)
                     (aunit)    ;produces aunit (stops, ignores suffix of ys which might be longer)
                     (ifaunit (var "ys");xs is not empty so checks for ys
                              (aunit) ;if empty produces aunit (stops, ignores suffix of xs which is longer)
                              (mlet "x1" (fst (var "xs")) ;else stores in local variables x1 (car xs) and y1 (car ys)
                                    (mlet "y1" (fst (var "ys"))
                                          (apair (apair (var "x1") (var "y1"))     ;makes new MUPL list from pair of firsts consed onto
                                                 (call (call (var "zip") (snd (var "xs"))) (snd (var "ys")))))))))));recursive call to zip with rest of xs and rest of ys in curried form

;Redo the previous two problems with the MUPL functions taking a pair with the arguments rather than using currying.
(define mupl-append-pair
  (fun "append" "p" ;MUPL function named "append" that takes a param MUPL pairs of lists and stores in xs and ys its 2 parts
       (mlet "ys" (snd (var "p"))
             (mlet "xs" (fst (var "p"))
                   (ifaunit (var "xs")  ;checks is xs is empty (aunit)
                            (var "ys")    ;produces ys (append to null)
                            (mlet "cur" (fst (var "xs")) ;else stores in local variable cur (car xs) then
                                  (apair (var "cur")     ;makes new MUPL list from cur consed onto
                                         (call (var "append") (apair (snd (var "xs")) (var "ys"))))))))));recursive call to append with new pair of rest of xs and same ys

(define mupl-zip-pair
  (fun "zip" "p" ;MUPL function named "zip" that takes a param pair of 2 MUPL lists xs and ys
       (mlet "ys" (snd (var "p"))
             (mlet "xs" (fst (var "p"))
                   (ifaunit (var "xs")  ;checks is xs is empty (aunit)
                            (aunit)    ;produces aunit (stops, ignores suffix of ys which might be longer)
                            (ifaunit (var "ys");xs is not empty so checks for ys
                                     (aunit) ;if empty produces aunit (stops, ignores suffix of xs which is longer)
                                     (mlet "x1" (fst (var "xs")) ;else stores in local variables x1 (car xs) and y1 (car ys)
                                           (mlet "y1" (fst (var "ys"))
                                                 (apair (apair (var "x1") (var "y1"))     ;makes new MUPL list from pair of firsts consed onto
                                                        (call (var "zip") (apair (snd (var "xs")) (snd (var "ys")))))))))))));recursive call to zip with new pair of rests of xs and ys

;Define a Racket binding mupl-curry that holds a MUPL function that is like ML's
;fun curry f = (fn x y => f (x,y)).

(define mupl-curry
  (fun #f "f"   ;MUPL function that expects as param a function f that should be called with apair
       (fun #f "x" ;produces a function that takes param x
            (fun #f "y";produces function that takes param y
                 (call (var "f") (apair (var "x") (var "y")))))));calls f with apair (x,y)

;Define a Racket binding mupl-uncurry that holds a MUPL function that is like ML's 
;fun uncurry f = (fn (x,y) => f  x y).

(define mupl-uncurry
  (fun #f "f"   ;MUPL function that expects as param a function f in curried format
       (fun #f "p" ;produces a function that takes apair 
            (mlet "x" (fst (var "p")) ;stores in x and y its parts
                  (mlet "y" (snd (var "p"))
                        (call (call (var "f") (var "x")) (var "y")))))));calls f with x than the result with y


;More MUPL macros:

;As above, as needed, we treat (int 1) as true in MUPL and (int 0) as false in MUPL.

;Define a Racket binding if-greater3 that is a MUPL macro (a Racket function) that
;takes 5 MUPL expressions and produces a MUPL program that, when evaluated,
;evaluates the 4th subpexression as the result if the 1st subexpression is greater than the 2nd and the 2nd is greater than the 3rd,
;else it evaluates the 5th subexpression as the result.
;When the MUPL program is evaluated, it should always evaluate the 1st, 2nd, and 3rd subexpressions exactly once each and
;then the 4th subexpression or 5th subexpression but not both.

(define (if-greater3 e1 e2 e3 e4 e5)
  (ifgreater e1 e2
             (ifgreater e2 e3 e4 e5);if e1>e2 it evaluates also if e2>e3, if both produces e4, else e5
             e5))


;Define a Racket binding call-curried that is a MUPL macro (a Racket function) that
;takes a MUPL expression e1 and a Racket list of MUPL expressions e2 and
;produces a MUPL program that, when evaluated, calls the result of evaluating e1
;as a curried function with all of the results of evaluating the expressions in e2.
;For example, instead of writing (call (call e1 ea) eb), you can write 
;(call-curried e1 (list ea eb)).

(define (call-curried e1 e2)
  (if (null? e2) ;if reached end of list (empty e2) produce result e1
      e1
      (let ([f (call e1 (car e2))]);else store in f result of calling current e1 with (car e2)
        (call-curried f (cdr e2)))));then call recursively with f as new e1 and (cdr e2)