
(use defstruct srfi-69)

;; @file: various data structure definitions

;; @descr: data structure holding information of a environment variable
(defstruct variable scope name value)

;; @descr: general reresentation of a script statement
(defstruct statement op args)

;; @descr: create an assign statement
(define (make-op/assign scope name value)
  (define args-hash (make-hash-table))
  (hash-table-set! args-hash `scope scope)
  (hash-table-set! args-hash `name name)
  (hash-table-set! args-hash `value value)
  (make-statement op: `assign 
                  args: args-hash))

(defstruct statement-assign scope name value)
(defstruct statement-create scope name)
(defstruct statement-remove scope name)