;(define height 20)
;(define width 20)
(define board%
  (class object%
    (super-new)
    (init-field height width)
    (define gamevector (make-vector (* (+ 1 height) (+ 1 width))))
    
    (define/public (add-object-to-board! x y) ;;lägger till ett objekt på en given position
      (vector-set! gamevector (get-pos x y) 1))
    
    (define/public (delete-object-from-board! x y) ;; som ovan fast ta bort
      (vector-set! gamevector (get-pos x y) 0)) 
    
    ;; #f innebär tomt, annars returneras vilken typ av objekt som ligger på positionen. 
    (define/public (collision? x y) ;; kollar om det ligger något på en viss position.
      (if (eq? (vector-ref gamevector (get-pos x y)) 0)
          #f
          (vector-ref gamevector (get-pos x y))))
    
    (define/private (get-pos x y) (+ x (* y width))) ;; översätter vektorn till ett koordinatsystem med (x,y)
    
    (define/public (randomize-stones) ;;metod som ska generera stenarna runt en spelplan
      ; (define x 0)
      ; (define y 0)
      (let loop ((x 0)
                 (y 0))
        (if (and (<= x width) (<= y height))
            (cond
              ((or(and(<= x width) (= y 0)) (and (= y height) (<= x width)))
               (vector-set! gamevector (get-pos x y) 'indestructeble-stone)
               (cond 
                 ((= x width) (loop 0 (+ y 1)))
                 (else (loop (+ 1 x) y))))
               
               ((and(or (= x 0) (= x width)) (not (= y 0))) 
                (vector-set! gamevector (get-pos x y) 'indestructeble-stone)
                (cond
                  ((= x width)(loop 0 (+ y 1)))
                  ((= x 0) (loop width y)))
                )))))
    
    ;;Räknar ut x och y-pos utifrån given pos i vektorn.
    ;; (x-pos . y-pos)
    ;; om utanför, retunera false
    (define/private  (get-pos-invers pos)
      (if(< i (* (+ 1 height) (+ 1 width)))
         (cons (remainder pos (+ 1 width)) (quotient pos (+ 1 width)))
         #f))
    
    ))
                                         


    
    

(define board
  (new board%
       [height 3]
       [width 4]))
       
      

;;(vector-set! gamevector 3 "bajs")

