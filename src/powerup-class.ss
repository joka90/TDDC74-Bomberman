;; ---------------------------------------------------------------------
;; class make powerup
;; ---------------------------------------------------------------------
(define powerup%
  (class object%
    (super-new)
    (init-field x-pos y-pos)
    (field (type (random-type)))
    
    (define (random-type)
      (cdr (assq (random 3)
            '((0 . 'powerup-speed)
              (1 . 'powerup-multi-bomb)
              (2 . 'powerup-stronger-bomb)))))
      
    (define/public (set-x! x)
      (set! x-pos x))
    
    (define/public (set-y! y)
      (set! y-pos y))
    

    
    (define/public (collition? xpos ypos h w)
      (and (= xpos x-pos)
           (= ypos y-pos)
           ))
    
    
    
    
    ;;sends the bitmap, called from the game-logic, to update screen.
    (define/public (get-bitmap)
      (send *image-store* get-image type)
      ))