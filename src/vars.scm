
(import foreign)

(define getstr (foreign-lambda c-string "getstr" c-string))

(define winapi-read-var (foreign-lambda c-string "winapi_read_var" int c-string))

(define (read-var scope name) 
  (winapi-read-var (if (equal? scope `user)
                       2
                       1)
                   name))

(define (read-all-vars) `())

(define (write-var! scope name value) `())

(define (var-exists? scope name) `())

(define (create-var! scope name) `())

(define (delete-var! scope name) `())

