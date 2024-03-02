;; Programming Languages, Homework 5

#lang racket
(provide (all-defined-out)) ;; so we can put tests in a second file

;Overview: This homework has to do with mupl (a Made Up Programming Language).
;mupl programs are written directly in Racket by using the constructors defined by the structs defined at the beginning of
;hw5.rkt. This is the definition of mupl's syntax:
;  - If s is a Racket string, then (var s) is a mupl expression (a variable use).
;  - If n is a Racket integer, then (int n) is a mupl expression (a constant).
;  - If e1 and e2 are mupl expressions, then (add e1 e2) is a mupl expression (an addition).
;  - If s1 and s2 are Racket strings and e is a mupl expression, then (fun s1 s2 e) is a mupl expression (a function).
;In e, s1 is bound to the function itself (for recursion) and s2 is bound to the (one) argument.
;Also, (fun #f s2 e) is allowed for anonymous nonrecursive functions.
;  - If e1, e2, and e3, and e4 are mupl expressions, then (ifgreater e1 e2 e3 e4) is a mupl expression.
;It is a conditional where the result is e3 if e1 is strictly greater than e2 else the result is e4.
;Only one of e3 and e4 is evaluated.
;  - If e1 and e2 are mupl expressions, then (call e1 e2) is a mupl expression (a function call).
;  - If s is a Racket string and e1 and e2 are mupl expressions, then (mlet s e1 e2) is a mupl expression
;(a let expression where the value resulting e1 is bound to s in the evaluation of e2).
;  - If e1 and e2 are mupl expressions, then (apair e1 e2) is a mupl expression (a pair-creator).
;  - If e1 is a mupl expression, then (fst e1) is a mupl expression (getting the first part of a pair).
;  - If e1 is a mupl expression, then (snd e1) is a mupl expression (getting the second part of a pair).
;  - (aunit) is a mupl expression (holding no data, much like () in ML or null in Racket).
;Notice (aunit) is a mupl expression, but aunit is not.
;  - If e1 is a mupl expression, then (isaunit e1) is a mupl expression (testing for (aunit)).
;  - (closure env f) is a mupl value where f is mupl function (an expression made from fun) and env
;is an environment mapping variables to values. Closures do not appear in source programs; they result
;from evaluating functions.
;A mupl value is a mupl integer constant, a mupl closure, a mupl aunit, or a mupl pair of mupl values.
;Similar to Racket, we can build list values out of nested pair values that end with a mupl aunit. Such a
;mupl value is called a mupl list.
;You should assume mupl programs are syntactically correct (e.g., do not worry about wrong things like (int
;"hi") or (int (int 37)). But do not assume mupl programs are free of type errors like (add (aunit)
;(int 7)) or (fst (int 7)).
;Warning: What makes this assignment challenging is that you have to understand mupl well and debugging
;an interpreter is an acquired skill.

;; definition of structures for MUPL programs - Do NOT change
(struct var  (string) #:transparent)  ;; a variable, e.g., (var "foo")
(struct int  (num)    #:transparent)  ;; a constant number, e.g., (int 17)
(struct add  (e1 e2)  #:transparent)  ;; add two expressions
(struct ifgreater (e1 e2 e3 e4)    #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun  (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual)       #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body) 
(struct apair (e1 e2)     #:transparent) ;; make a new pair
(struct fst  (e)    #:transparent) ;; get first part of a pair
(struct snd  (e)    #:transparent) ;; get second part of a pair
(struct aunit ()    #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0

;; a closure is not in "source" programs but /is/ a MUPL value; it is what functions evaluate to
(struct closure (env fun) #:transparent) 

;; Problem 1 Warm-Up:
;(a) Write a Racket function racketlist->mupllist that takes a Racket list (presumably of mupl
;values but that will not affect your solution) and produces an analogous mupl list with the same
;elements in the same order.

(define (racketlist->mupllist es)
  (cond [(null? es) (aunit)];empty list so produce unit value
        [(list? es) (apair (car es) ;make pair from (car es) and recursive call on (cdr es)
                           (racketlist->mupllist (cdr es)))]
        [#t (error "racketlist->mupllist expected Racket list")]))

;(b) Write a Racket function mupllist->racketlist that takes a mupl list (presumably of mupl
;values but that will not affect your solution) and produces an analogous Racket list (of mupl
;values) with the same elements in the same order.

(define (mupllist->racketlist p)
  (cond [(aunit? p) null]; unit value so produce empty list
        [(apair? p) (cons (apair-e1 p) ;make list by consing first part of apair with recursive call on second part of apair
                          (mupllist->racketlist (apair-e2 p)))]
        [#t (error "mupllist->racketlist expected mupl list")]))

;; Problem 2 Implementing the mupl Language
;Write a mupl interpreter, i.e., a Racket function eval-exp
;that takes a mupl expression e and either returns the mupl value that e evaluates to under the empty
;environment or calls Racket's error if evaluation encounters a run-time mupl type error or unbound
;mupl variable.
;A mupl expression is evaluated under an environment (for evaluating variables, as usual). In your
;interpreter, use a Racket list of Racket pairs to represent this environment (which is initially empty)
;so that you can use without modi cation the provided envlookup function. Here is a description of
;the semantics of mupl expressions:
;  - All values (including closures) evaluate to themselves. For example, (eval-exp (int 17)) would
;return (int 17), not 17.
;  - A variable evaluates to the value associated with it in the environment.
;  - An addition evaluates its subexpressions and assuming they both produce integers, produces the
;integer that is their sum. (Note this case is done for you to get you pointed in the right direction.)
;  - Functions are lexically scoped: A function evaluates to a closure holding the function and the
;current environment.
;  - An ifgreater evaluates its  rst two subexpressions to values v1 and v2 respectively. If both
;values are integers, it evaluates its third subexpression if v1 is a strictly greater integer than v2
;else it evaluates its fourth subexpression.
;  - An mlet expression evaluates its first expression to a value v. Then it evaluates the second
;expression to a value, in an environment extended to map the name in the mlet expression to v.
;  - A call evaluates its first and second subexpressions to values. If the first is not a closure, it is an
;error. Else, it evaluates the closure's function's body in the closure's environment extended to map
;the function's name to the closure (unless the name field is #f) and the function's argument-name
;(i.e., the parameter name) to the result of the second subexpression.
;  - A pair expression evaluates its two subexpressions and produces a (new) pair holding the results.
;  - A fst expression evaluates its subexpression. If the result for the subexpression is a pair, then the
;result for the fst expression is the e1  eld in the pair.
;  - A snd expression evaluates its subexpression. If the result for the subexpression is a pair, then
;the result for the snd expression is the e2  eld in the pair.
;  - An isaunit expression evaluates its subexpression. If the result is an aunit expression, then the
;result for the isaunit expression is the mupl value (int 1), else the result is the mupl value
;(int 0).
;Hint: The call case is the most complicated. In the sample solution, no case is more than 12 lines
;and several are 1 line.

;; lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond [(null? env) (error "unbound variable during evaluation" str)]
        [(equal? (car (car env)) str) (cdr (car env))]
        [#t (envlookup (cdr env) str)]))

;; Do NOT change the two cases given to you.  
;; DO add more cases for other kinds of MUPL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp.
(define (eval-under-env e env)
  (cond [(var? e) 
         (envlookup env (var-string e))];a variable evaluates to the value associated with it in the environment
        
        [(int? e) e];int value evaluates to itself
        
        ;An addition evaluates its subexpressions and assuming they both produce integers,
        ;produces the integer that is their sum.
        [(add? e) 
         (let ([v1 (eval-under-env (add-e1 e) env)]
               [v2 (eval-under-env (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        
        ;Functions are lexically scoped: A function evaluates to a closure holding the function
        ;and the current environment.
        [(fun? e) (closure env e)]
        [(closure? e) e];produce closure value

        ;ifgreater evaluates its first two subexpressions to values v1 and v2 respectively.
        ;If both values are integers, it evaluates its third subexpression if v1 is a strictly greater integer than v2
        ;else it evaluates its fourth subexpression.
        [(ifgreater? e) 
         (let ([v1 (eval-under-env (ifgreater-e1 e) env)]
               [v2 (eval-under-env (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env (ifgreater-e3 e) env)
                   (eval-under-env (ifgreater-e4 e) env))
               (error "MUPL ifgreater needs integer expressions as first 2 subexpressions")))]

        ;An mlet expression evaluates its second expression to a value v.
        ;Then it evaluates the third expression to a value, in an environment extended to map the name in the mlet expression to v.
        ;
        ;mlet (var e body)
        [(mlet? e) 
         (let ([s (mlet-var e)]);evaluate first subexpresion in current env
           (if (string? s);check it's a string (variable name)
               (let ([v (eval-under-env (mlet-e e) env)]);if so evaluate 2nd subexpression and bind it to local variable
                 (eval-under-env (mlet-body e)
                                 (cons (cons s v) env))); evaluate body in extended environment   
               (error "MUPL mlet needs string as first subexpression")))]

        ;A call evaluates its first and second subexpressions to values.
        ;If the first is not a closure, it is an error.
        ;Else, it evaluates the closure's function's body in the closure's environment
        ;extended to map the function's name to the closure (unless the name field is #f) and the function's argument-name
        ;(i.e., the parameter name) to the result of the second subexpression.
        ;
        ;(closure env fun)
        ;(fun nameopt formal body) 
        ;(call funexp actual)
        [(call? e)
         (let ([c (eval-under-env (call-funexp e) env)])
           (if (closure? c)
               (let* ([arg-val (eval-under-env (call-actual e) env)];evaluate 2nd expression in current env
                      [f (closure-fun c)];get function with closure-fun
                      [f-name (fun-nameopt f)];get fun fields contents
                      [f-argname (fun-formal f)]
                      [f-body (fun-body f)]
                      [c-env (closure-env c)];get initial closure env
                      [prel-env (cons (cons f-argname arg-val) c-env)];prepare preliminary env
                      [new-env (if f-name;make new environment for evaluating function body with optionally function name
                                   (cons (cons f-name c) prel-env)
                                   prel-env)])
                 (eval-under-env f-body new-env))
               (error "MUPL call needs closure expression as first subexpression")))]

        ; A pair expression evaluates its two subexpressions and produces a (new) pair holding the results.
        [(apair? e) 
         (let ([v1 (eval-under-env (apair-e1 e) env)]
               [v2 (eval-under-env (apair-e2 e) env)])
           (apair v1 v2))]

        ;A fst expression evaluates its subexpression.
        ;If the result for the subexpression is a pair, then the result for the fst expression is the e1 field in the pair.
        [(fst? e) 
         (let ([p (eval-under-env (fst-e e) env)])
           (if (apair? p);check result of evaluating subexpression is apair
               (apair-e1 p)
               (error "fst expected apair type")))]

        ;A snd expression evaluates its subexpression.
        ;If the result for the subexpression is a pair, then the result for the snd expression is the e2 field in the pair.
        [(snd? e) 
         (let ([p (eval-under-env (snd-e e) env)])
           (if (apair? p);check result of evaluating subexpression is apair
               (apair-e2 p)
               (error "snd expected apair type")))]

        [(aunit? e) e] ;produce unit value
        
        ;An isaunit expression evaluates its subexpression.
        ;If the result is an aunit expression, then the result for the isaunit expression is the mupl value (int 1),
        ;else the result is the mupl value (int 0).        
        [(isaunit? e)
         (let ([v (eval-under-env (isaunit-e e) env)])
           (if (aunit? v);check result of evaluating subexpression is aunit value
               (int 1)
               (int 0)))]

        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change
(define (eval-exp e)
  (eval-under-env e null))
        
;; Problem 3 Expanding the Language
;mupl is a small language, but we can write Racket functions that act like
;mupl macros so that users of these functions feel like mupl is larger. The Racket functions produce
;mupl expressions that could then be put inside larger mupl expressions or passed to eval-exp. In
;implementing these Racket functions, do not use closure (which is used only internally in eval-exp).
;Also do not use eval-exp (we are creating a program, not running it).

;(a) Write a Racket function ifaunit that takes three mupl expressions e1, e2, and e3.
;It returns a mupl expression that when run evaluates e1 and if the result is mupl's aunit then it evaluates e2
;and that is the overall result, else it evaluates e3 and that is the overall result.
;Sample solution: 1 line.

(define (ifaunit e1 e2 e3)
  (ifgreater (isaunit e1) (int 0) e2 e3));(isaunit e1) evaluated will produce (int 1) if e1 is aunit, otherwise (int 0)

;(b) Write a Racket function mlet* that takes a Racket list of Racket pairs '((s1 . e1) . . . (si . ei)
;. . . (sn . en)) and a  final mupl expression en+1. In each pair, assume si is a Racket string and
;ei is a mupl expression. mlet* returns a mupl expression whose value is en+1 evaluated in an
;environment where each si is a variable bound to the result of evaluating the corresponding ei
;for 1 <= i <=  n. The bindings are done sequentially, so that each ei is evaluated in an environment
;where s1 through si-1 have been previously bound to the values e1 through ei-1.
;
;(mlet var e body)

(define (mlet* lstlst e2)
  (if (null? lstlst)
      e2
      (let* ([p (car lstlst)];get first pair in list and its parts (variable name var and expression e)
             [var (car p)]
             [e (cdr p)])
        ;produce mlet expression with var bound to e and body recursive call to mlet* with cdr of list and e2
        (mlet var e (mlet* (cdr lstlst) e2)))))

;(c) Write a Racket function ifeq that takes four mupl expressions e1, e2, e3, and e4 and
;returns a mupl expression that acts like ifgreater except e3 is evaluated if and only if e1 and e2 are equal integers.
;Assume none of the arguments to ifeq use the mupl variables _x or _y.
;Use this assumption so that when an expression returned from ifeq is evaluated, e1 and e2 are evaluated exactly once each.

(define (ifeq e1 e2 e3 e4)
  (mlet* (list (cons "_x" e1) (cons "_y" e2)) ;produce mlet expression with _x and _y in env bound to e1 and e2
         (ifgreater (var "_x") (var "_y") e4 ;evaluate body of mlet with nested ifgreater expressions: if e1>e2 produce e4 (not equal)
                    (ifgreater (var "_y") (var "_x") e4 e3))));else check if e2>e1 and if so produce again e4 (still not equal) else e3 (finally equal)

;; Problem 4 Using the Language
;We can write mupl expressions directly in Racket using the constructors for
;the structs and (for convenience) the functions we wrote in the previous problem.

;(a) Bind to the Racket variable mupl-map a mupl function that acts like map (as we used extensively in ML).
;Your function should be curried: it should take a mupl function and return a mupl function
;that takes a mupl list and applies the function to every element of the list returning a new mupl list.
;Recall a mupl list is aunit or a pair where the second component is a mupl list.
;(fun nameopt formal body)
(define mupl-map
  (fun "mupl-map" "f" ;produce function called mupl-map which takes a function f and
       (fun #f "es" ;produces an anonymous function which takes a mupl list es 
            (ifaunit (var "es") ;that checks if list bound to es in env is aunit (empty)
                     (aunit) ;if so produces aunit
                     ;else produces a pair with 1st part: result of calling function bound to f on the first of es = (f (car lst))
                     (apair (call (var "f") (fst (var "es")))
                            ;and 2nd part: result of calling recursively mupl-map with f and this result with rest of es = ((map f) (cdr es))
                            (call (call (var "mupl-map") (var "f")) (snd (var "es"))))))))


;(b) Bind to the Racket variable mupl-mapAddN a mupl function that takes an mupl integer i and
;returns a mupl function that takes a mupl list of mupl integers and returns a new mupl list of
;mupl integers that adds i to every element of the list.
;Use mupl-map (a use of mlet is given to you to make this easier).
;notice map is now in MUPL scope

(define mupl-mapAddN 
  (mlet "map" mupl-map
        (fun #f "i" ;produce function that takes param i and
             (fun #f "es";produces function that takes mupl list es
                  ;and in its body calls curried function map with new function (adding i to its param x) and list es
                  (call (call (var "map") (fun #f "x" (add (var "x") (var "i")))) (var "es"))))))


;; Challenge Problem 5
; Write a second version of eval-exp (bound to eval-exp-c) that builds closures
;with smaller environments: When building a closure, it uses an environment that is like the current
;environment but holds only variables that are free variables in the function part of the closure.
;(A free variable is a variable that appears in the function without being under some shadowing binding for the
;same variable.)
;Avoid computing a function's free variables more than once. Do this by writing a function compute-free-vars
;that takes an expression and returns a different expression that uses fun-challenge everywhere in
;place of fun.
;The new struct fun-challenge (provided to you; do not change it) has a field freevars
;to store exactly the set of free variables for the function. Store this set as a Racket set of Racket strings.
;(Sets are predefined in Racket's standard library; consult the documentation for useful functions such
;as set, set-add, set-member?, set-remove, set-union, and any other functions you wish.)
;You must have a top-level function compute-free-vars that works as just described - storing the
;free variables of each function in the freevars field - so the grader can test it directly.
;Then write a new "main part" of the interpreter that expects the sort of mupl expression that compute-free-vars
;returns. The case for function definitions is the interesting one.

(struct fun-challenge (nameopt formal body freevars) #:transparent) ;; a recursive(?) 1-argument function

;; We will test this function directly, so it must do
;; as described in the assignment
(define (compute-free-vars e)
  ;helper function f takes an expression and produces set of free variables inside
  (letrec ([f (lambda (e)
                (cond [(fun? e)
                       (let* ([excl (fun-formal e)]
                              [fun-name (fun-nameopt e)]
                              [s (f (fun-body e))] ;set from function body
                              [prel-s (set-remove s excl)]);preliminary set excluding function param
                         (if fun-name
                             (set-remove prel-s fun-name)
                             prel-s))];exclude function param (and optionally function name) from set obtained by recursively calling f on function body
                      [(var? e) (set (var-string e))];produce set with 1 element
                      [(add? e) (set-union (f (add-e1 e)) (f (add-e2 e)))];union of sets from subexpressions
                      [(ifgreater? e) (set-union (f (ifgreater-e1 e));union of sets from subexpressions
                                                 (f (ifgreater-e2 e))
                                                 (f (ifgreater-e3 e))
                                                 (f (ifgreater-e4 e)))]
                      [(call? e) (set-union (f (call-funexp e)) (f (call-actual e)))];union of sets from subexpressions
                      [(mlet? e)  (let ([excl (mlet-var e)]
                                        [sbody (f (mlet-body e))];set obtained by recursively calling f on body
                                        [se (f (mlet-e e))]);set obtained by recursively calling f on value of local binding
                                    (set-union se (set-remove sbody excl)))];union se with sbody (excluding local var from it)
                      [(apair? e) (set-union (f (apair-e1 e)) (f (apair-e2 e)))];union of sets from subexpressions
                      [(fst? e) (f (fst-e e))];keep checking subexpression
                      [(snd? e) (f (snd-e e))];keep checking subexpression
                      [(isaunit? e) (f (isaunit-e e))];keep checking subexpression
                      [(closure? e) (f (closure-fun e))];keep checking subexpression
                      [#t (set)];empty set for int, aunit cases
                      ))])
    ;fun case
    (cond [(fun? e) (let ([excl (fun-formal e)]
                          [s (f (fun-body e))])
                      (fun-challenge (fun-nameopt e);make new fun-challenge with same first 2 subexpressions
                                     excl
                                     (compute-free-vars (fun-body e));recursively check if other fun inside function body
                                     (set-remove s excl)))];exclude function param from set obtained by recursively calling f on function body
          ;rest of cases recursively check subexpressions for fun to fun-challenge substitutions
          [(add? e) (add
                     (compute-free-vars (add-e1 e))
                     (compute-free-vars (add-e2 e)))]
          [(ifgreater? e) (ifgreater (compute-free-vars (ifgreater-e1 e))
                                     (compute-free-vars (ifgreater-e2 e))
                                     (compute-free-vars (ifgreater-e3 e))
                                     (compute-free-vars (ifgreater-e4 e)))]
          [(call? e) (call (compute-free-vars (call-funexp e))
                           (compute-free-vars (call-actual e)))]
          [(mlet? e) (mlet (mlet-var e)
                           (compute-free-vars (mlet-e e))
                           (compute-free-vars (mlet-body e)))]
          [(apair? e) (apair (compute-free-vars (apair-e1 e))
                             (compute-free-vars (apair-e2 e)))]
          [(fst? e) (fst (compute-free-vars (fst-e e)))]
          [(snd? e) (snd (compute-free-vars (snd-e e)))]
          [(snd? e) (snd (compute-free-vars (snd-e e)))]
          [(isaunit? e) (isaunit (compute-free-vars (isaunit-e e)))]
          [(closure? e) (closure (closure-env e)
                                 (compute-free-vars (closure-fun e)))]
          [#t e] ;case for var, int, aunit produce same expressions
          )))


;; Do NOT share code with eval-under-env because that will make
;; auto-grading and peer assessment more difficult, so
;; copy most of your interpreter here and make minor changes
(define (eval-under-env-c e env)
  ;fun-challenge case is major difference from eval-under-env
  (cond [(fun-challenge? e)
         (letrec ([s (fun-challenge-freevars e)];set of free variables 
                  [make-env (lambda (s) ;helper function with takes a set of strings and produces new smaller environment
                              (if (set-empty? s);if empty set produce empty list
                                  null
                                  (let* ([str (set-first s)];else get first element from set
                                         [p (assoc str env)]);get pair for this free variable from current env
                                    (cons p (make-env (set-remove s str))))))]);create new env list p onto with recursive call on smaller set
           (closure (make-env (fun-challenge-freevars e)) e))];create closure with just enough env

        ;call case: change from fun to fun-challenge for accessing fields of fun-challenge inside closure being called
        [(call? e)
         (let ([c (eval-under-env-c (call-funexp e) env)])
           (if (closure? c)
               (let* ([arg-val (eval-under-env-c (call-actual e) env)]
                      [f (closure-fun c)]
                      [f-name (fun-challenge-nameopt f)]
                      [f-argname (fun-challenge-formal f)]
                      [f-body (fun-challenge-body f)]
                      [c-env (closure-env c)]
                      [prel-env (cons (cons f-argname arg-val) c-env)]
                      [new-env (if f-name
                                   (cons (cons f-name c) prel-env)
                                   prel-env)])
                 (eval-under-env-c f-body new-env))
               (error "MUPL call needs closure expression as first subexpression")))]
        
        ;in rest of cases we replace recursive call of eval-under-env to eval-under-env-c
        [(var? e) 
         (envlookup env (var-string e))]  
        [(int? e) e]
        [(add? e) 
         (let ([v1 (eval-under-env-c (add-e1 e) env)]
               [v2 (eval-under-env-c (add-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (int (+ (int-num v1) 
                       (int-num v2)))
               (error "MUPL addition applied to non-number")))]
        [(closure? e) e]
        [(ifgreater? e) 
         (let ([v1 (eval-under-env-c (ifgreater-e1 e) env)]
               [v2 (eval-under-env-c (ifgreater-e2 e) env)])
           (if (and (int? v1)
                    (int? v2))
               (if (> (int-num v1) (int-num v2))
                   (eval-under-env-c (ifgreater-e3 e) env)
                   (eval-under-env-c (ifgreater-e4 e) env))
               (error "MUPL ifgreater needs integer expressions as first 2 subexpressions")))]
        [(mlet? e) 
         (let ([s (mlet-var e)])
           (if (string? s)
               (let ([v (eval-under-env-c (mlet-e e) env)])
                 (eval-under-env-c (mlet-body e)
                                 (cons (cons s v) env)))
               (error "MUPL mlet needs string as first subexpression")))]
        [(apair? e) 
         (let ([v1 (eval-under-env-c (apair-e1 e) env)]
               [v2 (eval-under-env-c (apair-e2 e) env)])
           (apair v1 v2))]
        [(fst? e) 
         (let ([p (eval-under-env-c (fst-e e) env)])
           (if (apair? p)
               (apair-e1 p)
               (error "fst expected apair type")))]
        [(snd? e) 
         (let ([p (eval-under-env-c (snd-e e) env)])
           (if (apair? p)
               (apair-e2 p)
               (error "snd expected apair type")))]
        [(aunit? e) e]
        [(isaunit? e)
         (let ([v (eval-under-env-c (isaunit-e e) env)])
           (if (aunit? v)
               (int 1)
               (int 0)))]
        [#t (error (format "bad MUPL expression: ~v" e))]))

;; Do NOT change this
(define (eval-exp-c e)
  (eval-under-env-c (compute-free-vars e) null))
