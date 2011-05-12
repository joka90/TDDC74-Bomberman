;; ---------------------------------------------------------------------
;; Klass f�r att rita
;; ---------------------------------------------------------------------
(define make-draw%
  (class object%
    (super-new)
    (init-field width height)
    (define draw-buffer (make-object bitmap% width height #f #t))
    (define draw-dc (make-object bitmap-dc% draw-buffer))
    
    ;;f�r att rita upp igen
    (define/public (clear)
      (send draw-dc erase))
    
  
    (define/public (get-image canvas dc)
      (send dc draw-bitmap draw-buffer 0 0))
    
    
    (define/public (get-bitmap)
      draw-buffer)
    
    ;;returnerar bredd
    (define/public (get-width)
      width)
    
    ;;returnerar h�jd
    (define/public (get-height)
      height)
    
    ; En procedur som s�tter bakgrundsf�rgen p� GUI (p� slumpartat vis)
    (define/public (background)
      (send draw-dc set-background  (make-object color% (random 255) (random 255) (random 255))))
    
    ; En procedur som s�tter bakgrundsf�rgen p� GUI
    (define/public (set-background-color! r g b a)
      (send draw-dc set-background  (make-object color% r g b a)))
    
    ;; En procedur som s�tter bakgrundsf�rgen p� GUI till genomskinlig
    (define/public (background-transp)
      (send draw-dc set-background  (make-object color% 0 0 0 0)))
    
    (define/public (set-alpha! a)
      (send draw-dc set-alpha a))
    
    ;; En procedur som ritar en ellips
    (define/public (draw-circle x y size-x size-y pen brush)
      (send draw-dc set-pen pen)
      (send draw-dc set-brush brush)
      (send draw-dc draw-ellipse x y size-x size-y))
    
    ;; En procedur som ritar en rektangel
    (define/public (draw-rectangle x y size-x size-y pen brush)
      (send draw-dc set-pen pen)
      (send draw-dc set-brush brush)
      (send draw-dc draw-rectangle x y size-x size-y))
    
    ;; En procedur som ritar en linje
    (define/public (draw-line x y size-x size-y pen brush)
      (send draw-dc set-pen pen)
      (send draw-dc set-brush brush)
      (send draw-dc draw-line x y (+ x size-x) (+ y size-y)))
    
    ;; En procedur som ritar text
    (define/public (draw-text text x y font)
      (send draw-dc set-font font)
      (send draw-dc draw-text text x y))
    
    ;; En procedur som ritar en bild fr�n en bitmap
    (define/public (draw-bitmap-2 bitmap x y)
      ;;send to main bitmap
      (send draw-dc draw-bitmap bitmap x y))
    
    ))
