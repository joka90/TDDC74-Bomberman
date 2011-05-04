;; ---------------------------------------------------------------------
;; class player%, make the player object. 
;; ---------------------------------------------------------------------
(define player%
  (class object%
    (super-new)
    (init-field x-pos y-pos dxdy name lives color)
    (field (height 30) (width 30) (points 0) (radius 1) (bomb-count 1) (delay 5))
    
    (define direction 'd)
    (define moving #f)
    
    (define x-pos-px (* x-pos *blocksize*))
    (define y-pos-px (* y-pos *blocksize*))
    
    (define number-of-bombs 0)
    (define last-bomb-timestamp 0)
    (define last-bomb-place '());; (x . y)
    
    (define/public (can-bomb?)
      (and
       (< number-of-bombs bomb-count)
       (or
        (< last-bomb-timestamp (*current-sec*)); en sek delay eller 
        (not (and 
              (eq? x-pos (car last-bomb-place))
              (eq? y-pos (cdr last-bomb-place))));; inte samma ställe
        )
       ))
    
    (define/public (remv-bomb)
      (set! number-of-bombs (- number-of-bombs 1)))
    
    (define/public (add-bomb)
      (set! number-of-bombs (+ number-of-bombs 1))
      (set! last-bomb-timestamp (*current-sec*))
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

    
     (define bitmap
      (new make-draw%
           [width 40];;canvas/bitmaps size
           [height 62]))
  
    (define animation 1)
    (define animation-start 1)
    (define animation-stop 5)
    (define animation-duration 4);frames with same image
    (define animation-duration-count 0)
    
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
      ;(send bitmap clear)
      ;(send bitmap background-transp)
      
      (update-animation-help)
      (set! moving #f)
      ;(send bitmap draw-bitmap-2 (send *image-store* get-image color direction animation) 0 0)
    )
    
    (define/public (get-bitmap)
      (update-bitmap)
      (send *image-store* get-image color direction animation))
    ))



