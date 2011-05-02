;; ---------------------------------------------------------------------
;; timer, 
;; ---------------------------------------------------------------------
(define make-timer%
  (class object%
    (super-new)
    (init-field delay proc)
    
    (define timestamp (*current-sec*))

    
    ;;returns true if the bomb has gone off.
    (define/public (gone-off?)
      (<= (+ timestamp delay) (*current-sec*)))
    
    (define/public (run-proc)
      (proc)
      )
    
      ))

