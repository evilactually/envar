(import foreign)

(define-constant user_scope 2)
(define-constant system_scope 1)

;; @descr: get value of a environment variable
;; NOTE: nonnull-c-string*, because returned string is malloced and needs to be freed
(define read-var 
  (foreign-lambda nonnull-c-string* "winapi_read_var" int c-string))


(define winapi-get-var-names
  (foreign-lambda c-string-list* "winapi_get_var_names" int))

;; @descr: returns list of list of variables ((scope name value) (scope name value) ...)
(define (read-all-vars) `())

(define (write-var! scope name value) `())

(define (var-exists? scope name) `())

(define (create-var! scope name) `())

(define (delete-var! scope name) `())

