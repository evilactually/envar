(include "grammar.scm")
(include "utils.scm")
(include "data.scm")

(use irregex srfi-1)

;; @descr: remove all commented out text from a string
(define (strip-comments str)
  (irregex-replace/all 
    comment-igx
    str
    ""))

;; @descr: returns a list of unrecognized strings
(define (invalid-tokens str)
  (filter 
    not-whitespace?
    (irregex-split full-igx (strip-comments str))))

;; @descr: renders statement into a script string
(define (statement->script statement) 
  (~ (if (equal? (op-arg statement `scope) `system)
         "@"
         "")
     (op-arg statement `name)
     
     (cond ((op-assign? statement)
            (~
              " : "
              "[" (op-arg statement `value) "]"))
           ((op-create? statement)
            " + ")
           ((op-remove? statement)
            " - "))))

;; @descr: parses a string into a list of statements
(define (parse-statements str)
  (map                                         ; map each statement              
    (lambda (statement-match)
      ; helper
      (define (value-of submatch-name)
        (submatch-named statement-match submatch-name))
      
      ; body
      (define scope (if (equal? (value-of `scope) "@")
                        `system
                        `user))
      (define name (value-of `name))
            
      (if (equal? (value-of `op) ":")          ; operator :
          (make-op/assign scope         ; scope
                          name          ; name
                          (string-merge ; value
                            (map ; map each value in brackets
                              (lambda (value-match)
                                (submatch-named value-match `value))
                              (irregex-search/all-matches
                                value-igx
                                (submatch-named statement-match `values)))))
          ((if (equal? (value-of `op) "+")     ; + or - operator
               make-op/create
               make-op/remove) scope name)))
    (irregex-search/all-matches full-igx (strip-comments str))))
