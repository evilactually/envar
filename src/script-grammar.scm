
; Copyright (C) 2013 Vlad Sarella

; This program is free software; you can redistribute it and/or
; modify it under the terms of the GNU General Public License
; as published by the Free Software Foundation; either version 2
; of the License, or (at your option) any later version.

; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  

; See the GNU General Public License for more details.

; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.


;; @file: regular expressions defining grammar of a script

;; @descr: regular expression used to tokanize script statements and for error detection
;;         NOTE: individual values are not parsed here for technical reasons, see value-igx
(define statement-igx `(: 
                         (=> scope (? "@"))               ; scope modifier
                         (=> name (+  
                                    (or alphabetic 
                                      numeric 
                                      "_")))
                         (?
                           (* whitespace)                 ; whitespace before +/- op is OK        
                                                          ; all operators are optional
                             (or 
                               (=> op (or "+" "-"))
                               (: 
                                 (* whitespace)           ; whitespace before : is OK
                                 (=> op ":")
                                 (=> values               
                                     (+                   ; one or more value brackets 
                                       (: 
                                         (* whitespace)   ; whitespace before each bracket
                                         "[" 
                                         (*? (- any "[]")); stop at nearest "]", ban ] and [ inside
                                         "]"))))))
                         (* whitespace)                   ; whitespace before ; is OK
                         ";"))                            ; statement deliminator

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
                                             