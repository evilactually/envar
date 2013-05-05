(include "vars.scm")

(test-group "registry access functions"
            (write-var! user_scope "CARBON" "1s2 2s2 2p2")
            (write-var! system_scope "SILICON" "1s2 2s2 2p6 3s2 3p2")
            
            (test "write-var->read-var user scope" "1s2 2s2 2p2" (read-var user_scope "CARBON"))
            (test "write-var->read-var system scope" "1s2 2s2 2p6 3s2 3p2" (read-var system_scope "SILICON"))
            
            (create-var! user_scope "BORON")
            (test-assert "create-var->var-exists? user scope" (var-exists? user_scope "BORON"))
            (test-assert "create-var->var-exists? cross-check with system scope" (not (var-exists? system_scope "BORON")))
            
            (write-var! user_scope "BORON" "1s2 2s2 2p1")
            (test "create-var!->read-var->write-var user scope" "1s2 2s2 2p1" (read-var user_scope "BORON"))
            
            (create-var! system_scope "BORON")
            (remove-var! user_scope "BORON")
            (test-assert "remove-var->var-exists? user scope" (not (var-exists? user_scope "BORON")))
            (test-assert "remove-var->var-exists? cross-check with system scope" (var-exists? system_scope "BORON"))
            
            (remove-var! system_scope "BORON")
            (remove-var! user_scope "CARBON")
            (remove-var! system_scope "SILICON")
            
            (test-assert "remove-var->var-exists? clean-up" (and (not (var-exists? system_scope "BORON"))
                                                                 (not (var-exists? user_scope "CARBON"))
                                                                 (not (var-exists? system_scope "SILICON")))))
