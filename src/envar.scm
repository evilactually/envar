(include "utils.scm")
(include "script.scm")
(include "data.scm")
(include "system.scm")

(use extras)

;; @descr: performs action described by statement data structure
(define (execute-statement! statement) `())

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
            (write-line (~ "Unrecognized input: " bad-token)))
          found-bad-tokens))))

;; descr: main application entry point
(define (envar args)
  
  ;; helpers 
  (define (file-name)
    (if (equal? (length args) 2)
        (second args)
        #f))
  
  (define args-merged (string-merge/deliminated args " "))
  
  ;; body     
  (if (not-whitespace? args-merged) 
      (if (equal? (first args) "-i")
          (execute-script                          ; read script from file or stdio
            (if (file-name)
                (read-string/from-file (file-name))
                (read-string)))
          (if (equal? (first args) "-e")
              (let ((script generate-script))      ; generate script to file or stdio
                (if (file-name)
                    (write/to-file (file-name) script)
                    (write script)))
              (execute-script args-merged)))       ; read script from arguments
      (write-line "UNHELPFUL HELP MESSAGE")))      ; no args? Show help.      
        
;; Main
(define (run)
  (envar (command-line-arguments)))
