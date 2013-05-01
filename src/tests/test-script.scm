(include "script")
(include "utils")

(use test extras)

(test-group "parse-statements function, base cases"
            
            (let ((statement (first (parse-statements "VARIABLE +"))))
              (test-assert "Create variable" (and 
                                               (equal? "VARIABLE" (op-arg statement `name))
                                               (equal? `user (op-arg statement `scope))
                                               (op-create?  statement))))
            
            (let ((statement (first (parse-statements "VARIABLE -"))))
              (test "Remove variable" "VARIABLE" (op-arg statement `name)))
            
            (let ((statement (first (parse-statements "VARIABLE : [VALUE]
                                                                  [VALUE2]"))))
              (test-assert "Assign variable" (and 
                                               (equal? "VARIABLE" (op-arg statement `name))
                                               (equal? "VALUE" (first (op-arg statement `values)))
                                               (equal? "VALUE2" (second (op-arg statement `values))))))
            
            (let ((statements (parse-statements "AMETHIST+
                                                 @DIMOND-
                                                 JASPER:[RED][GREEN]")))
              (test-assert "Mutiline script" (and 
                                               (equal? "AMETHIST" (op-arg (first statements) `name))
                                               (equal? `user (op-arg (first statements) `scope))
                                               (op-create? (first statements))
                                               
                                               (equal? "DIMOND" (op-arg (second statements) `name))
                                               (equal? `system (op-arg (second statements) `scope))
                                               (op-remove? (second statements))
                                               
                                               (equal? "JASPER" (op-arg (third statements) `name))
                                               (equal? `user (op-arg (third statements) `scope))
                                               (op-assign? (third statements)))))
            
            (let ((statements (parse-statements 
                                (preprocess-script "VAR- # JAR : [VALUE]
                                                                  # BAR+"))))
              (test "Comments" 1 (length statements)))
            
            (let ((statements (parse-statements "@GLOBAL_VAR+ USER_VAR-")))
              (test "Scope modifier #1: present" `system (op-arg (first statements) `scope))
              (test "Scope modifier #2: not present" `user (op-arg (second statements) `scope)))
            
            (let ((statement (first (parse-statements "@A-Z_a-z_0-9 +"))))
              (test "Valid charset for names" "A-Z_a-z_0-9" (op-arg statement `name)))
            
            (let ((statement (first (parse-statements "VARIABLE : [~!@$%^&*(){}_-=+-|\\/.,<>;:'\"]
                                                                  [ABCDFabcdf]
                                                                  [1234567890]"))))
              (test-assert "Valid charset for values" (and 
                                                        (equal? "~!@$%^&*(){}_-=+-|\\/.,<>;:'\"" (first (op-arg statement `values)))
                                                        (equal? "ABCDFabcdf" (second (op-arg statement `values)))
                                                        (equal? "1234567890" (third (op-arg statement `values))))))
            
            (let ((statement (first (parse-statements 
                                      (preprocess-script "VARIABLE : [$(TMP);C:\\test\\bin]")))))
              
              (test "Evaluation block, variable reference" 
                    (string-append (read-var `user "TMP") ";C:\\test\\bin") 
                    (first (op-arg statement `values))))
            
            (let ((statement (first (parse-statements 
                                      (preprocess-script "VARIABLE : [$(shell echo AMETHIST) RING]")))))
              
              (test "Evaluation block, shell command" 
                    "AMETHIST\n RING"
                    (first (op-arg statement `values)))))
            
(test-group "parse-statements function, special cases"
            
            (let ((statement (first (parse-statements "_A_PATH_+"))))
              (test "Underscores #1" "_A_PATH_" (op-arg statement `name)))
            
            (let ((statement (first (parse-statements "___+"))))
              (test "Underscores #2: all undersoceres" "___" (op-arg statement `name)))
            
            (let ((statement (first (parse-statements "-A-PATH--"))))
              (test "Dashes #1" "-A-PATH-" (op-arg statement `name)))
            
            (let ((statement (first (parse-statements "----"))))
              (test "Dashes #2: all dashes" "---" (op-arg statement `name))))

(test-group "invalid-tokens function"
  (test "Variable with no operator" " PATH " (first (invalid-tokens "VAR+ PATH JAR:[1234]")))
  (test "Variable with a wrong operator" " PATH* " (first (invalid-tokens "VAR+ PATH* JAR:[1234]")))
  (test "Missing value block" " JAR:" (first (invalid-tokens "VAR+ PATH+ JAR:")))
  (test "Unterminated value block" "[val2" (first (invalid-tokens "VAR+ PATH+ JAR:[val1][val2")))
  (test "Unexpected token between value blocks" ";[val2]" (first (invalid-tokens "JAR:[val1];[val2]")))
  (test "Special chars are not allowed" 2 (length (invalid-tokens "@SUPER_U$ER:[VALUE] B@R+ "))))
  