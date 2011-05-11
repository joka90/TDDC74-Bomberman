;; ---------------------------------------------------------------------
;; klass flame
;; ---------------------------------------------------------------------
(define flame%
  (class object%
    (super-new)
    (init-field 
     center-x-pos
     center-y-pos
     delay
     owner
     limits)
    (field
     (type 'flame)
     (x-pos 0)
     (y-pos 0)
     (timestamp (*current-m-sec*))
     (changed #f))
    
    ;;Yttre gränserna för var flammorna ska komma
    (define x-upper (cdr (assq 'l limits)))
    (define x-lower (cdr (assq 'r limits)))
    (define y-upper (cdr (assq 'u limits)))
    (define y-lower (cdr (assq 'd limits)))
    ;;göra om den relativa positionen till position i planen
    (define calc-x-pos (- center-x-pos x-upper))
    (define calc-y-pos (- center-y-pos y-upper))
    
    
    (define calc-height (+ 1 y-upper y-lower))
    (define calc-width (+ 1 x-upper x-lower))
    
    
    ;;funktioner som returnerar den absoluta positionen
    (define/public (get-x-pos)
      calc-x-pos)
    
    (define/public (get-y-pos)
      calc-y-pos)
    
    
    ;;returnerar tidsstämpel från när bomben skapades
    (define/public (get-timestamp)
      timestamp)
    
    ;;returnerar sant om bomben har sprängts
    (define/public (gone-off?)
      (<= (+ timestamp delay) (*current-m-sec*)))
    
    ;;tar en punkt (x,y) och kollar om en kollision sker, och i sådana fall med vad. Annars returneras falskt.
    (define/public (collition? xpos ypos)
      (if(or
          (and (= xpos center-x-pos)
               (<= ypos (+ center-y-pos y-lower))
               (<= (- center-y-pos y-upper) ypos))
          (and (= ypos center-y-pos)
               (<=  xpos (+ center-x-pos x-lower))
               (<= (- center-x-pos x-upper) xpos)))
         type
         #f))
    
    (define bitmap
      (new make-draw%
           [width (* *blocksize* calc-width)];;canvas-/bitmapsstorlek
           [height (* *blocksize* calc-height)]))
    
    ;;Funktion för att rita ut flammor, typen anger om det är i x-led eller y-led
    (define/private (draw-flames type)
      (define (draw-x from to)
        (if(<= from to)
           (begin
             (send bitmap draw-bitmap-2
                   (send *image-store* get-image type 'x)
                   (* *blocksize* from)
                   (* *blocksize* y-upper))
             (draw-x (+ 1 from) to))))
      
      (define (draw-y from to)
        (if(<= from to)
           (begin
             (send bitmap draw-bitmap-2
                   (send *image-store* get-image type 'y)
                   (* *blocksize* x-upper)
                   (* *blocksize* from))
             (draw-y (+ 1 from) to))))
      (draw-x 0 (+ 1 x-upper x-lower))
      (draw-y 0 (+ 1 y-upper y-lower)))
    
    ;;uppdateringsfunktion för att byta flamma efter en viss tid
    (define/public (update-bitmap) 
      (cond  
        ((< (- (+ timestamp delay) (*current-m-sec*)) 1000)
         (draw-flames 'flame-small))
        (else
         (draw-flames 'flame-big))))
    
    ;;Skickar bitmapen, anropad från spellogiken för att uppdatera skärmen
    (define/public (get-bitmap)
      (send bitmap clear)
      (update-bitmap) 
      (send bitmap get-bitmap))
    
    ))

