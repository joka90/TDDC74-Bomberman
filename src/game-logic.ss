;; ---------------------------------------------------------------------
;; class game-logic%
;; ---------------------------------------------------------------------


(define game-logic%
  (class object%
    (super-new)
    (init-field height width players-to-track objects-to-track)
    
    (define spelplan '())
    (define bombs '())
    
    (define (move? proc dir)
      (let((collition #f)
           (new-x (get-field x-pos proc))
           (new-y (get-field y-pos proc)))
        (cond
          ((eq? 'u dir)(set! new-y (-(get-field y-pos proc) (get-field dxdy proc))))
          ((eq? 'd dir)(set! new-y (+(get-field y-pos proc) (get-field dxdy proc))))
          ((eq? 'l dir)(set! new-x (-(get-field x-pos proc) (get-field dxdy proc))))
          ((eq? 'r dir)(set! new-x (+(get-field x-pos proc) (get-field dxdy proc)))))
        (map(lambda (object-to-check)
              (if(and (send object-to-check collition? new-x new-y (get-field height proc) (get-field width proc)) (not collition));; F = ingen kolltion
                 (begin
                   (set! collition #t)
                   (display (get-field type object-to-check)))
                 ))
            objects-to-track)
        (not collition)
        ));; inte klar!!!!!!!!!!!!!!!!!!!
    
    ;; fixa en collitonfunktion som klarar av att hitta ett objekt och berätta vilket håll som den stött i
    (define/public (move-dir dir proc)
      (if (move? proc dir)
          (cond
            ((eq? 'u dir)(send proc set-y! (-(get-field y-pos proc) (get-field dxdy proc))))
            ((eq? 'd dir)(send proc set-y! (+(get-field y-pos proc) (get-field dxdy proc))))
            ((eq? 'l dir)(send proc set-x! (-(get-field x-pos proc) (get-field dxdy proc))))
            ((eq? 'r dir)(send proc set-x! (+(get-field x-pos proc) (get-field dxdy proc))))))
      (send proc set-dir! dir))
    
    ;(define/public (add-bomb x-pos y-pos owner)(
    ;                                           
    ;                                           ))
    
    
    ;; skickar in alla trackade objects bitmaps i en viss positon.
    (define/public (update-scene draw-class)
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (get-field x-pos proc) (get-field y-pos proc)))
            players-to-track)
      (map  (lambda (proc)
              (send draw-class draw-bitmap-2 (send proc get-bitmap) (get-field x-pos proc) (get-field y-pos proc)))
            objects-to-track))
    
    ))

