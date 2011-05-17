;;====powerup-class.ss 
;; ---------------------------------------------------------------------
;;klass för att skapa powerup
;; ---------------------------------------------------------------------
(define powerup%
  (class object%
    (super-new)
    (init-field x-pos y-pos)
    ;;sätt en slumpmässig typ av powerup vid skapande av objekt
    (field (type (cdr (assq (random 3)
                            '((0 . powerup-speed)
                              (1 . powerup-multi-bomb)
                              (2 . powerup-stronger-bomb))))))
    
    (define/public (set-x! x)
      (set! x-pos x))
    
    (define/public (set-y! y)
      (set! y-pos y))
    
    ;; Tar xpos och ypos, om en kollision sker 
    ;;returneras vilken typ kollisionen sker mot, annars returneras falskt
    (define/public (collition? xpos ypos)
      (if(and (= xpos x-pos)
              (= ypos y-pos))
         type;;
         #f))
    
    ;;Funktion för att avgöra på vilket sätt ens förmågor ska 
    ;;ändras beroende på vilken powerup som plockats
    (define/public (use-power-up player)
      (cond
        ((eq? type 'powerup-speed)(add-speed player))
        ((eq? type 'powerup-multi-bomb)(add-multi-bomb player))
        ((eq? type 'powerup-stronger-bomb)(add-stronger-bomb player))))
    
    (define/private (add-speed player)
      (if (< (get-field dxdy player) 15)
          (begin;;snabbfix för osynk i kollisionshanteringen
            (set-field! dxdy player (+ (get-field dxdy player) 5))
            (send player set-x! (get-field x-pos player))
            (send player set-y! (get-field y-pos player)))))
    
    (define/private (add-multi-bomb player)
      (set-field! bomb-count player (+ (get-field bomb-count player) 2)))
    
    (define/private (add-stronger-bomb player)
      (set-field! radius player (+ (get-field radius player) 1)))
    
    
    ;;skickar bitmapen, anropad från spellogiken för att uppdatera skärmen.
    (define/public (get-bitmap)
      (send *image-store* get-image type))))