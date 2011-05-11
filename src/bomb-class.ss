;; ---------------------------------------------------------------------
;; class make bomb, timestamp and delay to cunt when to explode. Radius to calculate wath to ...
;; ---------------------------------------------------------------------
(define bomb%
  (class object%
    (super-new)
    (init-field x-pos y-pos delay radius owner)
    (field
     (height 30)
     (width 30)
     (type 'bomb)
     (timestamp (*current-m-sec*))
     (bomb-font (make-object font% 10 'modern 'normal 'bold 'smoothed)))
      
    (define/public (set-x! x)
      (set! x-pos x))
    
    (define/public (set-y! y)
      (set! y-pos y))
    

    ;;return timestamp from when the bomb was created.
    (define/public (get-timestamp)
      timestamp)
    
    ;;returns true if the bomb has gone off.
    (define/public (gone-off?)
      (<= (+ timestamp delay) (*current-m-sec*)))
    

    (define/public (collition? xpos ypos)
      (if(and (= xpos x-pos)
           (= ypos y-pos)
           (< (+ timestamp 1000) (*current-m-sec*)));dvs en sek att röra sig på
           type;;return type if coll
           #f))
           
    
    
    
    (define bitmap
      (new make-draw%
           [width *blocksize*];;canvas/bitmaps size
           [height *blocksize*]))

    
    (define/public (update-bitmap)
      (send bitmap clear)
      (send bitmap background-transp)
      (cond  
        ((< (- (+ timestamp delay) (*current-m-sec*)) 2000)
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'bomb-1) 0 0))
        (else
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'bomb-2) 0 0)))
      (send bitmap draw-text (number->string (/ (- (+ timestamp delay) (*current-m-sec*)) 1000)) 0 0 bomb-font))
    
    ;;sends the bitmap, called from the game-logic, to update screen.
    (define/public (get-bitmap)
      (update-bitmap)
      (send bitmap get-bitmap))  
      ))




;(send bomb get-timestamp)
