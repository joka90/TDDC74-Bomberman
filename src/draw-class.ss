;; ---------------------------------------------------------------------
;; class to draw
;; ---------------------------------------------------------------------
(define make-draw%
  (class object%
    (super-new)
    (init-field width height)
    (define draw-buffer (make-object bitmap% width height #f #t))
    (define draw-dc (make-object bitmap-dc% draw-buffer))
    
    (define/public (clear)
      (send draw-dc clear))
    
  
    (define/public (get-image canvas dc)
      (send dc draw-bitmap draw-buffer 0 0))
    
    (define/public (get-bitmap)
      draw-buffer)
    
    (define/public (get-width)
      width)
    
    (define/public (get-height)
      height)
    
    ; A procedure that sets the background color of the GUI
    (define/public (background)
      (send draw-dc set-background  (make-object color% (random 255) (random 255) (random 255))))
    
    ; A procedure that sets the background color of the GUI
    (define/public (set-background-color! r g b)
      (send draw-dc set-background  (make-object color% r g b)))
    
    (define/public (background-transp)
      (send draw-dc set-background  (make-object color% 0 0 0 0)))
    
    
    ;; A procedures that draws an ellipse
    (define/public (draw-circle x y size-x size-y pen brush)
      (send draw-dc set-pen pen)
      (send draw-dc set-brush brush)
      (send draw-dc draw-ellipse x y size-x size-y))
    
    ;; A procedures that draws a rectangle
    (define/public (draw-rectangle x y size-x size-y pen brush)
      (send draw-dc set-pen pen)
      (send draw-dc set-brush brush)
      (send draw-dc draw-rectangle x y size-x size-y))
    
    ;; A procedures that draws a line
    (define/public (draw-line x y size-x size-y pen brush)
      (send draw-dc set-pen pen)
      (send draw-dc set-brush brush)
      (send draw-dc draw-line x y (+ x size-x) (+ y size-y)))
    
    ;; A procedures that draws text
    (define/public (draw-text text x y 
                              ;pen brush
                              )
      ;(send draw-dc set-pen pen)
      ;(send draw-dc set-brush brush)
      (send draw-dc draw-text text x y))
    
    ;; A procedures that draws a picture from file
    (define/public (draw-pic file x y)
      (send draw-dc draw-bitmap (make-object bitmap% file 'unknown #f) x y))
    
    ;; A procedures that draws a picture from a bitmap
    (define/public (draw-bitmap-2 bitmap x y)
      ;;send to main bitmap
      (send draw-dc draw-bitmap bitmap x y 'solid (make-object color% 0 0 0) (send bitmap get-loaded-mask)))
    
    ))
