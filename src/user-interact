(define my-canvas% 
  (class canvas%
    (override on-char)
    (init-field (key-callback #f))
    (define (on-char event)
      (when key-callback
        (key-callback event)))
    (super-instantiate ()))) 

(define (key-fn key-event)
  (let ((key (send key-event get-key-code)))
    (handle-key-event key)))



;; Handle keys pressd; space, +, -
(define (handle-key-event key)
    (cond
      ((eq? #\w key)(send test-logic move-dir 'u test-player))
      ((eq? #\a key)(send test-logic move-dir 'l test-player))
      ((eq? #\s key)(send test-logic move-dir 'd test-player))
      ((eq? #\d key)(send test-logic move-dir 'r test-player))
     ))
