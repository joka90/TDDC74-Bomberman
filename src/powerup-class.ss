;; ---------------------------------------------------------------------
;; class make powerup
;; ---------------------------------------------------------------------
(define powerup%
  (class object%
    (super-new)
    (init-field x-pos y-pos)
    (field (type 'powerup-speed))
    
    (define (random-type)
      (cdr (assq (random 3)
            '((0 . 'powerup-speed)
              (1 . 'powerup-multi-bomb)
              (2 . 'powerup-stronger-bomb)))))
      
    (define/public (set-x! x)
      (set! x-pos x))
    
    (define/public (set-y! y)
      (set! y-pos y))
    

    
    (define/public (collition? xpos ypos)
      (and (= xpos x-pos)
           (= ypos y-pos)
           ))
    
    (define/public (use-power-up player)
      (cond
        ((eq? type 'powerup-speed)(add-speed player))
        ((eq? type 'powerup-multi-bomb)(add-multi-bomb player))
        ((eq? type 'powerup-stronger-bomb)(add-stronger-bomb player))
        ))
    
     (define/private (add-speed player)
      (set-field! dxdy player (+ (get-field dxdy player) 5))
       )
    
    (define/private (add-multi-bomb player)
      (set-field! bomb-count player (+ (get-field bomb-count player) 3))
      )
    
    (define/private (add-stronger-bomb player)
      (set-field! radius player (+ (get-field radius player) 1))
      )
    
    
    ;;sends the bitmap, called from the game-logic, to update screen.
    (define/public (get-bitmap)
      (send *image-store* get-image type)
      )))