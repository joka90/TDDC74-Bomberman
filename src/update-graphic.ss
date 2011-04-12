;; ---------------------------------------------------------------------
;; class change-grap%, a function to track and update the grapics in some bitmap sent to this function. In this case the *draw* bitmape created in the gui file.
;; ---------------------------------------------------------------------
(define change-grap%
  (class object%
    (super-new)
    (init-field players-to-track objects-to-track)
    
;; skickar in alla trackade objects bitmaps i en viss positon.
    (define/public (update-scene draw-class)
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (get-field x-pos proc) (get-field y-pos proc)))
            players-to-track)
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (get-field x-pos proc) (get-field y-pos proc)))
            objects-to-track)
      )
      
    ))
