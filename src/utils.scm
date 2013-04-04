
;; @file: Various helper functions and definitions

(use irregex)

(define else #t)

(define submatch-named irregex-match-substring)

(define ~ string-append)

;; @descr: test if each element of members is contained in a given list
(define (member-each? members in)
(cond 
  ((equal? members `()) #t)
  ((not (member (car members) in)) #f)
  (else (member-each? (cdr members) in))))

;; @descr: appends a list of strings and inserts a deliminator in between
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

;; @descr: merge a list of strings
(define (string-merge strings)
  (string-merge/deliminated strings ""))
  
(define (not-whitespace? str)
  (not (irregex-match-data? (irregex-match `(: (* whitespace ) ) str))))

;; @descr: read entire file into string
(define (read-string/from-file filename)
    (with-input-from-file filename 
      (lambda ()
        (read-string) )))

;; @descr: write a string into file  
(define (write/to-file filename str)
  (with-output-to-file filename 
    (lambda ()
      (write str))))

;; @descr: returns a list of matches
(define (irregex-search/all-matches igx str)
  (irregex-fold 
    igx
    (lambda (i m s) (cons m s))
    '()
    str
    (lambda (i s) (reverse s))))
