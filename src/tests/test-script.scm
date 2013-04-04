(include "script.scm")

(use test extras)

(test-assert #t)

(test-group "comments"
  (define msg (strip-comments "Censored Message: Project -- Heart of Gold \n is under heavy development. It will be delivered as planed
  -- (by 32--18--5435:GTS) \n. Verified Signature: Gallactic Government."))
  (test-assert (irregex-match-data? (irregex-search `(: "Verified Signature") msg)))
  (test-assert (not (irregex-match-data? (irregex-search `(: "Heart of Gold") msg))))
  (test-assert (not (irregex-match-data? (irregex-search `(: "(by 32--18--5435:GTS)") msg)))))

(test-group "one line comment"
  (define str (strip-comments "Project --Hearth Of Gold"))
  (test-assert (not (irregex-match-data? (irregex-search `(: "Heart of Gold") str)))))

(test-group "single statement"
  (define statements (parse-statements "USER:[Ford Prefect] -- an indesnusable together guy PASSWORD:[Pink_Helliphant]"))
  (test-assert (equal? (op-arg (first statements) `name) "USER"))
  (test-assert (equal? (op-arg (first statements) `scope) `user))
  (test-assert (equal? (op-arg (first statements) `value) "Ford Prefect"))
  (test-assert (equal? (length statements) 1)))

(test-group "block of statements"
  (define statements (parse-statements
                      "EARTH_DESCR_REV0 : [Harmless]
                     --EARTH_DESCR_REV1a: [To Thee I Say The Place Is Splendid]
                     --                   [For Those Who Cherish A Good Drink]
                     --                   [The People Mostly There Harmless]
                     --                   [And Would Kill You Only If You Piss Them Off]
                       @EARTH_DESCR_REV1: [Mostly ]          -- New revised edition(cut version)
                                          [Harmless]

                       EARTH_LOCATION -                      -- It has been demolished so there's no location
                       EARTH_POPULATION+                     -- Recent exploration made available new data
                       EARTH_POPULATION : [1]                -- Unfortunately most of the population were killed(demolished)
                                                             -- together with the planet, except for Arthur Dent.
                                                             -- Arthur Dent is scheduled for demolition later this year
                                                             -- plans are available at your local planning council"))

  (test-assert (op-assign? (first statements)))
  (test-assert (equal? (op-arg (first statements) `name) "EARTH_DESCR_REV0"))
  (test-assert (equal? (op-arg (first statements) `value) "Harmless"))
  (test-assert (equal? (op-arg (first statements) `scope) `user))


  (test-assert (op-assign? (second statements)))
  (test-assert (equal? (op-arg (second statements) `name) "EARTH_DESCR_REV1"))
  (test-assert (equal? (op-arg (second statements) `value) "Mostly Harmless"))
  (test-assert (equal? (op-arg  (second statements) `scope) `system))

  (test-assert (op-remove? (third statements)))
  (test-assert (equal? (op-arg (third statements) `name) "EARTH_LOCATION"))
  (test-assert (equal? (op-arg  (third statements) `scope) `user))

  (test-assert (op-create? (fourth statements)))
  (test-assert (equal? (op-arg (fourth statements) `name) "EARTH_POPULATION"))
  (test-assert (equal? (op-arg  (fourth statements) `scope) `user))

  (test-assert (op-assign? (fifth statements)))
  (test-assert (equal? (op-arg (fifth statements) `name) "EARTH_POPULATION"))
  (test-assert (equal? (op-arg (fifth statements) `value) "1"))
  (test-assert (equal? (op-arg  (fifth statements) `scope) `user)))

(test-group "special characters"
  (define statements (parse-statements "@R+-3allyWi3rd_Va^riab&le +
                                       H0lISh1#_JAR_0f_Fr0G_BARF : [a~b!c@d#f$g%h^i&j*()] -- yaak
                                                                   [@JUSTASTRING+]
                                                                   [\"C:\\Program Files x86\\Java\"]"))
  (test-assert (op-create? (first statements)))
  (test-assert (equal? (op-arg (first statements) `name) "R+-3allyWi3rd_Va^riab&le"))

  (test-assert (op-assign? (second statements)))
  (test-assert (equal? (op-arg (second statements) `name) "H0lISh1#_JAR_0f_Fr0G_BARF"))
  (test-assert (equal? (op-arg (second statements) `value) (string-append "a~b!c@d#f$g%h^i&j*()"
                                                                                    "@JUSTASTRING+"
                                                                                    "\"C:\\Program Files x86\\Java\"")))
  (test-assert (equal? (op-arg (second statements) `scope) `user)))

(test-group "script generation"
  
  (define statement (parse-statements (statement->script (make-op/assign `user "NAME" "VALUE"))))
  (test-assert (op-assign? (first statement)))
  (test-assert (equal? (op-arg (first statement) `scope) `user))
  (test-assert (equal? (op-arg (first statement) `name) "NAME"))
  (test-assert (equal? (op-arg (first statement) `value) "VALUE"))
  
  (define statement (parse-statements (statement->script (make-op/create `system "NAME" ))))
  (test-assert (op-create? (first statement)))
  (test-assert (equal? (op-arg (first statement) `scope) `system))
  (test-assert (equal? (op-arg (first statement) `name) "NAME"))
    
  (define statement (parse-statements (statement->script (make-op/remove `user "NAME" ))))
  (test-assert (op-remove? (first statement)))
  (test-assert (equal? (op-arg (first statement) `scope) `user))
  (test-assert (equal? (op-arg (first statement) `name) "NAME")))
            