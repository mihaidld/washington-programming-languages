#lang racket

;it takes a stream and returns a stream that is like the stream it takes except all #f elements are removed
(define (mystery s)
  (lambda ()
    (let ([pr (s)])
      (if (car pr)
          (cons (car pr) (mystery (cdr pr)))
          ((mystery (cdr pr)))))))

(define nats
  (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))])
    (lambda () (f 1))))

(define nats1
  (letrec ([f (lambda (x) (if (odd? x)
                              (cons x (lambda () (f (+ x 1))))
                              (cons #f (lambda () (f 1)))))])
    (lambda () (f 1))))