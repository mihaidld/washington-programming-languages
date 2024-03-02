
#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;1. Write a function sequence that takes 3 arguments low, high, and stride, all assumed to be numbers.
;Further assume stride is positive. sequence produces a list of numbers from low to high (including
;low and possibly high) separated by stride and in sorted order. Sample solution: 4 lines. Examples:
;0 1 2
;3 4 5

; Produces a list of numbers from low to high (including low and possibly high)
; separated by stride and in sorted order.
; Assume low, high, stride are numbers with stride positive
(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))


;2. Write a function string-append-map that takes a list of strings xs and a string suffix and returns a
;list of strings. Each element of the output should be the corresponding element of the input appended
;with suffix (with no extra space between the element and suffix). You must use Racket-library
;functions map and string-append. Sample solution: 2 lines.

(define (string-append-map xs suffix)
  (map (lambda (s) (string-append s suffix)) xs))


;3. Write a function list-nth-mod that takes a list xs and a number n. If the number is negative,
;terminate the computation with (error "list-nth-mod: negative number"). Else if the list is
;empty, terminate the computation with (error "list-nth-mod: empty list"). Else return the ith
;element of the list where we count from zero and i is the remainder produced when dividing n by the
;list's length. Library functions length, remainder, car, and list-tail are all useful { see the Racket
;documentation. Sample solution is 6 lines.

(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (let ([i (remainder n (length xs))])
              (car (list-tail xs i)))]))


;4. Write a function stream-for-n-steps that takes a stream s and a number n. It returns a list holding
;the first n values produced by s in order. Assume n is non-negative. Sample solution: 5 lines.
;Note: You can test your streams with this function instead of the graphics code.

(define (stream-for-n-steps s n)
  (if (= n 0)
      null
      (let ([p (s)])
        (cons (car p) (stream-for-n-steps (cdr p) (- n 1))))))


;5. Write a stream funny-number-stream that is like the stream of natural numbers (i.e., 1, 2, 3, ...)
;except numbers divisible by 5 are negated (i.e., 1, 2, 3, 4, -5, 6, 7, 8, 9, -10, 11, ...).
;Remember a stream is a thunk that when called produces a pair.
;Here the car of the pair will be a number and the cdr will be another stream.

(define funny-number-stream
  (letrec ([loop (lambda (x)                                ;use helper function to keep track of current x
                   (cons (* (if (= (modulo x 5) 0) -1 1) x) ;get sign of current x based on x mod 5
                         (lambda () (loop (+ x 1)))))])
    (lambda () (loop 1))))                                  ;trampoline with first element of sequence 1


;6. Write a stream dan-then-dog, where the elements of the stream alternate between the strings "dan.jpg"
;and "dog.jpg" (starting with "dan.jpg"). More specifically, dan-then-dog should be a thunk that
;when called produces a pair of "dan.jpg" and a thunk that when called produces a pair of "dog.jpg"
;and a thunk that when called... etc. Sample solution: 4 lines.

(define dan-then-dog
  (letrec ([loop (lambda (s)                                        ;use helper function to keep track of current string s
                   (cons s (lambda () (loop (if (string=? s "dan.jpg") "dog.jpg" "dan.jpg")))))]);toggle string in next stream
    (lambda () (loop "dan.jpg"))))                                  ;trampoline with first element of sequence "dan.jpg"


;7. Write a function stream-add-zero that takes a stream s and returns another stream. If s would
;produce v for its ith element, then (stream-add-zero s) would produce the pair (0 . v) for its
;ith element. Sample solution: 4 lines.
;Hint: Use a thunk that when called uses s and recursion.
;Note: One of the provided tests in the file using graphics uses (stream-add-zero dan-then-dog)
;with place-repeatedly.

(define (stream-add-zero s)
  (lambda () (let ([p (s)])                       ;store result of calling thunk s into pair p
               (cons (cons 0 (car p))
                     (stream-add-zero (cdr p))))))


;8. Write a function cycle-lists that takes two lists xs and ys and returns a stream.
;The lists may or may not be the same length, but assume they are both non-empty.
;The elements produced by the stream are pairs where the first part is from xs and the second part is from ys.
;The stream cycles forever through the lists.
;For example, if xs is '(1 2 3) and ys is '("a" "b"), then the stream would produce, (1 . "a"), (2 . "b"),
;(3 . "a"), (1 . "b"), (2 . "a"), (3 . "b"), (1 . "a"), (2 . "b"), etc.
;Sample solution is 6 lines and is more complicated than the previous stream problems. Hints: Use one
;of the functions you wrote earlier. Use a recursive helper function that takes a number n and calls
;itself with (+ n 1) inside a thunk.

(define (cycle-lists xs ys)
  (letrec ([loop (lambda (n)
                   (cons (cons (list-nth-mod xs n)
                               (list-nth-mod ys n))
                         (lambda () (loop (+ n 1)))))])
    (lambda () (loop 0))))


