;; ---------------------------------------------------------------------
;; class make-paint-tools%
;; ---------------------------------------------------------------------
(define test-player
  (new player%
       [x-pos 30]
       [y-pos 30]
       [dxdy 10]
       [name "kalle"]))

(define stone
  (new stone%
       [x-pos 100]
       [y-pos 100]))

(define game-logic%
  (class object%
    (super-new)
    (init-field height width objects-to-track)
    
    (define (new-pos dir proc)
      (cond
        ((eq? 'u dir)(-(get-field y-pos proc) (get-field dxdy proc)))
        ((eq? 'd dir)(+(get-field y-pos proc) (get-field dxdy proc)))
        ((eq? 'l dir)(-(get-field x-pos proc) (get-field dxdy proc)))
        ((eq? 'r dir)(+(get-field x-pos proc) (get-field dxdy proc)))))
    
    (define (move? proc)
      (let((collition #f))
        (map(lambda (object-to-check)
              (if(and (send object-to-check collition? (get-field x-pos proc) (get-field y-pos proc) (get-field height proc) (get-field width proc)) (not collition));; F = ingen kolltion
                 (set! collition #t)
                 ))
            objects-to-track)
      (not collition)
      ));; inte klar!!!!!!!!!!!!!!!!!!!
    (define/public (move-dir dir proc)
      (if (move? proc)
      (cond
        ((eq? 'u dir)(send proc set-y! (-(get-field y-pos proc) (get-field dxdy proc))))
        ((eq? 'd dir)(send proc set-y! (+(get-field y-pos proc) (get-field dxdy proc))))
        ((eq? 'l dir)(send proc set-x! (-(get-field x-pos proc) (get-field dxdy proc))))
        ((eq? 'r dir)(send proc set-x! (+(get-field x-pos proc) (get-field dxdy proc))))))
      (send proc set-dir! dir))
    
      
    ))

(define test-logic
  (new game-logic%
       [height 500]
       [width 500]
       [objects-to-track (list stone)]))