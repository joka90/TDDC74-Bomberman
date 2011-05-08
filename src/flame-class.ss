;; ---------------------------------------------------------------------
;; class flame
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
     (height 30)
     (width 30)
     (type 'flame)
     (x-pos 0)
     (y-pos 0)
     (timestamp (*current-sec*)))
           

    (define x-upper (cdr (assq 'u limits)))
    (define x-lower (cdr (assq 'd limits)))
    (define y-upper (cdr (assq 'l limits)))
    (define y-lower (cdr (assq 'r limits)))
    
    (define calc-x-pos (- center-x-pos x-upper))
    (define calc-y-pos (- center-x-pos y-upper))
    
    
    (define calc-width (+ 1 y-upper y-lower))
    (define calc-height (+ 1 x-upper x-lower))
    
   
    
    (define/public (get-x-pos)
      calc-x-pos)
    
    (define/public (get-y-pos)
      calc-y-pos)
    
    
    ;;return timestamp from when the bomb was created.
    (define/public (get-timestamp)
      timestamp)
    
    ;;returns true if the bomb has gone off.
    (define/public (gone-off?)
      (<= (+ timestamp delay) (*current-sec*)))
    
    
    (define/public (collition? xpos ypos)
      (if(and (= xpos x-pos)
              (= ypos y-pos))
         type;;return type if coll
         #f))

    (define bitmap
      (new make-draw%
           [width (* *blocksize* calc-width)];;canvas/bitmaps size
           [height (* *blocksize* calc-height)]))

    
    (define/public (update-bitmap)
      ;(send bitmap clear)  
      (cond  
        ((< (- (+ timestamp delay) (*current-sec*)) 1)
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'flame-small direction
                                          ) 0 0))
        (else
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'flame-big direction
                                          ) 0 0)))
      )
    
    ;;sends the bitmap, called from the game-logic, to update screen.
    (define/public (get-bitmap)
      ;(update-bitmap)
      ;(send bitmap get-bitmap)
      
       (send bitmap clear)
      (send bitmap set-background-color! 23 4 1 1)
      (cond  
        ((< (- (+ timestamp delay) (*current-sec*)) 1)
         ;(send *image-store* get-image 'flame-small direction)
         (send bitmap get-bitmap)
         )
        (else
         ;(send *image-store* get-image 'flame-big direction)
         (send bitmap get-bitmap)
         )))
 
      ))

