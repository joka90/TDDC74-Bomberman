;; definera en spelplan med en viss längd och bredd
(define board%
  (class object%
    (super-new)
    (init-field height width height-px width-px)
    (field
     (gamevector (make-vector  (* (+ 1 height) (+ 1 width))))
     (changed #f))
 
    (define/public (add-object-to-board! x y type) ;;lägger till ett objekt på en given position
      (vector-set! gamevector (get-pos x y) type)
      (set! changed #t))
    
    ;;delete object from board and if unsuccessfull return false
    (define/public (delete-object-from-board! x y) ;; som ovan fast ta bort
      (let((object (get-object-at-pos x y)))
        (if (not (eq? object 0))
            (begin
              (vector-set! gamevector (get-pos x y) 0)
              (set! changed #t))
            #f)))
    
    (define/public (get-pos x y)
      (+ x (* y width))) ;; översätter vektorn till ett koordinatsystem med (x,y)
    
    ;;Räknar ut x och y-pos utifrån given pos i vektorn.
    ;; (x-pos . y-pos)
    ;; om utanför, retunera false
    (define/public  (get-pos-invers pos)
      (cons (remainder pos (+ 0 width)) (quotient pos (+ 0 width))))
    
    (define/public (get-object-at-pos x y)
      (vector-ref gamevector (get-pos x y)))
    
    (define/public (delete-destruct-from-board-radius! x y radius)
      (let ((x1-run? #t)
            (y1-run? #t)
            (x2-run? #t)
            (y2-run? #t))
        (define limits '())
        (define emptyspaces '())
        (define delete-block '())
        (let loop ((x1-temp x) ;; den som ökar
                   (y1-temp y) ;; den som ökar
                   (x2-temp x) ;;den som minskar
                   (y2-temp y);; den som minskar
                   )
          
          (cond
            ((and (<= x1-temp (+ x radius)) x1-run?)
             (cond
               ((eq? 'destructeble-stone (collision? x1-temp y))
                (set! delete-block (cons (list x1-temp y 'r) delete-block))
                (set! x1-run? #f)
                (loop x1-temp y1-temp x2-temp y2-temp));;hoppa ur denna loopen
               
               ((eq? 'indestructeble-stone (collision? x1-temp y))
                (set! x1-run? #f)
                (loop x1-temp y1-temp x2-temp y2-temp));;hoppa ur denna loopen
               (else
                (set! emptyspaces (cons (list x1-temp y 'r) emptyspaces))
                (loop (+ x1-temp 1) y1-temp x2-temp y2-temp))));;fortsätt denna loop
            
            ((and (>= x2-temp (- x radius)) x2-run?)
             (cond
               ((eq? 'destructeble-stone (collision? x2-temp y))
                (set! delete-block (cons (list x2-temp y 'l) delete-block))
                (set! x2-run? #f)
                (loop x1-temp y1-temp x2-temp y2-temp))
               
               ((eq? 'indestructeble-stone (collision? x2-temp y))
                (set! x2-run? #f)
                (loop x1-temp y1-temp x2-temp y2-temp))
               
               (else
                (set! emptyspaces (cons (list x2-temp y 'l) emptyspaces))
                (loop x1-temp y1-temp (- x2-temp 1) y2-temp))))
            
            
            ((and (<= y1-temp (+ y radius)) y1-run?)
             (cond
               ((eq? 'destructeble-stone (collision? x y1-temp))
                (set! delete-block (cons (list x y1-temp 'd) delete-block))
                (set! y1-run? #f)
                (loop x1-temp y1-temp x2-temp y2-temp))
               
               ((eq? 'indestructeble-stone (collision? x y1-temp))
                (set! y1-run? #f)
                (loop x1-temp y1-temp x2-temp y2-temp))
               
               (else
                (set! emptyspaces (cons (list x y1-temp 'd) emptyspaces))
                (loop x1-temp (+ y1-temp 1) x2-temp y2-temp))))
            
            ((and (>= y2-temp (- y radius)) y2-run?)
             (cond
               ((eq? 'destructeble-stone (collision? x y2-temp))
                (set! delete-block (cons (list x y2-temp 'u) delete-block))
                (set! y2-run? #f)
                (loop x1-temp y1-temp x2-temp y2-temp))
               
               ((eq? 'indestructeble-stone (collision? x y2-temp))
                (set! y2-run? #f)
                (loop x1-temp y1-temp x2-temp y2-temp))
               
               (else
                (set! emptyspaces (cons (list x y2-temp 'u) emptyspaces))
                (loop x1-temp y1-temp x2-temp (- y2-temp 1)))))
            
            (else
             ;;Set limits relative to bomb
             (set! limits (list
                           (cons 'r (- x1-temp x 1))
                           (cons 'd (- y1-temp y 1))
                           (cons 'l (- x x2-temp 1))
                           (cons 'u (- y y2-temp 1)))))
          
            
            ))
        
        
        (list
         emptyspaces
         delete-block
         limits);;return list of objects to delete, to add flames to
        ))
      
    
    
    
    ;; #f innebär tomt, annars returneras vilken typ av objekt som ligger på positionen. 
    (define/public (collision? x y) ;; kollar om det ligger något på en viss position.
      (let((object (get-object-at-pos x y)))
        (if(and (<= 0 x) (<= 0 y) (< x width) (<= y height))
           (if (eq? object 0)
               #f
               object)
           #f)))
    
    
    ;;help function to check if to add random stone at a pos.
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
            (send bitmap draw-bitmap-2
                  (send background get-bitmap) 0 0)
            (loop 0))))
    
    (define/private (update-bitmap-help type pos)    
      (cond  
        ((eq? type 'indestructeble-stone)
         
         (send bitmap draw-bitmap-2
               (send *image-store* get-image 'non-dest-block) 
               (* *blocksize* (car pos))
               (* *blocksize* (cdr pos))))
        ((eq? type 'destructeble-stone)
         (send bitmap draw-bitmap-2
               (send *image-store* get-image 'dest-block) 
               (* *blocksize* (car pos))
               (* *blocksize* (cdr pos))))))
    
    (define/public (get-bitmap)
      (send bitmap get-bitmap))
    
    ))


