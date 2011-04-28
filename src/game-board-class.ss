;; definera en spelplan med en viss längd och bredd
(define board%
  (class object%
    (super-new)
    (init-field height width height-px width-px)
    (define gamevector (make-vector  (* (+ 1 height) (+ 1 width))))
    
    (define bitmap
      (new make-draw%
           [width width-px];;canvas/bitmaps size
           [height height-px]))
    
    (define/public (update-bitmap)
      (let loop ((index 0))
        (if (< index (vector-length gamevector))
            (begin
              (if (vector-ref gamevector index)
                  (update-bitmap-help (vector-ref gamevector index) (get-pos-invers index)))
              (loop (+ 1 index))))))
        
    
    (define stone-border (send the-pen-list find-or-create-pen "black" 2 'solid))
    (define stone-fill (send the-brush-list find-or-create-brush "yellow" 'solid))

    (define/private (update-bitmap-help type pos)    
      
      (cond  
        ((eq? type 'indestructeble-stone)
         (send bitmap draw-rectangle (* *blocksize* (car pos)) (* *blocksize* (cdr pos)) *blocksize* *blocksize* stone-border stone-fill))
        ((eq? type 'destructeble-stone)
         (send bitmap draw-rectangle (* *blocksize* (car pos)) (* *blocksize* (cdr pos)) *blocksize* *blocksize* stone-border (send the-brush-list find-or-create-brush "red" 'solid)))))
    
    (define/public (get-bitmap)
      (send bitmap get-bitmap))
    
    (define/public (add-object-to-board! x y type) ;;lägger till ett objekt på en given position
      (vector-set! gamevector (get-pos x y) type))
    
    (define/public (delete-object-from-board! x y) ;; som ovan fast ta bort
      (vector-set! gamevector (get-pos x y) 0)) 
    
    ;; #f innebär tomt, annars returneras vilken typ av objekt som ligger på positionen. 
    (define/public (collision? x y) ;; kollar om det ligger något på en viss position.
      (if(and (<= 0 x) (<= 0 y) (< x width) (<= y height))
       (if (eq? (vector-ref gamevector (get-pos x y)) 0)
          #f
          (vector-ref gamevector (get-pos x y)))
       #f))
    
    (define/public (get-pos x y) (+ x (* y width))) ;; översätter vektorn till ett koordinatsystem med (x,y)
    
    (define/public (randomize-stones-2) ;;metod som ska generera stenarna runt en spelplan
      ; (define x 0)
      ; (define y 0)
      (let loop ((x 0)
                 (y 0))
        (if (and (< x width) (< y height))
            (cond
              ((or(and(< x width) (= y 0)) (and (= y  (- height 1)) (< x width)))
               (vector-set! gamevector (get-pos x y) 'indestructeble-stone)
               (cond 
                 ((= x (- width 1)) (loop 0 (+ y 1)))
                 (else (loop (+ 1 x) y))))
               
               ((and(or (= x 0) (= x (- width 1))) (not (= y 0))) 
                (vector-set! gamevector (get-pos x y) 'indestructeble-stone)
                (cond
                  ((= x (- width 1))(loop 0 (+ y 1)))
                  ((= x 0) (loop (- width 1) y)))
                )))))
    
    (define/private (add-destruct-stone? x y)
      (and
          (not (or 
               (and (< x 3) (< y 3));;första hörnet
               (and (<= (- width 3) x) (< y 3));;andra hörnet
               (and (< x 3) (<= (- height 3) y));;4 hörnet
               (and (<= (- width 3) x) (<= (- height 3) y));;3 hörnet
               ))
          (= 0 (random 2))))
    
    (define/public (randomize-stones)
      (define (x-led x)
        (if (< x width)
            (begin
              (y-led 0 x)
              (x-led (+ x 1)))))
      
      (define (y-led y x)
        (if (< y height)
            (begin
              (cond
                ((= x 0)(add-object-to-board! x y 'indestructeble-stone))
                ((= y 0)(add-object-to-board! x y 'indestructeble-stone))
                ((= x (- width 1))(add-object-to-board! x y 'indestructeble-stone))
                ((= y (- height 1))(add-object-to-board! x y 'indestructeble-stone))
                ((and (even? y) (even? x))(add-object-to-board! x y 'indestructeble-stone))
                ((add-destruct-stone? x y)(add-object-to-board! x y 'destructeble-stone))
                )
              (y-led (+ y 1) x))))
      
      (x-led 0);;starta
      )
    
    
    ;;Räknar ut x och y-pos utifrån given pos i vektorn.
    ;; (x-pos . y-pos)
    ;; om utanför, retunera false
    (define/public  (get-pos-invers pos)
      ;(if(<= pos (* (+ 0 height) (+ 0 width)))
         (cons (remainder pos (+ 0 width)) (quotient pos (+ 0 width)))
         ;#f)
      )
    
    
    
    ))


                                         