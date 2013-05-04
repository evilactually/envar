(import foreign)

(define-constant user_scope 2)
(define-constant system_scope 1)

;; @descr: get value of a environment variable
;; NOTE: nonnull-c-string* type will be auto-deallocated after return from C function
(define read-var 
  (foreign-lambda nonnull-c-string* "winapi_read_var" int c-string))

(define winapi-var-count/all
  (foreign-lambda int "winapi_var_count_all"))

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

(define (write-var! scope name value) `())

(define (var-exists? scope name) `())

(define (create-var! scope name) `())

(define (delete-var! scope name) `())
