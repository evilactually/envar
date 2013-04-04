
;; @file: regular expressions defining grammar of a script

(define full-igx `(: 
                    (=> scope (? "@"))           ; scope modifier
                    (=> name (*                  ; geedy to allow for -/+ in names
                               (- (or alphabetic numeric punctuation graphic)
                                   "[]:@")))     ; ban some characters 
                                
                    (* whitespace)               ; whitespace before +/- op        
                    (or 
                      (=> op (or "+" "-"))
                      (: 
                        (* whitespace)           ; whitespace before :
                        (=> op ":")
                        (=> values
                            (* 
                              (: 
                                (* whitespace)   ; whitespace before each bracket
                                "[" 
                                (*? any)         ; non-greedy to stop at nearest "]"
                                "]")))))))
(define value-igx `(: 
                     (* whitespace) 
                     "[" 
                     (=> value
                         (*? any))
                     "]"))

(define comment-igx `(: 
                       (or
                         (: "--" (*? any) "\n")  ; comments ending with a newline (non-greedy)
                         (: "--" (* any) ))))    ; or at the EOF (greedy)
