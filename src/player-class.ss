;; ---------------------------------------------------------------------
;;====player-class.ss 
;;klass player%, skapar spelarobjektet 
;; ---------------------------------------------------------------------
(define player%
  (class object%
    (super-new)
    (init-field x-pos y-pos dxdy name lives color)
    (field
     (x-pos-px (* x-pos *blocksize*))
     (y-pos-px (* y-pos *blocksize*))
     (spawn-x-pos x-pos)
     (spawn-y-pos y-pos)
     (type 'player)
     (points 0)
     (radius 1)
     (delay 5000);; bombfördröjning i ms
     (bomb-count 1)
     (number-of-bombs 0);; hur många bomber på spelplanen
     (last-bomb-timestamp 0)
     (invincible-in-m-sec 10000)
     (timestamp-invincible 0)
     (last-bomb-place '());; (x . y)
     (direction 'd);;spelarens riktning
     (moving #f);;om spelaren rör sig eller inte
     (animation 1);;nuvarande frame i animationen
     (animation-start 1);;var den startar
     (animation-stop 5);;var den stannar
     (animation-duration 4);frames med samma bild
     (animation-duration-count 0);;frameräknare
     (name-font (make-object font% 15 'default 'normal 'bold))
     (status-font (make-object font% 10 'default 'normal 'bold))
     )
    
    ;;returnerar sant om tiden för odödlighet har gått ut
    (define/public (possible-to-die?)
      (<= (+ timestamp-invincible invincible-in-m-sec)
          (*current-m-sec*)))
    
    ;;funktion för att se om det går att lägga bomber just då, 
    ;;kollar med hur många man har på spelplanen 
    ;;och hur många man har möjlighet att lägga
    (define/public (can-bomb?)
      (and
       (< number-of-bombs bomb-count)
       (or
        (< (+ last-bomb-timestamp 1000)
           (*current-m-sec*)); en sek fördröjning eller 
        (not (and 
              (eq? x-pos (car last-bomb-place))
              (eq? y-pos (cdr last-bomb-place)))))));; inte samma ställe
    
    
    ;;funktion för att återfå bomber att lägga ut när de har sprängts
    (define/public (remv-bomb)
      (if(< 0 number-of-bombs)
         (set! number-of-bombs (- number-of-bombs 1))))
    
    
    ;;lägga ut bomb, sätter timer och sparar platsen.
    (define/public (add-bomb)
      (set! number-of-bombs (+ number-of-bombs 1))
      (set! last-bomb-timestamp (*current-m-sec*))
      (set! last-bomb-place (cons x-pos y-pos)))
    
    ;;dö-funktion som återsätter bomber mm till startvärde och minskar liv med 1
    (define/public (die)
      (set! lives (- lives 1))
      (set! number-of-bombs 0)
      (set! bomb-count 1)
      (set! dxdy 10)
      (set! radius 1)
      (set-x! spawn-x-pos)
      (set-y! spawn-y-pos)
      (set! timestamp-invincible (*current-m-sec*))
      (set! direction 'd))
    
    ;;sätt px pos och logisk pos
    (define/public (set-x-pos-px! x)
      (set! x-pos-px x)
      (set! x-pos (quotient
                   (+ x (/ *blocksize* 2))
                   *blocksize*)))
    
    ;;sätt px pos och logisk pos
    (define/public (set-y-pos-px! y)
      (set! y-pos-px y)
      (set! y-pos (quotient 
                   (+ y (/ *blocksize* 2))
                   *blocksize*)))
    
    ;;sätt px pos och logisk pos
    (define/public (set-x! x)
      (set! x-pos x)
      (set! x-pos-px (* x *blocksize*)))
    
    ;;sätt px pos och logisk pos
    (define/public (set-y! y)
      (set! y-pos y)
      (set! y-pos-px (* y *blocksize*)))
    
    ;;hämta px pos
    (define/public (get-y-pos-px)
      y-pos-px)
    
    ;;hämta px pos
    (define/public (get-x-pos-px)
      x-pos-px)
    
    ;; när man förflyttar sig
    (define/public (set-dir! dir)
      (set! moving #t)
      (set! direction dir))
    
    
    (define status-bitmap
      (new drawing%
           [width 170];;canvas-/bitmapsstorlek
           [height 100]))
    
    
    ;;Metod för att olika värden i status-bitmapen, 
    ;;som ligger till höger när spelet körs
    (define/public (update-status-bitmap)
      (send status-bitmap clear)
      (send status-bitmap set-background-color! 255 255 255 1)
      (send status-bitmap draw-text name 10 0 name-font)
      (send status-bitmap draw-bitmap-on-bitmap 
            (send *image-store* get-image 'max-panel) 60 40)
      (send status-bitmap draw-bitmap-on-bitmap 
            (send *image-store* get-image 'heart-panel) 20 40)
      (send status-bitmap draw-bitmap-on-bitmap 
            (send *image-store* get-image 'power-panel) 100 40)
      
      (send status-bitmap draw-text 
            (number->string lives) 40 40 status-font)
      (send status-bitmap draw-text 
            (number->string bomb-count) 80 40 status-font)
      (send status-bitmap draw-text 
            (number->string radius) 120 40 status-font))
    
    ;;Metod för att uppdatera status-bitmapen samt returnera den
    (define/public (get-status-bitmap)
      (update-status-bitmap)
      (send status-bitmap get-bitmap))
    
    (define bitmap
      (new drawing%
           [width 40];;canvas-/bitmapsstorlek
           [height 62]))
    
    
    
    (define/private (update-animation-help)
      (if moving
          (if(< animation-duration-count animation-duration)
             (set! animation-duration-count (+ animation-duration-count 1))
             (begin
               (set! animation-duration-count 0)
               (if(< animation animation-stop)
                  (set! animation (+ animation 1))
                  (set! animation animation-start))))
          (set! animation 0)))
    
    ;;uppdatera bitmap, lägger ev. till ödödlighetsbubbla om ej möjligt att dö
    (define/public (update-bitmap)
      (send bitmap clear)
      
      (update-animation-help)
      (set! moving #f)
      (send bitmap draw-bitmap-on-bitmap 
            (send *image-store* get-image color direction animation) 0 0)
      (if(not (possible-to-die?))
         (send bitmap draw-bitmap-on-bitmap
               (send *image-store* get-image 'invincible) 0 0)))
    
    ;;uppdatera och returnera bitmap
    (define/public (get-bitmap)
      (update-bitmap)
      (send bitmap get-bitmap))))



