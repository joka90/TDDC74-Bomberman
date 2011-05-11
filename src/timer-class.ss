;; ---------------------------------------------------------------------
;; timer, 
;; ---------------------------------------------------------------------
(define make-timer%
  (class object%
    (super-new)
    (init-field delay proc args)
    
    (define timestamp (*current-m-sec*))

    
    ;;returns true if the bomb has gone off.
    (define/public (gone-off?)
      (<= (+ timestamp delay) (*current-m-sec*)))
    
    (define/public (run-proc)
      (apply proc args)
      )
    
      ))

