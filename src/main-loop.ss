;; --------------------------------------------------------------------
;; main loop
;; --------------------------------------------------------------------
(define loop-this-proc%
  (class object%
    (super-new)
    (init-field function-to-loop fps)
    (define should-run #f)
    (define paustime-timestamp-stop 0)
    (define paustime-tot 0)
    
    ;;metod för att starta loopen
    (define/public (start-loop)
      (when (not should-run)
        (set! should-run #t)
        (if(not (= 0 paustime-timestamp-stop))
           (begin
             (set! paustime-tot 
                   (+ paustime-tot (- (current-inexact-milliseconds)
                                      paustime-timestamp-stop)))
             (set! paustime-timestamp-stop 0)))
        (thread loop)))
    
    ;;för att stoppa loopen
    (define/public (stop-loop)
      (set! should-run #f)
      (set! paustime-timestamp-stop (current-inexact-milliseconds)))
    
    ;;returnerar sant eller falskt beroende på om loopen körs
    (define/public (running?)
      should-run)
    
    ;;sekunder per frame
    (define (fps->seconds fps)
      (/ 1 fps))
    
    ;;hämta nuvarande millisekund
    (define/public (get-current-m-sec)
      (- (current-inexact-milliseconds) paustime-tot))
    
    ;;låter loopen sova visst antal sekunder för att den inte ska gå för fort
    (define sleep-time (fps->seconds fps))
    
    ;;loopen som kör igenom funktionen som ska loopas
    (define (loop)
      (when should-run
        (function-to-loop)
        (sleep sleep-time)
        (loop)))))



