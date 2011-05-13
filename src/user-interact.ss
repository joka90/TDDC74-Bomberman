(define user-interact-canvas% 
  (class canvas%
    (override on-char)
    (init-field on-key-event-callback)
     
    (define keysdown '());;Lista med alla nedtrycka knappar
    (define (on-char key-event)
      (let ((release (send key-event get-key-release-code))
            (key (send key-event get-key-code)))
        
        ;;Kollar så att det inte är ett relese event och att den inte redan är nedtryckt.
        ;; Annars tas den bort från keysdown listan
        ;; press or down depending on version of drracket
        (if(and (not (member key keysdown))
                (or (eq? release 'press) (eq? release 'down)))
           (set! keysdown (cons key keysdown))
           (set! keysdown (remv release keysdown)))));; end on-char
    
;; Skickar vidare alla nedtryckta knappar till on-key-event-callback funktionen.
;; Som defineras när klassen skapas. Som det är nu så skickas dem till game-logic
;;Denna metod anropas utifrån via gui-classen via 
;;main-loop för att skicka vidare nedtrycka knappar.
    (define/public (send-key-events)
        (for-each
         (lambda (key)
              (on-key-event-callback key))
            keysdown))
    
    (super-instantiate ())))

