(include "utils")
(include "script")

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
              (let ((script (generate-script)))    ; generate script to file or stdio
                (if (file-name)
                    (write/to-file (file-name) script)
                    (display script)))
              (execute-script args-merged)))       ; read script from arguments
      (write-line "UNHELPFUL HELP MESSAGE")))      ; no args? Show help.      
        
;; Main
(envar (command-line-arguments))

;(use lolevel)
;(include "vars")
; (define-external scope_ext int)
; (define-external name_ext c-string)
; (define-external value_ext c-string)

; (for-each 
;   (lambda (i)
;     (winapi-read-by-index i (location scope_ext) (location name_ext) (location value_ext))
;     (write-line name_ext))
;     ;(let ((name name_ext))
;     ;  (write-line name)))
;   (list 0 1 2 3 4))

; (display (generate-script))
