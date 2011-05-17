;; ==== help-classes.ss 
;; ---------------------------------------------------------------------
;; class list-object% för att lägga till och tabort enkelt från listor
;; ---------------------------------------------------------------------

(define list-object%
  (class object%
    (super-new)
    (field 
     (inner-list '()))
    
    ;;lägg till i listan
    (define/public (add-to-list! wath-to-add)
      (set! inner-list 
            (cons 
             wath-to-add
             inner-list)))
    
    ;;tabort från listan
    (define/public (remove-from-list! wath-to-rem)
      (set! inner-list (remv wath-to-rem inner-list)))))
