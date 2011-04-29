;; ---------------------------------------------------------------------
;; class player%, make the player object. 
;; ---------------------------------------------------------------------
(define player%
  (class object%
    (super-new)
    (init-field x-pos y-pos dxdy name lives)
    (field (height 30) (width 30) (points 0) (radius 1) (bomb-count 5) (delay 5))
    
    (define direction 'r)
    (define direction-angle 0)
    (define direction-angle-diff 0);; to track the bitmaps rotation 
   
    
    (define x-pos-px (* x-pos *blocksize*))
    (define y-pos-px (* y-pos *blocksize*))
    
    (define number-of-bombs 0)
    
    (define/public (can-bomb?)
      (<= number-of-bombs bomb-count))
    
    (define/public (remv-bomb)
      (set! number-of-bombs (- number-of-bombs 1)))
    
    (define/public (add-bomb)
      (set! number-of-bombs (+ number-of-bombs 1)))
    
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
      (if(not (eq? dir direction))
         (begin
;           (cond
;            ((eq? dir 'r)(set! direction-angle-diff 0)
;                          (set! direction-angle (+ 0 (- direction-angle direction-angle-diff)))
;             ((eq? dir 'l)(set! direction-angle-diff pi)
;                          (set! direction-angle (+ pi (- direction-angle direction-angle-diff))))
;             ((eq? dir 'u)(set! direction-angle-diff (* pi (/ 2 3)))
;                          (set! direction-angle (+ (* pi (/ 2 3)) (- direction-angle direction-angle-diff))))
;             ((eq? dir 'd)(set! direction-angle-diff (* pi (/ 1 2)))
;                          (set! direction-angle (+ (* pi (/ 1 2)) (- direction-angle direction-angle-diff))))))
           (set! direction dir))))
    ;; r, l, u, d,

    
     (define bitmap
      (new make-draw%
           [width *blocksize*];;canvas/bitmaps size
           [height *blocksize*]))
  
    (define bitmap-up (make-object bitmap% "img/u.bmp" 'unknown #f))
    (define bitmap-down (make-object bitmap% "img/d.bmp" 'unknown #f))
    (define bitmap-left (make-object bitmap% "img/l.bmp" 'unknown #f))
    (define bitmap-right (make-object bitmap% "img/r.bmp" 'unknown #f))
    
    (define/public (update-bitmap)
      (send bitmap clear)  
      (cond  
        ((eq? direction 'u)
         (send bitmap draw-bitmap-2 bitmap-up 0 0))
        ((eq? direction 'd)
         (send bitmap draw-bitmap-2 bitmap-down 0 0))
        ((eq? direction 'l)
         (send bitmap draw-bitmap-2 bitmap-left 0 0))
        ((eq? direction 'r)
         (send bitmap draw-bitmap-2 bitmap-right 0 0))))
    
    (define/public (get-bitmap)
      (update-bitmap)
      (send bitmap get-bitmap))
    ))



