(import foreign)

(define-constant user_scope 2)
(define-constant system_scope 1)

;; @descr: get value of a environment variable
;; NOTE: nonnull-c-string* type will be auto-deallocated after return from C function
(define read-var 
  (foreign-lambda nonnull-c-string* "winapi_read_var" int c-string))

;; @descr: return total number of vars in both scopes
(define winapi-var-count/all
  (foreign-lambda int "winapi_var_count_all"))

;; @descr: return number of vars in a scope (user or system)
(define winapi-var-count/scope
  (foreign-lambda int "winapi_var_count_scope" int))

;; @descr: enumerates all variables(user and system) by index
(define winapi-read-by-index
  (foreign-lambda bool "winapi_read_by_index" int (c-pointer int) (c-pointer c-string) (c-pointer c-string)))

;; @descr: returns list of variables ((scope name value) (scope name value) ...)
(define (read-all-vars)
  (let ((total-count (winapi-var-count/all)))
   (let loop ((index 0))
      (if (>= index total-count) 
          `()
          (begin
            (let-location ((scope int)
                           (name c-string*)   ; c-string* is malloced from c, but it will be  
                           (value c-string*)) ; auto-deallocated on first dereference
            (winapi-read-by-index index (location scope) (location name) (location value))
            (cons (list scope name value) (loop (+ index 1))))))))) ; memory is deallocated 
                                                                    ; at this point

;; @descr: set value of environment variable in registry                                                                    
(define write-var!
  (foreign-lambda void "winapi_write_var" int c-string c-string))

;; @descr: returns #t if variable is present in registry
(define (var-exists? scope name) `())

;; @descr: creates empty variable in scope
(define (create-var! scope name)
  (write-var! scope name ""))

;; @descr: removes variable from scope
(define remove-var!
  (foreign-lambda void "winapi_remove_var" int c-string))
