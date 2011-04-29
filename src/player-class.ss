;; ---------------------------------------------------------------------
;; class player%, make the player object. 
;; ---------------------------------------------------------------------
(define player%
  (class object%
    (super-new)
    (init-field x-pos y-pos dxdy name lives)
    (field (height 30) (width 30) (points 0) (radius 2) (bomb-count 5) (delay 5))
    
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

    

    ;; bild kod ----------------------------
    (define buffer (make-object bitmap% 30 30 #f))
    (define dc (make-object bitmap-dc% buffer))
    (send dc clear)
    (send dc set-brush "green" 'solid)
    (send dc set-pen "blue" 1 'solid)
    (send dc draw-rectangle 0 10 30 10)
    (send dc set-pen "red" 3 'solid)
    (send dc draw-line 0 0 30 30)
    (send dc draw-line 0 30 30 0)
    (send dc draw-text name 0 0)
    
    (send dc set-rotation 10)
    
    (define/public (get-bitmap)
      (send dc set-rotation 10)
      buffer)
    ))



