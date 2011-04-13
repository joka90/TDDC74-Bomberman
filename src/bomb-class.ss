;; ---------------------------------------------------------------------
;; class make bomb, timestamp and delay to cunt when to explode. Radius to calculate wath to ...
;; ---------------------------------------------------------------------
(define bomb%
  (class object%
    (super-new)
    (init-field x-pos y-pos delay radius)
    (field (height 30) (width 30) (type 'bomb))
    
    (define timestamp (current-seconds))
      
    (define/public (set-x! x)
      (set! x-pos x))
    
    (define/public (set-y! y)
      (set! y-pos y))
    
    (define/public (get-bitmap)
      buffer)
    
    (define/public (get-timestamp)
      timestamp)
    
    (define/public (gone-off?)
      timestamp)
    
    ;x-pos < x < x-pos+width
    ;y-pos < y < y-pos+height
    ;x-pos < x+w < x-pos+width
    ;y-pos < y+h < y-pos+height
    (define/public (collition? xpos ypos h w)
      (and
       (or (and (<= x-pos xpos) (<= xpos (+  x-pos width)))
           (and (<= x-pos (+ xpos w)) (<= (+ xpos w) (+ x-pos width))))
       (or (and (<= y-pos ypos) (<= ypos (+  y-pos height)))
           (and (<= y-pos (+ ypos h)) (<= (+ ypos h) (+ y-pos height))))))
    
    
    
    ;; bild kod ----------------------------
    (define buffer (make-object bitmap% 30 30 #f))
    (define dc (make-object bitmap-dc% buffer))
    (send dc clear)
    (send dc set-brush "red" 'solid)
    (send dc set-pen "green" 3 'solid)
    (send dc draw-rectangle 0 10 30 10)
    (send dc set-pen "red" 3 'solid)
    (send dc draw-line 0 0 30 30)
    (send dc draw-line 0 30 30 0)))


(define bomb
  (new bomb%
       [x-pos 100]
       [y-pos 100]
       [delay 10]
       [radius 10]))

(send bomb get-timestamp)
