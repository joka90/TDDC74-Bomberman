(define user-interact-canvas% 
  (class canvas%
    (override on-char)
    (init-field on-key-event-callback)
     
    (define keysdown '());;Lista med alla nedtrycka knappar
    (define (on-char key-event)
      (let ((release (send key-event get-key-release-code))
            (key (send key-event get-key-code)));; http://docs.racket-lang.org/gui/key-event_.html
        
        ;;Kollar så att det inte är ett relese event och att den inte redan är nedtryckt.
        ;; Annars tas den bort från keysdown listan
        (if(and (not (member key keysdown)) 
                (or (eq? release 'press) (eq? release 'down)));; press or down depending on version of drracket
           (set! keysdown (cons key keysdown))
           (set! keysdown (remv release keysdown)))
        ));; end on-char
    
    (define/public (send-key-events);; Skickar vidare alla nedtryckta knappar till handle-key-event funktionen.
        (map(lambda (key)
              (on-key-event-callback key))
            keysdown))
    
    (super-instantiate ())))

