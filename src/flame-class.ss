;; ---------------------------------------------------------------------
;; class flame
;; ---------------------------------------------------------------------
(define flame%
  (class object%
    (super-new)
    (init-field x-pos y-pos delay owner direction)
    (field (height 30) (width 30) (type 'flame))
    
    (define timestamp (*current-sec*))
      
  
    ;;return timestamp from when the bomb was created.
    (define/public (get-timestamp)
      timestamp)
    
    ;;returns true if the bomb has gone off.
    (define/public (gone-off?)
      (<= (+ timestamp delay) (*current-sec*)))
    
    ;x-pos < x < x-pos+width
    ;y-pos < y < y-pos+height
    ;x-pos < x+w < x-pos+width
    ;y-pos < y+h < y-pos+height
    (define/public (collition? xpos ypos)
      (and (= xpos x-pos)
           (= ypos y-pos)
           ))
    
    
    
    (define bitmap
      (new make-draw%
           [width *blocksize*];;canvas/bitmaps size
           [height *blocksize*]))

    
    (define/public (update-bitmap)
      (send bitmap clear)  
      (cond  
        ((< (- (+ timestamp delay) (*current-sec*)) 1)
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'bomb-1 ;direction
                                          ) 0 0))
        (else
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'bomb-2 ;direction
                                          ) 0 0)))
      )
    
    ;;sends the bitmap, called from the game-logic, to update screen.
    (define/public (get-bitmap)
      (update-bitmap)
      (send bitmap get-bitmap))  
      ))

