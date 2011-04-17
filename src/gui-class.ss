;; ---------------------------------------------------------------------
;; GUI
;; ---------------------------------------------------------------------
(define make-gui%
  (class object%
    (super-new)
    (init-field window-name width height image-buffer)
    (define gui-frame (new frame% 
                           [label window-name]
                           [min-width width]
                           [min-height height]))
    
   	 
    
    ;; show gui
    (define/public (show-gui)
      (send gui-frame show #t)
      (send gui-canvas focus));; move focus to canvas, to get key events
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
    
    (define rightpanel (new vertical-panel% 
                           [parent gui-frame]
                           [alignment '(right top)]))
    (define leftpanel (new vertical-panel% 
                            [parent gui-frame]
                            [min-width (get-field width image-buffer)]	 
                            [min-height (get-field height image-buffer)]
                            [alignment '(left top)]))
  
    (new button% [parent rightpanel]
         [label "Left"]
         [callback (lambda (button event)
                     (send msg set-label "Left click"))])
    (new button% [parent rightpanel]
         [label "Right"]
         [callback (lambda (button event)
                     (send msg set-label "Right click"))])
    ;(init-field test name)
    (instantiate button% 
      ("Quit" rightpanel (lambda (a b) (hide-gui)))
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
      (instantiate user-interact-canvas% ()
        (parent leftpanel)
        (paint-callback draw-canvas)
        (min-height (get-field height image-buffer))
        (min-width (get-field width image-buffer))
        (stretchable-width #f) 
        (stretchable-height #f)))))


