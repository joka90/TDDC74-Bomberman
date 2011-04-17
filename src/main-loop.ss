;; --------------------------------------------------------------------
;; main loop
;; --------------------------------------------------------------------
(define make-loop%
  (class object%
    (super-new)
    (init-field function-to-loop)
    (define should-run #f)
    
    (define/public (start-loop)
      (when (not should-run)
        (set! should-run #t)
        (thread loop)))
    
    (define/public (stop-loop)
      (set! should-run #f))
    
    (define/public (running?)
      should-run)
    
    (define (fps->seconds fps)
      (/ 1 fps))
    
    (define sleep-time (fps->seconds 24))
    
    (define (loop)
      (when should-run
        (function-to-loop)
        (sleep sleep-time)
        (loop)))))



