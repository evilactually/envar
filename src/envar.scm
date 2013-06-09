
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


(include "utils")
(include "script")
(include "help")

(use extras)

;; descr: main application entry point
(define (envar args)
  
  ;; descr: return file name argument if present 
  (define (file-name)
    (if (equal? (length args) 2)
        (second args)
        #f))
  
  (define args-merged (string-merge/deliminated args " "))
  
  ;; body     
  (if (not-whitespace? args-merged) 
      (if (equal? (first args) "-i")
          (execute-script                          ; read script from file or stdio
            (if (file-name)
                (read-string/from-file (file-name))
                (read-string)))
          (if (equal? (first args) "-e")
              (let ((script (generate-script)))    ; generate script to file or stdio
                (if (file-name)
                    (write/to-file (file-name) script)
                    (display script)))
              (execute-script args-merged)))       ; read script from arguments
      (write-line usage-msg)))      ; no args? Show help.      
        
;; Main
(envar (command-line-arguments))
