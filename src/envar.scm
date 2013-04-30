(include "utils.scm")
(include "script.scm")

(use extras)

;; descr: main application entry point
(define (envar args)
  
  ;; descr: return file name argument if present 
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
              (let ((script (generate-script)))      ; generate script to file or stdio
                (if (file-name)
                    (write/to-file (file-name) script)
                    (write script)))
              (execute-script args-merged)))       ; read script from arguments
      (write-line "UNHELPFUL HELP MESSAGE")))      ; no args? Show help.      
        
;; Main
(define (run)
  (envar (command-line-arguments)))
