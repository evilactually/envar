
;; @file: Various helper functions

(use irregex)

(define else #t)

;; @descr: test if each element of members is contained in a given list
(define (member-each? members in)
(cond 
  ((equal? members `()) #t)
  ((not (member (car members) in)) #f)
  (else (member-each? (cdr members) in))))

(define (string-merge/deliminated strings deliminator)
  (let next ((xs strings))
    (cond 
      ((equal? xs `()) "")
      (else 
        (string-append 
          (car xs) 
          (if (equal? (cdr xs) `())
            ""
            deliminator)
          (next (cdr xs)))))))

(define (string-merge strings)
  (string-merge/deliminated strings ""))
  

(define (not-whitespace? str)
  (not (irregex-match-data? (irregex-match `(: (* whitespace ) ) str))))



