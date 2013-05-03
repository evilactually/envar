(import foreign)
(import lolevel)

;(foreign-declare "#include <windows.h>")

(define-constant user_scope 2)
(define-constant system_scope 1)

;; @descr: get value of a environment variable
;; NOTE: nonnull-c-string*, because returned string is malloced and needs to be freed
(define read-var 
  (foreign-lambda nonnull-c-string* "winapi_read_var" int c-string))

(define winapi-var-count/all
  (foreign-lambda int "winapi_var_count_all"))

(define winapi-read-by-index
  (foreign-lambda bool "winapi_read_by_index" int (c-pointer int) (c-pointer c-string) (c-pointer c-string)))

;; @descr: returns list of list of variables ((scope name value) (scope name value) ...)
(define (read-all-vars)
  (define-external scope_ext int)
  (define-external name_ext c-string*)
  (define-external value_ext c-string*)
  
  (define total-count (winapi-var-count/all))
  
  (let loop ((index 0))
    (cond
      ((>= index total-count) `())
      (else
        (winapi-read-by-index index (location scope_ext) (location name_ext) (location value_ext))
        (cons (list index scope_ext name_ext value_ext) (loop (+ index 1)))))))

(define (write-var! scope name value) `())

(define (var-exists? scope name) `())

(define (create-var! scope name) `())

(define (delete-var! scope name) `())
