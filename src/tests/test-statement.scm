(include "script-statement")

(test-group "statement struct"
            (let ((op (make-op/assign `user "VARNAME" (list "VALUE"))))
              (test-assert "Assign var statement" 
                           (and (op-assign? op)
                                (equal? (op-arg op `name) "VARNAME")
                                (equal? (first (op-arg op `values)) "VALUE"))))
            
            (let ((op (make-op/create `user "VARNAME" )))
              (test-assert "Create var statement" 
                           (and (op-create? op)
                                (equal? (op-arg op `name) "VARNAME"))))
            
            (let ((op (make-op/remove `user "VARNAME" )))
              (test-assert "Remove var statement" 
                           (and (op-remove? op)
                                (equal? (op-arg op `name) "VARNAME")))))

            
            
            
    

