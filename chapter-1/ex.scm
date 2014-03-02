;;;
;;;  Chapter 1 Exercises
;;;

;;; 1.1 - Interpreter responses

10
; => 10

(+ 5 3 4)
; => 12

(- 9 1)
; => 8

(/ 6 2)
; => 3

(+ (* 2 4) (- 4 6))
; => 6

(define a 3)
;nothing

(define b (+ a 1))
;nothing

(+ a b (* a b))
; 19

(= a b)
; => #f

(if (and (> b a) (< b (* a b)))
  b
  a)
; => 4

(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25))
; => 16

(+ 2 (if (> b a) b a))
; => 6

(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1))
; => 16


;;; 1.2 - Translating into prefix form

(/
  (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 3)))))
  (* 3 (- 6 2) (- 2 7)))

;;; Exercise 1.3.  Define a procedure that takes three numbers as
;;; arguments and returns the sum of the squares of the two larger
;;; numbers.

; define helpers first
(define (the-bigger a b) 
  (if (> a b) a b))

(define (square x) (* x x))

(define (sum-of-squares a b) (+ (square a) (square b)))

; define the actual thing
(define (sum-of-squares-largest a b c)
  (let ((ab (the-bigger a b)) (bc (the-bigger b c)) (ac (the-bigger a c)))
    (if (= ab ac)
      (sum-of-squares ab bc)
      (sum-of-squares ab ac))))

;;; Exercise 1.4.  Observe that our model of evaluation allows for
;;; combinations whose operators are compound expressions. Use this
;;; observation to describe the behavior of the following procedure:

(define (a-plus-abs-b a b)
    ((if (> b 0) + -) a b))

; Because the operator is a compound expression, it will evaluate
; to either the + operator or the - operator.  Although the absolute
; value of b isn't actually calculated, the effect is the same because
; when b is negative it will be subtracted from a (and the two 
; negatives will cancel).

;;; Exercise 1.5.  Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:

(define (p) (p))

(define (test x y)
    (if (= x 0)
            0
                  y))

;;; Then he evaluates the expression

(test 0 (p))

;;; What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

; In applicative order, the interpreter will fall into a recursive spiral,
; calling p over and over again to evaluate itself.  In normal order,
; that will only be evaluated if that branch of the conditional is called,
; which is not the case in the example.

; The applicative order substitution would look like:
(test 0 (p))
(test 0 (p))
(test 0 (p))
(test 0 (p))
;... (p) keeps getting substituted for p)


; The normal order substitution would look like:
(test 0 (p))

(if (= 0 0)
  0
  (p))

0

; In applicative order, operators and operands are evaluated, whereas
; in normal order, only operators are evaluated until the problem 
; consists of just primitive operators, then the operands are evaluated
; as they're needed.


;;; Exercise 1.6.  Alyssa P. Hacker doesn't see why if needs to be provided as a special form. ``Why can't I just define it as an ordinary procedure in terms of cond?'' she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of if:

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

; Eva demonstrates the program for Alyssa:

(new-if (= 2 3) 0 5)
5

(new-if (= 1 1) 0 5)
0

; Delighted, Alyssa uses new-if to rewrite the square-root program:

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

; What happens when Alyssa attempts to use this to compute square roots? Explain.

; This won't work because lisp is evaluated in applicative order.
; sqrt-iter calls itself, and if it's used as an operand to new-if
; the operand will be evaluated and the loop will never terminate.

;;; Exercise 1.7.  The good-enough? test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with examples showing how the test fails for small and large numbers. An alternative strategy for implementing good-enough? is to watch how guess changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers?

; For small numbers, the closer that `x` gets to the predetermined 
; tolerance number, the less the sqrt-iter will work.  Consider:

(sqrt-iter .001 .001)

; With the current implementation of `good-enough?`, the answer will
; immediately return as .001, which is incorrect.
;
; Large numbers?

;;; A new implementation:

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (square x) (* x x))

(define (good-enough? new-guess old-guess)
  (< (abs (/ (- new-guess old-guess) old-guess) 0.000001))

(define (sqrt-iter new-guess old-guess x)
  (if (good-enough? new-guess old-guess)
    new-guess
    (sqrt-iter 
      (improve new-guess x)
      new-guess
      x)))

; This does not appear to work any better.  For small numbers,
; it even seems to be worse.

;;; Exercise 1.8 - A cube root procedure based on the square root
;;; procedure we already have

(define (improve guess x)
  (/ (+ (/ x (square guess)) (* 2 guess)) 3))

(define (square x) (* x x))
(define (cube x) (* x (square x)))

(define (good-enough? guess x)
  (< (abs (- (cube guess) x)) 0.001))

(define (cbrt-iter guess x)
  (if (good-enough? guess x)
    guess
    (sqrt-iter (improve guess x)
               x)))
