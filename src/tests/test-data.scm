(include "data.scm")

(test-group "op data struct"
  (define op (make-op/assign `user "VARNAME" "VALUE"))
  (test-assert (op-assign? op))
  (test-assert (equal? (op-arg op `name) "VARNAME"))
  (test-assert (equal? (op-arg op `value) "VALUE"))

  (define op (make-op/create `system "BARFJAR"))
  (test-assert (op-create? op))

  (define op (make-op/remove `system "FROGBARF"))
  (test-assert (op-remove? op)))
