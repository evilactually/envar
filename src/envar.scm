(include "utils.scm")
(use irregex srfi-1 extras posix defstruct)

(define full-igx `(: 
                    (=> scope (? "@"))       ; scope modifier
                    (=> name (*              ; geedy to allow for -/+ chars inside names
                               (- (or alphabetic numeric punctuation graphic)
                                   "[]:@"))) ; ban some characters from names for easier parsing
                                
                    (* whitespace)           ; optional whitespace before +/- op        
                    (or 
                      (=> op (or "+" "-"))
                      (: 
                        (* whitespace)
                        (=> op ":")
                        (=> values
                            (* 
                              
                              (: 
                                (* whitespace) 
                                "[" 
                                (*? any) ; non-greedy to stop at nearest "]"
                                "]")))))))
(define value-igx `(: 
                     (* whitespace) 
                     "[" 
                     (=> value
                         (*? any))
                     "]"))

(define comment-igx `(: 
                       (or
                         (: "--" (*? any) "\n") ; comments ending with a newline (non-greedy)
                         (: "--" (* any) ))))   ; or at the EOF (greedy), whichever happens first

; shorthand definitions:
(define submatch-named irregex-match-substring)

; data structure holding environment variable
(defstruct variable scope name value)

; data structures representing executable statements
(defstruct statement-assign scope name value)
(defstruct statement-create scope name)
(defstruct statement-remove scope name)

;; @descr: removes all commented out text from a string
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

;; @descr: returns a list of match objects
(define (irregex-search/all-matches igx str)
  (irregex-fold 
    igx
    (lambda (i m s) (cons m s))
    '()
    str
    (lambda (i s) (reverse s))))
  
;; @descr: parses a string into a list of statements
(define (parse-statements str)
  (map 
    (lambda (statement-match)
      ;: @descr: get value of submatch in current statement
      (define (value-of submatch-name)
        (submatch-named statement-match submatch-name))
      
      (let ((scope (if (equal?             
                         (value-of `scope) 
                         "@")
                       `system
                       `user))
            (name (value-of `name)))
        (if (equal? (value-of `op) ":")
            (make-statement-assign scope: scope
                                   name: name
                                   value: (string-merge
                                            (map 
                                              (lambda (value-match)
                                                (submatch-named value-match `value))
                                              (irregex-search/all-matches 
                                                value-igx
                                                (submatch-named statement-match `values)))))
            ((if (equal? (value-of `op) "+")
                 make-statement-create
                 make-statement-remove) scope: scope name: name))))
    (irregex-search/all-matches full-igx (strip-comments str))))

;; @descr: renders statement into a script string
(define (statement->script statement) `())

;; @descr: explains what statement does
(define (verbalize-statement statement) "...")

;; @descr: performs action described by statement data structure
(define (execute-statement! statement) `())

(define (environment-variable scope name) `())
(define (all-environment-variables) `())
(define (set-environment-variable! scope name value) `())
(define (environment-variable-exists? scope name) `())
(define (create-environment-variable scope name) `())
(define (delete-environment-variable scope name) `())
(define (shell-evaluate! str) `())


;; @descr: generate scripts from current environment variables
(define (generate-script) `())

;; @descr: parse script and execute it
(define (execute-script script) 
  (let ((found-bad-tokens (invalid-tokens script))) ; check for errors
    (if (null? found-bad-tokens)
        (for-each (lambda (statement)               ; execute statements
                    (write-line (verbalize-statement statement))
                    (execute-statement! statement))
                  (parse-statements script))
        (for-each                                   ; report errors
          (lambda (bad-token)
            (write-line (string-append "Unrecognized input: " bad-token)))
          found-bad-tokens))))

;; descr: main application entry point
(define (envar args)
  ;; helpers 
  (define (file-name)
    (if (equal? (length args) 2)
        (second args)
        #f))
  
  (define (read-string/from-file filename)
    (with-input-from-file filename 
      (lambda ()
        (read-string) )))
  
  (define (write/to-file filename str)
    (with-output-to-file filename 
      (lambda ()
        (write str))))
  
  (define args-merged (string-merge/deliminated args " "))
  (define at-least-one-arg? (>= (length args) 1))
  
  ;; body     
  (if (not-whitespace? args-merged) 
      (if (equal? (first args) "-r")
          (execute-script                          ; read script from file or stdio
            (if (file-name)
              (read-string/from-file (file-name))
              (read-string)))
          (if (equal? (first args) "-w")
            (let ((script generate-script))        ; generate script to file or stdio
              (if (file-name)
                (write/to-file (file-name) script)
                (write script)))
            (execute-script args-merged)))         ; read script from arguments
      (write-line "UNHELPFUL HELP MESSAGE")))            
          
          
    
      
     

  
  ;(for-each write-line args))

;; Main
(define (run)
  (envar (command-line-arguments)))

  ; (let ((input (read-string)))
  ;   (if (not-whitespace? input)
  ;       (write-line "Executing script...")
  ;       (write-line "Producing script..."))))

