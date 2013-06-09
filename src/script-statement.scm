
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

;; @file: representation of script statement

(use defstruct srfi-69)

;; @descr: general reresentation of a statement
(defstruct statement op args)

;; @descr: create an assign statement
(define (make-op/assign scope name value)
  (define args-hash (make-hash-table))
  (hash-table-set! args-hash `scope scope)
  (hash-table-set! args-hash `name name)
  (hash-table-set! args-hash `values value)
  (make-statement op: `assign
                  args: args-hash))

;; @descr: check if statement is an assignment op
(define (op-assign? statement)
  (equal? (statement-op statement) `assign))

;; @descr: create an assign statement
(define (make-op/create scope name)
  (define args-hash (make-hash-table))
  (hash-table-set! args-hash `scope scope)
  (hash-table-set! args-hash `name name)
  (make-statement op: `create
                  args: args-hash))

;; @descr: check if statement is a creation op
(define (op-create? statement)
  (equal? (statement-op statement) `create))

;; @descr: create an assign statement
(define (make-op/remove scope name)
  (define args-hash (make-hash-table))
  (hash-table-set! args-hash `scope scope)
  (hash-table-set! args-hash `name name)
  (make-statement op: `remove
                  args: args-hash))

;; @descr: check if statement is a removal op
(define (op-remove? statement)
  (equal? (statement-op statement) `remove))

;; @descr: create a print statement
(define (make-op/print scope name)
  (define args-hash (make-hash-table))
  (hash-table-set! args-hash `scope scope)
  (hash-table-set! args-hash `name name)
  (make-statement op: `print
                  args: args-hash))

;; @descr: check if statement is a removal op
(define (op-print? statement)
  (equal? (statement-op statement) `print))

;; @descr: get statement argument
(define (op-arg statement field)
  (hash-table-ref (statement-args statement) field))
