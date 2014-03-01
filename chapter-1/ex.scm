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

