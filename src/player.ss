;; ---------------------------------------------------------------------
;; class make-paint-tools%
;; ---------------------------------------------------------------------
(define player%
  (class object%
    (super-new)
    (init-field x-pos y-pos dxdy name)
    (field (height 30) (width 30))
    
    (define/public (set-x! x)
      (set! x-pos x))
    
    (define/public (set-y! y)
      (set! y-pos y))
    
    (define/public (set-dir! dir)
      (set! direction dir))
    ;; r, l, u, d,
    (define direction 'r)
    
    (define/public (get-bitmap)
      buffer)
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


