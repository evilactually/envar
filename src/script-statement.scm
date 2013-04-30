;; @file: representation of script statement

(use defstruct srfi-69)

;; @descr: general reresentation of a statement
(defstruct statement op args)

;; @descr: create an assign statement
(define (make-op/assign scope name value)
  (define args-hash (make-hash-table))
  (hash-table-set! args-hash `scope scope)
  (hash-table-set! args-hash `name name)
  (hash-table-set! args-hash `values value)
  (make-statement op: `assign
                  args: args-hash))

;; @descr: check if statement is an assignment op
(define (op-assign? statement)
  (equal? (statement-op statement) `assign))

;; @descr: create an assign statement
(define (make-op/create scope name)
  (define args-hash (make-hash-table))
  (hash-table-set! args-hash `scope scope)
  (hash-table-set! args-hash `name name)
  (make-statement op: `create
                  args: args-hash))

;; @descr: check if statement is a creation op
(define (op-create? statement)
  (equal? (statement-op statement) `create))

;; @descr: create an assign statement
(define (make-op/remove scope name)
  (define args-hash (make-hash-table))
  (hash-table-set! args-hash `scope scope)
  (hash-table-set! args-hash `name name)
  (make-statement op: `remove
                  args: args-hash))

;; @descr: check if statement is a removal op
(define (op-remove? statement)
  (equal? (statement-op statement) `remove))

;; @descr: get statement argument
(define (op-arg statement field)
  (hash-table-ref (statement-args statement) field))
