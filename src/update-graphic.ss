(define change-grap%
  (class object%
    (super-new)
    (init-field players-to-track objects-to-track)
    
    
    (define/public (update-scene draw-class)
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (get-field x-pos proc) (get-field y-pos proc)))
            players-to-track)
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (get-field x-pos proc) (get-field y-pos proc)))
            objects-to-track)
      )
      
    ))
(define update
  (new change-grap%
       [players-to-track (list test-player)]
       [objects-to-track (list stone)]))
;; The procedures that draws the ball.
(define (draw)
  (send *draw* clear)
  (send update update-scene *draw*)
  ;(send *draw* background)
  (send *gui* redraw))