;; ---------------------------------------------------------------------
;; ====timer-class.ss
;; ---------------------------------------------------------------------
;;Klass för att få till timers till bomberna
(define make-timer%
  (class object%
    (super-new)
    (init-field delay proc args)
    ;;tidsstämpel i form av millisekunder
    (define timestamp (*current-m-sec*))

    
    ;;returnerar sant om bomben har sprängts
    (define/public (gone-off?)
      (<= (+ timestamp delay) (*current-m-sec*)))
    ;; applicerar argument på en procedur
    (define/public (run-proc)
      (apply proc args))))

