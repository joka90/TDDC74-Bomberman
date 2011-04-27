;(define height 20)
;(define width 20)

(define board%
  (class object%
    (super-new)
    (init-field height width)
    (define gamevector (make-vector (* height width)))
    (define/public (add-object-to-board! x y)
      (vector-set! gamevector (get-pos x y) 1))
    
    (define/public (delete-object-from-board! x y)
      (vector-set! gamevector (get-pos x y) 0))
    (define/public (collision? x y)
      (if (= (vector-ref gamevector (get-pos x y)) 0)
          #f
          (vector-ref gamevector (get-pos x y))))
    (define/private (get-pos x y) (+ x (* y width)))
    (define/public (randomize-stones)
      (define x 0)
      (define y 0)
      (define (loop)
      (if (and (<= x width) (<= y height))
        (cond
          ((or(and(<= x width) (= y 0)) (and (= y height) (<= x width)))
           (vector-set! gamevector (get-pos x y) 2)
                                    (cond 
                                      ((= x width) (set! x 0) (set! y (+ y 1))(loop))
                                      (else(set! x (+ x 1))(loop)))
          
          ((and(or (= x 0) (= x width)) (!= y 0))
           (vector-set! gamevector (get-pos x y) 2) (cond
                                                      ((= x width) (set! x 0) (set! y (+ y 1))(loop))
                                                      ((= x 0) (set! x width)(loop)))))))))))
                                         
   
  
    
    

(define board
  (new board%
       [height 20]
       [width 20]))
       
      

;;(vector-set! gamevector 3 "bajs")

