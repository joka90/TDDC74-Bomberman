(define user-interact-canvas% 
  (class canvas%
    (override on-char)
    
    (define keysdown '());;Lista med alla nedtrycka knappar
    (define (on-char key-event)
      (let ((release (send key-event get-key-release-code))
            (key (send key-event get-key-code)));; http://docs.racket-lang.org/gui/key-event_.html

        ;;Kollar så att det inte är ett relese event och att den inte redan är nedtryckt.
        ;; Annars tas den bort från keysdown listan
        (if(and (not (member key keysdown)) (eq? release 'press))
           (set! keysdown (cons key keysdown))
           (set! keysdown (remv release keysdown)))
        
        ;; Skickar vidare alla nedtryckta knappar till handle-key-event funktionen.
        (map(lambda (key)
              (handle-key-event key))
            keysdown)));; end on-char
    
    (super-instantiate ()))) 





;; Handle keys pressd; space, +, -
(define (handle-key-event key)
    (cond
      ((eq? #\w key)(send test-logic move-dir 'u test-player))
      ((eq? #\a key)(send test-logic move-dir 'l test-player))
      ((eq? #\s key)(send test-logic move-dir 'd test-player))
      ((eq? #\d key)(send test-logic move-dir 'r test-player))
     ))
