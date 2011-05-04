;; ---------------------------------------------------------------------
;; class list-object% to add and remove easely from a list
;; ---------------------------------------------------------------------

(define list-object%
  (class object%
    (super-new)
    (field 
     (inner-list '()))
    
    
    (define/public (add-to-list! wath-to-add)
      (set! inner-list 
            (cons 
             wath-to-add
             inner-list)))
    
    (define/public (remove-from-list! wath-to-rem)
      (set! inner-list (remv wath-to-rem inner-list)))
    ))
