;; ---------------------------------------------------------------------
;; class make-paint-tools%
;; ---------------------------------------------------------------------
(define stone%
  (class object%
    (super-new)
    (init-field x-pos y-pos)
    (field (height 30) (width 30))
    
    (define/public (set-x! x)
      (set! x-pos x))
    
    (define/public (set-y! y)
      (set! y-pos y))
    
    ;(define/public (set-dir! dir)
    ;  (set! direction dir))
    ;; r, l, u, d,
    ;(define direction 'r)
    
    (define/public (get-bitmap)
      buffer)
    
    ;x-pos < x < x-pos+width
    ;y-pos < y < y-pos+height
    (define/public (collition? xpos ypos h w)
      (and
       (and (<= x-pos xpos) (<= xpos (+ width x-pos))
            (<= y-pos ypos) (<= ypos (+ height y-pos)))
       (and (<= x-pos (+ xpos w)) (<= xpos (+ width (+ x-pos w)))
            (<= y-pos (+ ypos h)) (<= ypos (+ height (+ y-pos h))))))
    
    
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
    
    ))
