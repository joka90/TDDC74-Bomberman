;; ---------------------------------------------------------------------
;; class flame
;; ---------------------------------------------------------------------
(define flame%
  (class object%
    (super-new)
    (init-field x-pos y-pos delay owner direction)
    (field
     (height 30)
     (width 30)
     (type 'flame)
     (timestamp (*current-sec*)))
       
  
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
           [width *blocksize*];;canvas/bitmaps size
           [height *blocksize*]))

    
    (define/public (update-bitmap)
      (send bitmap clear)  
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
      (cond  
        ((< (- (+ timestamp delay) (*current-sec*)) 1)
         (send *image-store* get-image 'flame-small direction))
        (else
         (send *image-store* get-image 'flame-big direction))))
 
      ))

