;; ---------------------------------------------------------------------
;; klass make bomb, timestamp and delay för att räkna ut när det ska explodera. Radius för att räkna ut vad som skall tas bort
;;---------------------------------------------------------------------
(define bomb%
  (class object%
    (super-new)
    (init-field x-pos y-pos delay radius owner)
    (field (height 30) (width 30) (type 'bomb))
    
    (define timestamp (*current-sec*))
      
    (define/public (set-x! x)
      (set! x-pos x))
    
    (define/public (set-y! y)
      (set! y-pos y))
    

    ;;returnera tidsstämpel från när bomben skapades.
    (define/public (get-timestamp)
      timestamp)
    
    ;;returnerar sant om bomben has sprängts.
    (define/public (gone-off?)
      (<= (+ timestamp delay) (*current-sec*)))
    
    ;; skickas in (x,y) och och returnerar vilken typ som bomben kolliderar med, annars returneras falskt. 
    (define/public (collition? xpos ypos)
      (if(and (= xpos x-pos)
           (= ypos y-pos)
           (< timestamp (*current-sec*)));dvs en sekund att röra sig på
           type
           #f))
           
    
    
    
    (define bitmap
      (new make-draw%
           [width *blocksize*];;canvas-/bitmapsstorlek
           [height *blocksize*]))

    ;;uppdatera bitmapen för bomb med tidsskrift och olika bombbilder
    (define/public (update-bitmap)
      (send bitmap clear)
      (send bitmap background-transp)
      (cond  
        ((< (- (+ timestamp delay) (*current-sec*)) 2)
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'bomb-1) 0 0))
        (else
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'bomb-2) 0 0)))
      (send bitmap draw-text (number->string (- (+ timestamp delay) (*current-sec*))) 0 0)
      )
    
    ;;Skickar bitmapen, anropas från spellogiken för att uppdatera skärmen
    (define/public (get-bitmap)
      (update-bitmap)
      (send bitmap get-bitmap))  
      ))




;(send bomb get-timestamp)
