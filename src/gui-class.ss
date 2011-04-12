;(load "paint-tools")
;(load "draw-class")

(define *draw*
  (new make-draw%
       [width 500]
       [height 500]))
;(define *paint-tools*
 ; (new make-paint-tools%))


;; ---------------------------------------------------------------------
;; GUI
;; ---------------------------------------------------------------------


(define make-gui%
  (class object%
    (super-new)
    (init-field window-name width height image-buffer (key-callback2 #f))
    (define gui-frame (make-object frame% window-name))
    
    ;; show gui
    (define/public (show-gui)
      (send gui-frame show #t))
    ;; hide gui
    (define/public (hide-gui)
      (send gui-frame show #f))
    
    ;; update canvas to see changes in draw buffer
    (define/public (redraw)
      (send gui-canvas on-paint))
    
    (define/public (get-width)
      (send gui-canvas get-width))
    
    (define/public (get-height)
      (send gui-canvas get-height))
    ;; get new canvas from global draw class on redraw
    (define (draw-canvas canvas dc)
      (send image-buffer get-image canvas dc))
    
    
    ;(init-field test name)
    (instantiate button% 
      ("Quit" gui-frame (lambda (a b) (hide-gui)))
      (horiz-margin 2)
      (vert-margin 2)
      (stretchable-width #f))
    
    (define gui-menu-bar
      (instantiate menu-bar%
        (gui-frame)))
    
    (define gui-menu
      (instantiate menu%
        ("Menu" gui-menu-bar)))
    
    (instantiate menu-item%
      ("Quit" gui-menu (lambda (a b) (hide-gui))))
    

    (define gui-canvas
      (instantiate my-canvas% ()
        (parent gui-frame)
        (paint-callback draw-canvas)
        (key-callback key-callback2)
        (min-height height)
        (min-width width)
        (stretchable-width #f) 
        (stretchable-height #f)))))

(define *gui*
  (new make-gui%
       [window-name "New gui!"]
       [width 500]
       [height 500]
       [image-buffer *draw*]
       [key-callback2 key-fn]))


