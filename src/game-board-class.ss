;; definera en spelplan med en viss längd och bredd
(define board%
  (class object%
    (super-new)
    (init-field height width height-px width-px)
    (define gamevector (make-vector  (* (+ 1 height) (+ 1 width))))
    (define changed #f)
    
    (define bitmap
      (new make-draw%
           [width width-px];;canvas/bitmaps size
           [height height-px]))
    

  
    (define background
      (new make-draw%
           [width width-px];;canvas/bitmaps size
           [height height-px]))
    
    (define (make-bg)
      (define (x-led x)
        (if (< x width)
            (begin
              (y-led 0 x)
              (x-led (+ x 2)))))
      
      (define (y-led y x)
        (if (< y height)
            (begin
              (send background draw-bitmap-2 (send *image-store* get-image 'bg)  (* *blocksize* y) (* *blocksize* x))
                
              (y-led (+ y 2) x))))
      (send background clear)
      (x-led 0);;starta
      )
    
    (define/public (update-bitmap)
      (define (loop index)
              (if (< index (vector-length gamevector))
                  (begin
                    (if (vector-ref gamevector index);;finns det något där eller inte?
                        (update-bitmap-help (vector-ref gamevector index) (get-pos-invers index)))
                    (loop (+ 1 index)))))
      (if changed
          (begin
            (send bitmap clear)
            (send bitmap draw-bitmap-2 (send background get-bitmap) 0 0)
            (loop 0))))

    (define/private (update-bitmap-help type pos)    
      (cond  
        ((eq? type 'indestructeble-stone)
         
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'non-dest-block)  (* *blocksize* (car pos)) (* *blocksize* (cdr pos))))
        ((eq? type 'destructeble-stone)
         (send bitmap draw-bitmap-2 (send *image-store* get-image 'dest-block)  (* *blocksize* (car pos)) (* *blocksize* (cdr pos))))))
    
    (define/public (get-bitmap)
      (send bitmap get-bitmap))
    
    (define/public (add-object-to-board! x y type) ;;lägger till ett objekt på en given position
      (vector-set! gamevector (get-pos x y) type)
      (set! changed #t))
    
    (define/public (delete-object-from-board! x y) ;; som ovan fast ta bort
      (vector-set! gamevector (get-pos x y) 0)
      (set! changed #t))
    
    (define/public (delete-destruct-from-board-radius! x y radius)
      (define emptyspaces '())
      (define delete-block '())
      (let loop ((x1-temp x) ;; den som ökar
                 (y1-temp y) ;; den som ökar
                 (x2-temp x) ;;den som minskar
                 (y2-temp y));; den som minskar
        
        
        
        (if  (or (<= x1-temp (+ x radius)) (>= x2-temp (- x radius)) (<= y1-temp (+ y radius)) (>= y2-temp (- y radius))) 
             (cond
               
               ((<= x1-temp (+ x radius))
                (cond 
                  
                  
                  ((eq? 'destructeble-stone (collision? x1-temp y))      
                   (set! delete-block (cons (list x1-temp y) delete-block))
                   ;(delete-object-from-board! x1-temp y) ;; ny lista på gång så att det fungerar med flammor osv som ska skrivas ut.
                   
                   (loop (+ x1-temp radius) y1-temp x2-temp y2-temp))
                  
                  ((eq? 'indestructeble-stone (collision? x1-temp y))
                   (loop (+ x1-temp radius) y1-temp x2-temp y2-temp))
                  
                  (else
                   (set! emptyspaces (cons (list x1-temp y 'r) emptyspaces))
                   (loop (+ x1-temp 1) y1-temp x2-temp y2-temp))))
               
               
               
               ((>= x2-temp (- x radius)) 
                (cond 
                  ((eq? 'destructeble-stone (collision? x2-temp y))
                   ;(delete-object-from-board! x2-temp y)
                   (set! delete-block (cons (list x2-temp y) delete-block))
                   (loop (+ x1-temp radius) y1-temp (- x2-temp radius) y2-temp))
                  
                  ((eq? 'indestructeble-stone (collision? x2-temp y))
                   (loop (+ x1-temp radius) y1-temp (- x2-temp radius) y2-temp))
                  
                  (else 
                   (set! emptyspaces (cons (list x2-temp y 'l) emptyspaces))
                   (loop (+ x1-temp radius) y1-temp (- x2-temp 1) y2-temp))))
               
               
               
               
               ((<= y1-temp (+ y radius)) 
                (cond
                  ((eq? 'destructeble-stone (collision? x y1-temp))
                   ;(delete-object-from-board! x y1-temp)
                   (set! delete-block (cons (list x y1-temp) delete-block))
                   (loop (+ x1-temp radius) (+ y1-temp radius) (- x2-temp radius) y2-temp))
                  
                  ((eq? 'indestructeble-stone (collision? x y1-temp))
                   (loop (+ x1-temp radius) (+ y1-temp radius) (- x2-temp radius) y2-temp))
                  
                  (else 
                   (set! emptyspaces (cons (list x y1-temp 'd) emptyspaces))
                   (loop (+ x1-temp radius) (+ y1-temp 1) (- x2-temp radius) y2-temp))))
               
               ((>= y2-temp (- y radius)) 
                (cond
                  ((eq? 'destructeble-stone (collision? x y2-temp))
                   ;(delete-object-from-board! x y2-temp)
                   (set! delete-block (cons (list x y2-temp) delete-block))
                   (loop (+ x1-temp radius) (+ y1-temp radius) (- x2-temp radius) (- y2-temp radius)))
                  
                  ((eq? 'indestructeble-stone (collision? x y2-temp))
                   (loop (+ x1-temp radius) (+ y1-temp radius) (- x2-temp radius) (- y2-temp radius)))
                  
                  (else 
                   (set! emptyspaces (cons (list x y2-temp 'u) emptyspaces))
                   (loop (+ x1-temp radius) (+ y1-temp radius) (- x2-temp radius) (- y2-temp 1))))))))
    (list emptyspaces
           delete-block);;return list of objects to delete and to add flames to
      )
      
    
    
    (define/public (delete-destruct-from-board-radius-2! x y radius) ;; som ovan fast med radie, och bara destructs.
      (define (x-led from to)
        (if (<= from to)
            (begin
              (if(eq? 'destructeble-stone (collision? from y))
                 (begin
                   (delete-object-from-board! from y)
                   (display x)(display " ")(display y)(newline)))
              (x-led (+ from 1) to))))
      
      (define (y-led from to)
        (if (<= from to)
            (begin
              (if(eq? 'destructeble-stone (collision? x from))
                 (begin
                   (delete-object-from-board! x from)
                   (display x)(display " ")(display y)(newline)))
              (y-led (+ from 1) to))))
      
      (x-led (- x radius) (+ x radius))
      (y-led (- y radius) (+ y radius))
      
      ) 
    
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
      (make-bg);;sätt bakgrund
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


                                         