;9. Write a function vector-assoc that takes a value v and a vector vec. It should behave like Racket's
;assoc library function except
;(1) it processes a vector (Racket's name for an array) instead of a list,
;(2) it allows vector elements not to be pairs in which case it skips them, and
;(3) it always takes exactly two arguments.
;Process the vector elements in order starting from 0.
;You must use library functions vector-length, vector-ref, and equal?.
;Return #f if no vector element is a pair with a car field equal to v,
;else return the first pair with an equal car field.
;Sample solution is 9 lines, using one local recursive helper function.

; Built-ins used:
; (vector-length vec) → number
; Returns the length of vec (i.e., the number of slots in the vector).
; (vector-ref vec pos) → any/c
; Returns the element in slot pos of vec. The first slot is position 0,
; and the last slot is one less than (vector-length vec).

(define (vector-assoc v vec)
  (let ([l (vector-length vec)])                                          ;store vector length to know when to stop iterating
    (letrec ([loop (lambda (pos)
                     (if (>= pos l)
                         #f                                               ;reached end of vector
                         (let ([el (vector-ref vec pos)])                 ;store current element in local variable el 
                           (cond [(and (pair? el) (equal? v (car el))) el];check el is pair and its car is v, if so produce it
                                 [#t (loop (+ pos 1))]))))])              ;else skip and keep looping      
      (loop 0))))                                                         ;trampoline with position pos initialized at 0

;10. Write a function cached-assoc that takes a list xs and a number n and returns a function that takes
;one argument v and returns the same thing that (assoc v xs) would return.
;However, you should use an n-element cache of recent results to possibly make this function faster
;than just calling assoc (if xs is long and a few elements are returned often).
;The cache must be a Racket vector of length n that is created by the call to cached-assoc
;(use Racket library function vector or make-vector) and used-and-possibly-mutated each time the function
;returned by cached-assoc is called.
;Assume n is positive.
;The cache starts empty (all elements #f). When the function returned by cached-assoc is called, it
;first checks the cache for the answer. If it is not there, it uses assoc and xs to get the answer and if
;the result is not #f (i.e., xs has a pair that matches), it adds the pair to the cache before returning
;(using vector-set!). The cache slots are used in a round-robin fashion: the first time a pair is added
;to the cache it is put in position 0, the next pair is put in position 1, etc. up to position n-1 and
;then back to position 0 (replacing the pair already there), then position 1, etc.
;Hints:
;- In addition to a variable for holding the vector whose contents you mutate with vector-set!,
;use a second variable to keep track of which cache slot will be replaced next. After modifying the
;cache, increment this variable (with set!) or set it back to 0.
;- To test your cache, it can be useful to add print expressions so you know when you are using the
;cache and when you are not. But remove these print expressions before submitting your code.
;Sample solution is 15 lines.

; Built-ins used:
;(make-vector size [v]) → vector?
; Returns a mutable vector with size slots, where all slots are initialized to contain v. 
; e.g.(make-vector 3 2) ; #(2 2 2)
;(vector-set! vec pos v) → void?
; Updates the slot pos of vec to contain v.

;(listof pair) number -> (v -> (pair or #f))
(define (cached-assoc xs n)
 (letrec ([memo (make-vector n #f)]                                                 ;cache starts empty (all elements #f)
          [slot 0]                                                                  ;keep track of which cache slot will be replaced next
          [max-slot (- n 1)]                                                        ;max value foir slots (n-1)
          [loop (lambda (v)
                  (let ([p-memo (vector-assoc v memo)])                             ;first search cache for the pair answer and store answer
                    (if p-memo
                        p-memo                                                      ;test cache with (begin (print "from cache") p-memo)
                        (let ([p-list (assoc v xs)])                                ;then use assoc to search in list and store answer
                          (if p-list
                              (begin (vector-set! memo slot p-list)                 ;if found, save p-list in cache at position slot
                                     (set! slot (if (< slot max-slot) (+ slot 1) 0));increment slot or reset it to 0 if already is max-slot
                                     p-list)                                        ;test cache with (begin (print memo) (print "from assoc") p-list))
                              #f)))))])
   loop))


;11. (Challenge Problem:) Define a macro that is used like (while-less e1 do e2) where e1 and e2
;are expressions and while-less and do are syntax (keywords). The macro should do the following:
;- It evaluates e1 exactly once.
;- It evaluates e2 at least once.
;- It keeps evaluating e2 until and only until the result is not a number less than the result of the
;evaluation of e1.
;- Assuming evaluation terminates, the result is #t.
;- Assume e1 and e2 produce numbers; your macro can do anything or fail mysteriously otherwise.
;Hint: Define and use a recursive thunk. Sample solution is 9 lines.
;Example:
;(define a 2)
;(while-less 7 do (begin (set! a (+ a 1)) (print "x") a))
;(while-less 7 do (begin (set! a (+ a 1)) (print "x") a))
;Evaluating the second line will print "x" 5 times and change a to be 7. So evaluating the third line
;will print "x" 1 time and change a to be 8.

(define-syntax while-less
  (syntax-rules (do)
    [(while-less e1 do e2)
     (letrec ([min-val e1]         ;evaluates e1 exactly once and store result in min-val
              [loop (lambda ()     ;thunk which evaluates e2 each time it's called and checks if current reached min-val
                      (let ([current e2])
                        (if (< current min-val)
                            (loop) ;keep looping
                            #t)))])
       (loop))]))                  ;trampoline calls thunk