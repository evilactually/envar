(include "envar.scm")

(use test extras)

(test-assert #t)

(let ((msg (strip-comments "Censored Message: Project -- Heart of Gold \n is under heavy development. It will be delivered as planed
-- (by 32--18--5435:GTS) \n. Verified Signature: Gallactic Government.")))
  (test-assert (irregex-match-data? (irregex-search `(: "Verified Signature") msg)))
  (test-assert (not (irregex-match-data? (irregex-search `(: "Heart of Gold") msg))))
  (test-assert (not (irregex-match-data? (irregex-search `(: "(by 32--18--5435:GTS)") msg)))))

(let ((str (strip-comments "Project --Hearth Of Gold")))
  (test-assert (not (irregex-match-data? (irregex-search `(: "Heart of Gold") str)))))
  
(let ((statements (parse-statements "USER:[Ford Prefect] -- an indesnusable together guy PASSWORD:[Pink_Helliphant]")))
  (test-assert (equal? (statement-assign-name (first statements)) "USER"))
  (test-assert (equal? (statement-assign-scope (first statements)) `user))
  (test-assert (equal? (statement-assign-value (first statements)) "Ford Prefect"))
  (test-assert (equal? (length statements) 1)))

(let ((statements (parse-statements 
                    "EARTH_DESCR_REV0 : [Harmless]
                   --EARTH_DESCR_REV1a: [To Thee I Say The Place Is Splendid]
                   --                   [For Those Who Cherish A Good Drink]
                   --                   [The People Mostly There Harmless]
                   --                   [And Would Kill You Only If You Piss Them Off]
                     @EARTH_DESCR_REV1 :[Mostly ]          -- New revised edition(cut version)
                                        [Harmless]   

                     EARTH_LOCATION -                      -- It has been demolished so there's no location
                     EARTH_POPULATION+                     -- Recent exploration made available new data
                     EARTH_POPULATION : [1]                -- Unfortunately most of the population were killed(demolished)
                                                           -- together with the planet, except for Arthur Dent.
                                                           -- Arthur Dent is scheduled for demolition later this year
                                                           -- plans are available at your local planning council
                     @R+-3allyWi3rd_Va^riab&le +            
                     H0lISh1#_JAR_0f_Fr0G_BARF : [a~b!c@d#f$g%h^i&j*()] -- yaak
                                                 [@JUSTASTRING+]
                                                 [\"C:\\Program Files x86\\Java\"]")))
  
  (test-assert (statement-assign? (first statements)))
  (test-assert (equal? (statement-assign-name (first statements)) "EARTH_DESCR_REV0"))
  (test-assert (equal? (statement-assign-value (first statements)) "Harmless"))
  (test-assert (equal? (statement-assign-scope (first statements)) `user))
  
  
  (test-assert (statement-assign? (second statements)))
  (test-assert (equal? (statement-assign-name (second statements)) "EARTH_DESCR_REV1"))
  (test-assert (equal? (statement-assign-value (second statements)) "Mostly Harmless"))
  (test-assert (equal? (statement-assign-scope (second statements)) `system))
  
  (test-assert (statement-remove? (third statements)))
  (test-assert (equal? (statement-remove-name (third statements)) "EARTH_LOCATION"))
  
  (test-assert (statement-create? (fourth statements)))
  (test-assert (equal? (statement-create-name (fourth statements)) "EARTH_POPULATION"))
  
  (test-assert (statement-assign? (fifth statements)))
  (test-assert (equal? (statement-assign-name (fifth statements)) "EARTH_POPULATION"))
  (test-assert (equal? (statement-assign-value (fifth statements)) "1"))
  (test-assert (equal? (statement-assign-scope (fifth statements)) `user))
  
  (test-assert (statement-create? (sixth statements)))
  (write-line (statement-create-name (sixth statements)))
  (test-assert (equal? (statement-create-name (sixth statements)) "R+-3allyWi3rd_Va^riab&le"))
  
  (test-assert (statement-assign? (seventh statements)))
  (test-assert (equal? (statement-assign-name (seventh statements)) "H0lISh1#_JAR_0f_Fr0G_BARF"))
  (test-assert (equal? (statement-assign-value (seventh statements)) (string-append "a~b!c@d#f$g%h^i&j*()"
                                                                                    "@JUSTASTRING+"
                                                                                    "\"C:\\Program Files x86\\Java\"")))
  (test-assert (equal? (statement-assign-scope (seventh statements)) `user)))

(let ((bad-tokens (invalid-tokens "@VAR+ PATH : [I'm a user] [variable]")))
  (test-assert (equal? (length bad-tokens) 0)))



(test-exit)
