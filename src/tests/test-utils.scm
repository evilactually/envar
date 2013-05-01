(include "utils")

(test-group "utils"
  (test "Shell evaluation" "test\n" (shell-evaluate! "echo test")))

  

