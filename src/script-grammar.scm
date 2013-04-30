;; @file: regular expressions defining grammar of a script

;; @descr: regular expression used to tokanize script statements and for error detection
;;         NOTE: individual values are not parsed here for technical reasons, see value-igx
(define statement-igx `(: 
                         (=> scope (? "@"))           ; scope modifier
                         (=> name (*  
                                    (or alphabetic 
                                        numeric 
                                        "-"
                                        "_")))
                         (* whitespace)               ; whitespace before +/- op        
                         (or 
                           (=> op (or "+" "-"))
                           (: 
                             (* whitespace)           ; whitespace before :
                             (=> op ":")
                             (=> values               
                                 (+                   ; one or more value brackets 
                                   (: 
                                     (* whitespace)   ; whitespace before each bracket
                                     "[" 
                                     (*? any)         ; non-greedy to stop at nearest "]"
                                     "]")))))))

;; @descr: regular expression used to extract individual values 
(define value-igx `(: 
                     (* whitespace) 
                     "[" 
                     (=> value
                         (*? any))
                     "]"))

;; @descr: regular expression used to search and remove comment blocks from scripts prior to parsing
(define comment-igx `(: 
                       (or
                         (: "#" (*? any) "\n")  ; comments ending with a newline (non-greedy)
                         (: "#" (* any) ))))    ; or at the EOF (greedy)

;; @descr: regular expression for evaluation blocks $(VARIABLE) or $(shell COMMAND)
(define eval-igx `(:
                    "$(" 
                    (* whitespace)
                    (or (: 
                          
                          "shell"                 ; modifier keyword
                          (+ whitespace)
                          (=> command (*? any)))
                        (:
                          (=> scope (? "@"))      ; scope modifier
                          (=> variable (*? any))))
                    (* whitespace)
                    ")"))
                                                                
                     


