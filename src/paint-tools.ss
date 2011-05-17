;; ---------------------------------------------------------------------
;;====paint-tools.ss 
;;klass make-paint-tools%
;; ---------------------------------------------------------------------
(define make-paint-tools%
  (class object%
    (super-new)
    ;; Färgerna att rita med:
    (define/public red-pen 
      (send the-pen-list find-or-create-pen "red" 4 'solid))
    (define/public green-pen 
      (send the-pen-list find-or-create-pen "green" 2 'solid))
    (define/public black-pen 
      (send the-pen-list find-or-create-pen "black" 2 'solid))
    (define/public blue-pen 
      (send the-pen-list find-or-create-pen "blue" 2 'solid))
    (define/public yellow-pen 
      (send the-pen-list find-or-create-pen "yellow" 2 'solid))
    (define/public white-pen 
      (send the-pen-list find-or-create-pen "white" 2 'solid))
    
    (define/public yellow-brush 
      (send the-brush-list find-or-create-brush "yellow" 'solid))
    (define/public red-brush 
      (send the-brush-list find-or-create-brush "red" 'solid))
    (define/public blue-brush 
      (send the-brush-list find-or-create-brush "blue" 'solid))
    (define/public green-brush 
      (send the-brush-list find-or-create-brush "green" 'solid))
    (define/public white-brush 
      (send the-brush-list find-or-create-brush "white" 'solid))
    (define/public black-brush 
      (send the-brush-list find-or-create-brush "black" 'solid))))