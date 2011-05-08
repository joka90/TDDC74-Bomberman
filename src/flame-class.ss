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
     (timestamp (*current-sec*))
     (changed #f))
    
    
    (define x-upper (cdr (assq 'l limits)))
    (define x-lower (cdr (assq 'r limits)))
    (define y-upper (cdr (assq 'u limits)))
    (define y-lower (cdr (assq 'd limits)))
    
    (define calc-x-pos (- center-x-pos x-upper))
    (define calc-y-pos (- center-y-pos y-upper))
    
    
    (define calc-height (+ 1 y-upper y-lower))
    (define calc-width (+ 1 x-upper x-lower))
    
    
    
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
      (if(or
          (and (= xpos center-x-pos)
               (<= ypos (+ center-y-pos y-lower))
               (<= (- center-y-pos y-upper) ypos))
          (and (= ypos center-y-pos)
               (<=  xpos (+ center-x-pos x-lower))
               (<= (- center-x-pos x-upper) xpos)))
         type;;return type if coll
         #f))
    
    (define bitmap
      (new make-draw%
           [width (* *blocksize* calc-width)];;canvas/bitmaps size
           [height (* *blocksize* calc-height)]))
    
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
      (draw-y 0 (+ 1 y-upper y-lower))
      )
    
    
    (define/public (update-bitmap) 
      (cond  
        ((< (- (+ timestamp delay) (*current-sec*)) 1)
         (draw-flames 'flame-small))
        (else
         (draw-flames 'flame-big)))
      )
    
    ;;sends the bitmap, called from the game-logic, to update screen.
    (define/public (get-bitmap)
      (send bitmap clear)
      (update-bitmap) 
      (send bitmap get-bitmap))
    
    ))

