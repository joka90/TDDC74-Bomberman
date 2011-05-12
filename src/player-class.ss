;; ---------------------------------------------------------------------
;; class player%, make the player object. 
;; ---------------------------------------------------------------------
(define player%
  (class object%
    (super-new)
    (init-field x-pos y-pos dxdy name lives color)
    (field
     (x-pos-px (* x-pos *blocksize*))
     (y-pos-px (* y-pos *blocksize*))
     (spawn-x-pos x-pos)
     (spawn-y-pos y-pos)
     (type 'player)
     (points 0)
     (radius 1)
     (delay 5000);; bombdelay in ms
     (bomb-count 1)
     (number-of-bombs 0);; how many bombs on board
     (last-bomb-timestamp 0)
     (invincible-in-m-sec 10000)
     (timestamp-invincible 0)
     (last-bomb-place '());; (x . y)
     (direction 'd);;player dir
     (moving #f);; if player is moving or not.
     (animation 1);;current frame in animation
     (animation-start 1);;where to start from
     (animation-stop 5);;where to stop
     (animation-duration 4);frames with same image
     (animation-duration-count 0);;frame counter
     (name-font (make-object font% 15 'default 'normal 'bold))
     (status-font (make-object font% 10 'default 'normal 'bold))
     )
    
    ;;returns true if the bomb has gone off.
    (define/public (possible-to-die?)
      (<= (+ timestamp-invincible invincible-in-m-sec) (*current-m-sec*)))
      
    
    (define/public (can-bomb?)
      (and
       (< number-of-bombs bomb-count)
       (or
        (< (+ last-bomb-timestamp 1000) (*current-m-sec*)); en sek delay eller 
        (not (and 
              (eq? x-pos (car last-bomb-place))
              (eq? y-pos (cdr last-bomb-place))));; inte samma ställe
        )
       ))
    
    (define/public (remv-bomb)
      (set! number-of-bombs (- number-of-bombs 1)))
    
    (define/public (add-bomb)
      (set! number-of-bombs (+ number-of-bombs 1))
      (set! last-bomb-timestamp (*current-m-sec*))
      (set! last-bomb-place (cons x-pos y-pos))
      )
    
    ;;set px pos and logical pos
    (define/public (set-x-pos-px! x)
      (set! x-pos-px x)
      (set! x-pos (quotient (+ x (/ *blocksize* 2))*blocksize*)))
    
    ;;set px pos and logical pos
    (define/public (set-y-pos-px! y)
      (set! y-pos-px y)
      (set! y-pos (quotient (+ y (/ *blocksize* 2)) *blocksize*)))
    
    ;;set logical and px pos
    (define/public (set-x! x)
      (set! x-pos x)
      (set! x-pos-px (* x *blocksize*)))
    
    ;;set logical and px pos
    (define/public (set-y! y)
      (set! y-pos y)
      (set! y-pos-px (* y *blocksize*)))
    
    ;;get px pos
    (define/public (get-y-pos-px)
      y-pos-px)
    
    ;;get px pos
    (define/public (get-x-pos-px)
      x-pos-px)
    
    (define/public (set-dir! dir)
      (set! moving #t)
      (set! direction dir))
    ;; r, l, u, d,

    (define status-bitmap
      (new make-draw%
           [width 170];;canvas/bitmaps size
           [height 100]))
    
    (define/public (update-status-bitmap)
      (send status-bitmap clear)
      (send status-bitmap draw-text name 10 0 name-font)
      (send status-bitmap draw-bitmap-2 (send *image-store* get-image 'max-panel) 60 40)
      (send status-bitmap draw-bitmap-2 (send *image-store* get-image 'heart-panel) 20 40)
      (send status-bitmap draw-bitmap-2 (send *image-store* get-image 'power-panel) 100 40)
      ;number-of-bombs radius lives
      (send status-bitmap draw-text (number->string lives) 40 40 status-font)
      (send status-bitmap draw-text (number->string bomb-count) 80 40 status-font)
      (send status-bitmap draw-text (number->string radius) 120 40 status-font)
      )
  
  (define/public (get-status-bitmap)
    (update-status-bitmap)
    (send status-bitmap get-bitmap))
    
     (define bitmap
      (new make-draw%
           [width 40];;canvas/bitmaps size
           [height 62]))
    
     
    
    (define/private (update-animation-help)
      
      (if moving
       (if(< animation-duration-count animation-duration)
         (set! animation-duration-count (+ animation-duration-count 1))
         (begin
           (set! animation-duration-count 0)
           (if(< animation animation-stop)
              (set! animation (+ animation 1))
              (begin
                (set! animation animation-start)
                
                ))
           ))
       (begin
         (set! animation 0))
         )
       
       )
    
    (define/public (update-bitmap)
      (send bitmap clear)
      ;(send bitmap background-transp)
      
      (update-animation-help)
      (set! moving #f)
      (send bitmap draw-bitmap-2 (send *image-store* get-image color direction animation) 0 0)
      (if(not (possible-to-die?))
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'invincible) 0 0))
      ;(send bitmap set-alpha! 0.5)
    )
    
    (define/public (get-bitmap)
      (update-bitmap)
      (send bitmap get-bitmap))
    ))



