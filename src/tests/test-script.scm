(include "script")
(include "utils")

(use test extras)

(test-group "parse-statements function, base cases"
            
            (let ((statement (first (parse-statements "VARIABLE + ;"))))
              (test-assert "Create variable" (and 
                                               (equal? "VARIABLE" (op-arg statement `name))
                                               (equal? user_scope (op-arg statement `scope))
                                               (op-create?  statement))))
            
            (let ((statement (first (parse-statements "VARIABLE - ;"))))
              (test "Remove variable" "VARIABLE" (op-arg statement `name)))
            
            (let ((statement (first (parse-statements "VARIABLE : [VALUE]
                                                                  [VALUE2];"))))
              (test-assert "Assign variable" (and 
                                               (equal? "VARIABLE" (op-arg statement `name))
                                               (equal? "VALUE" (first (op-arg statement `values)))
                                               (equal? "VALUE2" (second (op-arg statement `values))))))
            
            (let ((statements (parse-statements "AMETHIST+;
                                                 @DIMOND-;
                                                 JASPER:[RED][GREEN];")))
              (test-assert "Mutiline script" (and 
                                               (equal? "AMETHIST" (op-arg (first statements) `name))
                                               (equal? user_scope (op-arg (first statements) `scope))
                                               (op-create? (first statements))
                                               
                                               (equal? "DIMOND" (op-arg (second statements) `name))
                                               (equal? system_scope (op-arg (second statements) `scope))
                                               (op-remove? (second statements))
                                               
                                               (equal? "JASPER" (op-arg (third statements) `name))
                                               (equal? user_scope (op-arg (third statements) `scope))
                                               (op-assign? (third statements)))))
            
            (let ((statements (parse-statements 
                                (strip-comments "VAR-; # JAR : [VALUE]
                                                       # BAR+"))))
              (test "Comments" 1 (length statements)))
            
            (let ((statements (parse-statements "@GLOBAL_VAR+; USER_VAR-;")))
              (test "Scope modifier #1: present" system_scope (op-arg (first statements) `scope))
              (test "Scope modifier #2: not present" user_scope (op-arg (second statements) `scope)))
            
            (let ((statement (first (parse-statements "@AZ_az_09 +;"))))
              (test "Valid charset for names" "AZ_az_09" (op-arg statement `name)))
            
            (let ((statement (first (parse-statements "VARIABLE : [~!@$%^&*(){}_-=+-|\\/.,<>;:'\"]
                                                                  [ABCDFabcdf]
                                                                  [1234567890];"))))
              (test-assert "Valid charset for values" (and 
                                                        (equal? "~!@$%^&*(){}_-=+-|\\/.,<>;:'\"" (first (op-arg statement `values)))
                                                        (equal? "ABCDFabcdf" (second (op-arg statement `values)))
                                                        (equal? "1234567890" (third (op-arg statement `values))))))
            
            (let ((statement (first (parse-statements "VARIABLE : [$(TMP);C:\\test\\bin];"))))
              
              (test "$(...) blocks are postponed until execution" 
                    "$(TMP);C:\\test\\bin"      
                    (first (op-arg statement `values))))
            
            (let ((statement (first (parse-statements 
                                      "VARIABLE : [$(shell echo AMETHIST) RING];"))))
              
              (test "$(shell ...) blocks are postponed until execution" 
                    "$(shell echo AMETHIST) RING"
                    (first (op-arg statement `values)))))
            
(test-group "parse-statements function, special cases"
            
            (let ((statement (first (parse-statements "_A_PATH_+;"))))
              (test "Underscores #1" "_A_PATH_" (op-arg statement `name)))
            
            (let ((statement (first (parse-statements "___+;"))))
              (test "Underscores #2: all undersoceres" "___" (op-arg statement `name))))
            
(test-group "invalid-tokens function"
  (test "Variable with a wrong operator" 1 (length (invalid-tokens "VAR+; PATH*; JAR:[1234];")))
  (test "Missing value block" 1 (length (invalid-tokens "VAR+; PATH+; JAR:")))
  (test "Unterminated value block" 1 (length (invalid-tokens "VAR+; PATH+; JAR:[val1][val2")))
  (test "Unexpected token between value blocks" 1 (length (invalid-tokens "JAR:[val1]?[val2];")))
  (test "Missing ;" 1 (length (invalid-tokens "VAR+; PATH; JAR + ")))
  (test "Unexpected ;" 1 (length (invalid-tokens "VAR+; 
                                                  PATH : [VALUE0]
                                                         [VALUE1];
                                                         [VALUE2];
                                                         [VALUE3];
                                                  JAR;")))
  (test "Special chars are not allowed" 3 (length (invalid-tokens "@SUPER_U$ER:[VALUE]; B@R+; JAR-BAR; "))))
  

(test-group "execute-script function"
  (execute-script "MATERIAL : [CARBON-FIBER COMPOSITE];")
  (test-assert "Variable exists" (var-exists? user_scope "MATERIAL"))
  (test "Variable asignment script" "CARBON-FIBER COMPOSITE" (read-var user_scope "MATERIAL"))

  (execute-script "MATERIAL -;")
  (test-assert "Variable remove" (not (var-exists? user_scope "MATERIAL")))

  (execute-script "PROPULSION +;")
  (test-assert "Variable create" (var-exists? user_scope "PROPULSION"))

  (execute-script "PROPULSION : [TURBOFAN;];")
  (execute-script "PROPULSION : [$(PROPULSION)] 
                                [TURBOJET;]
                                [TURBOPROP;]
                                [SCRAMJET;];")
  (test "Variable referencing after assignment" 
        "TURBOFAN;TURBOJET;TURBOPROP;SCRAMJET;" 
        (read-var user_scope "PROPULSION"))

  (execute-script "PROPULSION -;"))
  