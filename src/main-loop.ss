;; --------------------------------------------------------------------
;; main loop
;; --------------------------------------------------------------------
(define make-loop%
  (class object%
    (super-new)
    (init-field function-to-loop)
    (define should-run #f)
    (define fps 24)
    (define paustime-timestamp-stop 0)
    (define paustime-tot 0)
    
    (define/public (start-loop)
      (when (not should-run)
        (set! should-run #t)
        (if(not (= 0 paustime-timestamp-stop))
           (begin
             (set! paustime-tot (+ paustime-tot (- (current-seconds) paustime-timestamp-stop)))
             (set! paustime-timestamp-stop 0)))
      (thread loop)))
    
    (define/public (stop-loop)
      (set! should-run #f)
      (set! paustime-timestamp-stop (current-seconds)))
    
    (define/public (running?)
      should-run)
    
    (define (fps->seconds fps)
      (/ 1 fps))
    
    
    (define/public (get-current-sec)
      (- (current-seconds) paustime-tot))
    
    (define sleep-time (fps->seconds fps))
    
    (define (loop)
      (when should-run
        (function-to-loop)
        (sleep sleep-time)
        (loop)))))



